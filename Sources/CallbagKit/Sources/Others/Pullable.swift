public func pullable<T>(_ source: @escaping Producer<T>) -> Producer<T> {
  return { sink in
    var talkback: Optional<SourceTalkback<T>> = .none
    let elements: UnsafeArray<T> = .init()
    var getCompletion: Optional<Completion> = .none
    let lock = RecursiveLock(label: DOMAIN("pullable"))
    source { payload in
      lock.withLock {
        switch payload {
        case let .start(tb):
          talkback = .some(tb)
        case let .next(element):
          elements.append(element)
        case let .completed(completion):
          getCompletion = completion
        }
      }
    }
    sink(.start({ payload in
      switch payload {
      case .start: return
      case .next:
        talkback?(.next(.none))
        while true {
          lock.lock(); defer { lock.unlock() }
          if elements.first != nil || getCompletion != .none { break }
        }
        lock.withLock {
          if let completion = getCompletion, elements.first == nil {
            sink(.completed(completion))
          } else {
            sink(.next(elements.removeFirst()))
          }
        }
      case .completed:
        if let completion = getCompletion {
          sink(.completed(completion))
        } else  {
          talkback?(.completed(.finished))
          lock.withLock {
            getCompletion = .finished
            elements.removeAll()
          }
          sink(.completed(.finished))
        }
      }
    }))
  }
}