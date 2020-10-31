import Dispatch

public func debounce<T: Equatable>(
  _ duration: DispatchTimeInterval,
  on queue: DispatchQueue = DispatchQueue(label: DOMAIN("debounce"))
) ->  Operator<T, T> {
  return { source in
    return { sink in
      var talkback: Optional<SourceTalkback<T>> = .none
      var didReceiveCompletion: Bool = false
      let lock = RecursiveLock(label: DOMAIN("debounce"))
      var pendingElement: Optional<Sink<T>> = .none
      source { payload in
        lock.withLock {
          switch payload {
          case let .start(tb):
            talkback = tb
            sink(.whenReceiveCompletion({ lock.withLock { didReceiveCompletion = true } }))
            talkback?(.next(.none))
          case .next:
            if !didReceiveCompletion {
              pendingElement = payload
              queue.asyncAfter(deadline: .now() + duration) {
                lock.withLock {
                  if pendingElement == payload {
                    pendingElement = .none
                    sink(payload)
                  }
                }
              }
              talkback?(.next(.none))
            } else {
              pendingElement = .none
              talkback?(.completed(.finished))
            }
          case .completed:
            queue.asyncAfter(deadline: .now() + duration) {
              lock.withLock {
                if let element = pendingElement {
                  pendingElement = .none
                  sink(element)
                }
                sink(payload)
              }
            }
          }
        }
      }
    }
  }
}