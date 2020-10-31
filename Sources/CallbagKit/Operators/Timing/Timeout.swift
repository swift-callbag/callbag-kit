import Dispatch

public func timeout<T>(
  _ duration: DispatchTimeInterval,
  on queue: DispatchQueue = DispatchQueue(label: DOMAIN("timeout")),
  customError: Error? = nil
) ->  Operator<T, T> {
  return { source in
    return { sink in
      var talkback: Optional<SourceTalkback<T>> = .none
      var didReceiveCompletion: Bool = false
      let lock = RecursiveLock(label: DOMAIN("timeout"))
      var latestStamp: DispatchTime = .now()
      var didPassDuration: Bool = false
      func asyncSink() {
        queue.asyncAfter(deadline: .now() + duration) {
          lock.withLock {
            didPassDuration = DispatchTime.now() > (latestStamp + duration)
            if didPassDuration {
              talkback?(.completed(.finished))
            } else {
              asyncSink()
            }
          }
        }
      }
      asyncSink()
      source { payload in
        switch payload {
        case let .start(tb):
          talkback = tb
          sink(.whenReceiveCompletion({ lock.withLock { didReceiveCompletion = true } }))
          talkback?(.next(.none))
        case .next:
          queue.async {
            lock.withLock {
              if !didReceiveCompletion {
                latestStamp = DispatchTime.now()
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
              if didPassDuration {
                if let error = customError {
                  sink(.completed(.failed(error)))
                } else {
                  sink(.completed(.finished))
                }
              } else {
                sink(payload)
              }
            }
          }
        }
      }
    }
  }
}