public func makeBehaviorSubject<T>(_ element: T) -> Subject<T> {
  var latestElement: T = element
  var sinks: Array<Optional<(Sink<T>) -> Void>> = .init()
  let lock: RecursiveLock = RecursiveLock(label: DOMAIN("makeBehaviorSubject"))
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
          sink(.whenReceiveCompletion({
            sink(.completed(.finished))
            lock.withLock {
              sinks[index] = .none
            }
          }))
          sink(.next(latestElement))
        }
      case let .next(element):
        if let element = element as? T {
          latestElement = element
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