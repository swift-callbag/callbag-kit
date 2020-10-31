public func retry<T>(
  _ countOfRetries: Int
) ->  Operator<T, T> {
  return { source in
    return { sink in
      var talkback: Optional<SourceTalkback<T>> = .none
      var didReceiveCompletion: Bool = false
      var countOfRetries = countOfRetries
      func retry() {
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
            if countOfRetries > 0 {
              countOfRetries = countOfRetries - 1
              retry()
            } else {
              sink(.completed(.failed(error)))
            }
          case .completed:
            sink(payload)
          }
        }
      }
      sink(.whenReceiveCompletion({ didReceiveCompletion = true }))
      retry()
    }
  }
}