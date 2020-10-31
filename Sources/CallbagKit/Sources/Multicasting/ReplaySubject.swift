public func makeReplaySubject<T>() -> Subject<T> {
  var elements: Array<T> = .init()
  var sinks: Array<Optional<(Sink<T>) -> Void>> = .init()
  let lock: RecursiveLock = RecursiveLock(label: DOMAIN("makeReplaySubject"))
  var getCompletion: Optional<Completion> = .none
  return { payload in
    lock.withLock {
      switch payload {
      case let .start(sink):
        if let completion = getCompletion {
          sink(.start({ _ in }))
          sink(.completed(completion))
        } else {
          let index = sinks.endIndex
          sinks.append(sink)
          var shouldContinueSinking: Bool = true
          sink(.whenReceiveCompletion({
            shouldContinueSinking = false
            sink(.completed(.finished))
            lock.withLock {
              sinks[index] = .none
            }
          }))
          var iterator = elements.makeIterator()
          while let element = iterator.next(), shouldContinueSinking {
            sink(.next(element))
          }
        }
      case let .next(element):
        if let element = element as? T {
          elements.append(element)
          var iterator = sinks.makeIterator()
          while let sink = iterator.next() {
            sink?(.next(element))
          }
        }
      case let .completed(completion):      
        getCompletion = completion
        var iterator = sinks.makeIterator()
        while let sink = iterator.next() {
          sink?(.completed(completion))
        }
        sinks = []
      }
    }
  }
}