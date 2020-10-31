import Dispatch

public func wait<T>(
  _ duration: DispatchTimeInterval,
  on queue: DispatchQueue = DispatchQueue(label: DOMAIN("wait"))
) ->  Operator<T, T> {
  return { source in
    return { sink in
      var talkback: Optional<SourceTalkback<T>> = .none
      var didReceiveCompletion: Bool = false
      let lock = RecursiveLock(label: DOMAIN("wait"))
      var shouldSink: Bool = true
      var pendingSinksCount: Int = 0
      func asyncComplete(_ payload: Sink<T>) {
        queue.asyncAfter(deadline: .now() + duration) {
          lock.withLock {
            if payload.isForcedToComplete || pendingSinksCount == 0 {
              shouldSink = false
              sink(payload)
            } else {
              asyncComplete(payload)
            }
          }
        }
      }
      source { payload in
        lock.withLock {
          switch payload {
          case let .start(tb):
            talkback = tb
            sink(.whenReceiveCompletion({ lock.withLock { didReceiveCompletion = true } }))
            talkback?(.next(.none))
          case .next:
            if !didReceiveCompletion {
              pendingSinksCount += 1
              queue.asyncAfter(deadline: .now() + duration) {
                lock.withLock {
                  pendingSinksCount -= 1
                  if shouldSink {
                    sink(payload)
                  }
                }
              }
              talkback?(.next(.none))
            } else {
              talkback?(.completed(.finished))
            }
          case .completed:
            asyncComplete(payload)
          }
        }
      }
    }
  }
}