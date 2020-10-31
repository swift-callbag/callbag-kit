public func makeAsyncSubject<T>() -> Subject<T> {
  var latestElement: Optional<T> = .none
  var sinks: Array<Optional<(Sink<T>) -> Void>> = .init()
  let lock: RecursiveLock = RecursiveLock(label: DOMAIN("makeAsyncSubject"))
  var getCompletion: Optional<Completion> = .none
  return { payload in
    lock.withLock {
      switch payload {
      case let .start(sink):
        if let completion = getCompletion {
          sink(.start({ _ in }))
          if case .finished = completion, let element = latestElement {
            sink(.next(element))
          }
          sink(.completed(completion))
        } else {
          let index = sinks.endIndex
          sinks.append(sink)
          sink(.whenReceiveCompletion({
            sink(.completed(.finished))
            lock.withLock {
              sinks[index] = .none
            }
          }))
        }
      case let .next(element):
        if let element = element as? T {
          latestElement = element
        }
      case let .completed(completion):      
        getCompletion = completion
        var iterator = sinks.makeIterator()
        if case .finished = completion, let element = latestElement {
          while let sink = iterator.next() {
            sink?(.next(element))
          }
        }
        while let sink = iterator.next() {
          sink?(.completed(completion))
        }
        sinks = []
      }
    }
  }
}