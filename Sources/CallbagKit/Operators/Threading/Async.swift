import Dispatch

public func async<T>(
  on queue: DispatchQueue = DispatchQueue(label: DOMAIN("async"))
) ->  Operator<T, T> {
  return { source in
    return { sink in
      var talkback: Optional<SourceTalkback<T>> = .none
      var didReceiveCompletion: Bool = false
      let lock = RecursiveLock(label: DOMAIN("async"))
      source { payload in
        switch payload {
        case let .start(tb):
          talkback = tb
          sink(.whenReceiveCompletion({
            lock.withLock { didReceiveCompletion = true }
          }))
          talkback?(.next(.none))
        case .next:
          queue.async {
            lock.withLock {
              if !didReceiveCompletion {
                sink(payload)
                talkback?(.next(.none))
              } else {
                talkback?(.completed(.finished))
              }
            }
          }
        case .completed:
          queue.async {
            lock.withLock {
              sink(payload)
            }
          }
        }
      }
    }
  }
}