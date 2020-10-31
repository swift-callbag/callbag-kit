public func tap<T>(
  _ sideEffect: @escaping (Sink<T>) -> Void
) ->  Operator<T, T> {
  return { source in
    return { sink in
      source { payload in
        switch payload {
        case let .start(tb):
          sideEffect(payload)
          sink(.talkback(tb))
        case .next:
          sideEffect(payload)
          sink(payload)
        case .completed:
          sideEffect(payload)
          sink(payload)
        }
      }
    }
  }
}

public func tap<T>(
  receiveStart: ((SourceTalkback<T>) -> Void)? = nil,
  receiveElement: ((T) -> Void)? = nil,
  receiveCompletion: ((Completion) -> Void)? = nil
) ->  Operator<T, T> {
  return { source in
    return { sink in
      source { payload in
        switch payload {
        case let .start(tb):
          receiveStart?(tb)
          sink(.talkback(tb))
        case let .next(element):
          receiveElement?(element)
          sink(payload)
        case let .completed(completion):
          receiveCompletion?(completion)
          sink(payload)
        }
      }
    }
  }
}