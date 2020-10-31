import Dispatch

public func delay<T>(
  _ duration: DispatchTimeInterval,
  on queue: DispatchQueue = DispatchQueue(label: DOMAIN("delay"))
) ->  Operator<T, T> {
  return { source in
    return { sink in
      queue.asyncAfter(deadline: .now() + duration) {
        source { payload in
          switch payload {
          case let .start(tb):
            sink(.talkback(tb))
          case .next:
            sink(payload)
          case .completed:
            sink(payload)
          }
        }
      }
    }
  }
}