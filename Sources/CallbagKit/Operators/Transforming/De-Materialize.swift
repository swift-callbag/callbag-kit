public func materialize<T>() ->  Operator<T, Sink<T>> {
  return { source in
    return { sink in
      var talkback: Optional<SourceTalkback<T>> = .none
      var didReceiveCompletion: Bool = false
      source { payload in
        switch payload {
        case let .start(tb):
          talkback = .some(tb)
          sink(.whenReceiveCompletion({ didReceiveCompletion = true }))
          talkback?(.next(.none))
        case let .next(element):
          if !didReceiveCompletion {
            sink(.next(.next(element)))
            talkback?(.next(.none))
          } else {
            talkback?(.completed(.finished))
          }
        case let .completed(completion):
          if !didReceiveCompletion {
            sink(.next(.completed(completion)))
          }
          sink(.completed(completion))
        }
      }
    }
  }
}

public func dematerialize<T>() ->  Operator<Sink<T>, T> {
  return { source in
    return { sink in
      var talkback: Optional<SourceTalkback<Sink<T>>> = .none
      var didReceiveCompletion: Bool = false
      var didSendCompletion: Bool = false
      source { payload in
        switch payload {
        case let .start(tb):
          talkback = .some(tb)
          sink(.whenReceiveCompletion({ didReceiveCompletion = true }))
          talkback?(.next(.none))
        case let .next(payload):
          if !didReceiveCompletion {
            switch payload {
            case .start:
              talkback?(.next(.none))
            case .next:
              sink(payload)
              talkback?(.next(.none))
            case .completed:
              didSendCompletion = true
              sink(payload)
              talkback?(.completed(.finished))
            }
          } else {
            talkback?(.completed(.finished))
          }
        case let .completed(completion):
          if !didSendCompletion {
            sink(.completed(completion))
          }
        }
      }
    }
  }
}