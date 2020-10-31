import Dispatch

public enum ThrottleStrategy {
  case earliest, latest
}

public func throttle<T>(
  _ duration: DispatchTimeInterval,
  on queue: DispatchQueue = DispatchQueue(label: DOMAIN("throttle")),
  strategy: ThrottleStrategy = .latest
) ->  Operator<T, T> {
  return { source in
    return { sink in
      var talkback: Optional<SourceTalkback<T>> = .none
      var didReceiveCompletion: Bool = false
      let lock = RecursiveLock(label: DOMAIN("throttle"))
      var elements = Array<Sink<T>>()
      var didSendCompletion = false
      func asyncSink() {
        queue.asyncAfter(deadline: .now() + duration) {
          lock.withLock {
            if !didReceiveCompletion && !didSendCompletion {
              if elements.count > 0 {
                switch strategy {
                case .earliest: sink(elements[0])
                case .latest:   sink(elements[elements.count-1])
                }
                elements = []
              }
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
                elements.append(payload)
                talkback?(.next(.none))
              } else {
                elements = []
                talkback?(.completed(.finished))
              }
            }
          }
        case .completed:
          queue.asyncAfter(deadline: .now() + duration) {
            lock.withLock {
              didSendCompletion = true
              if elements.count > 0 {
                switch strategy {
                case .earliest: sink(elements[0])
                case .latest:   sink(elements[elements.count-1])
                }
                elements = []
              }
              sink(payload)
            }
          }
        }
      }
    }
  }
}