public func repeats<T>(
  _ countOfRetries: Int
) ->  Operator<T, T> {
  return { source in
    return { sink in
      var talkback: Optional<SourceTalkback<T>> = .none
      var didReceiveCompletion: Bool = false
      var countOfRetries = countOfRetries
      func repeats() {
        source { payload in
          switch payload {
          case let .start(tb):
            talkback = tb
            talkback?(.next(.none))
          case .next:
            if !didReceiveCompletion {
              sink(payload)
              talkback?(.next(.none))
            } else {
              talkback?(.completed(.finished))
            }
          case let .completed(.failed(error)):
            sink(.completed(.failed(error)))
          case .completed:
            if countOfRetries > 1 && !didReceiveCompletion {
              countOfRetries = countOfRetries - 1
              repeats()
            } else {
              sink(payload)
            }
          }
        }
      }
      sink(.whenReceiveCompletion({ didReceiveCompletion = true }))
      repeats()
    }
  }
}

public func repeats<T>() ->  Operator<T, T> {
  return { source in
    return { sink in
      var talkback: Optional<SourceTalkback<T>> = .none
      var didReceiveCompletion: Bool = false
      func repeats() {
        source { payload in
          switch payload {
          case let .start(tb):
            talkback = tb
            talkback?(.next(.none))
          case .next:
            if !didReceiveCompletion {
              sink(payload)
              talkback?(.next(.none))
            } else {
              talkback?(.completed(.finished))
            }
          case let .completed(.failed(error)):
            sink(.completed(.failed(error)))
          case .completed:
            if !didReceiveCompletion {
              repeats()
            } else {
              sink(payload)
            }
          }
        }
      }
      sink(.whenReceiveCompletion({ didReceiveCompletion = true }))
      repeats()
    }
  }
}