import func Foundation.raise
import let Foundation.SIGTRAP

public func breakpoint<T>(
  _ receive: @escaping (Sink<T>) -> Bool
) ->  Operator<T, T> {
  return { source in
    return { sink in
      source { payload in
        switch payload {
        case let .start(tb):
          if receive(payload) {
            raise(SIGTRAP)
          } else {
            sink(.talkback(tb))
          }
        case .next:
          if receive(payload) {
            raise(SIGTRAP)
          } else {
            sink(payload)
          }
        case .completed:
          if receive(payload) {
            raise(SIGTRAP)
          } else {
            sink(payload)
          }
        }
      }
    }
  }
}

public func breakpoint<T>(
  receiveStart: ((SourceTalkback<T>) -> Bool)? = nil,
  receiveElement: ((T) -> Bool)? = nil,
  receiveCompletion: ((Completion) -> Bool)? = nil
) ->  Operator<T, T> {
  return { source in
    return { sink in
      source { payload in
        switch payload {
        case let .start(tb):
          if receiveStart?(tb) ?? false {
            raise(SIGTRAP)
          } else {
            sink(.talkback(tb))
          }
        case let .next(element):
          if receiveElement?(element) ?? false {
            raise(SIGTRAP)
          } else {
            sink(payload)
          }
        case let .completed(completion):
          if receiveCompletion?(completion) ?? false {
            raise(SIGTRAP)
          } else {
            sink(payload)
          }
        }
      }
    }
  }
}