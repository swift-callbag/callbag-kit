public func sync<T>() ->  Operator<T, T> {
  return { source in
    return { sink in
      var talkback: Optional<SourceTalkback<T>> = .none
      var didReceiveCompletion: Bool = false
      let lock = RecursiveLock(label: DOMAIN("sync"))
      source { payload in
        switch payload {
        case let .start(tb):
          talkback = tb
          sink(.whenReceiveCompletion({
            lock.withLock { didReceiveCompletion = true }
          }))
          talkback?(.next(.none))
        case .next:
          lock.withLock {
            if !didReceiveCompletion {
              sink(payload)
              talkback?(.next(.none))
            } else {
              talkback?(.completed(.finished))
            }
          }
        case .completed:
          lock.withLock {
            didReceiveCompletion = true
            sink(payload)
          }
        }
      }
    }
  }
}