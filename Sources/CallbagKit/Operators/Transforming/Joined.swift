public func joined<T>(_ separator: T) ->  Operator<T, T> {
  return { source in
    return { sink in
      var talkback: Optional<SourceTalkback<T>> = .none
      var didReceiveCompletion: Bool = false
      var recentElement: Optional<Sink<T>> = .none
      source { payload in
        switch payload {
        case let .start(tb):
          talkback = .some(tb)
          sink(.whenReceiveCompletion({ didReceiveCompletion = true }))
          talkback?(.next(.none))
        case .next:
          if !didReceiveCompletion {
            if case let .some(element) = recentElement {
              recentElement = payload
              sink(element)
              if !didReceiveCompletion {
                sink(.next(separator))
                talkback?(.next(.none))
              } else {
                talkback?(.completed(.finished))
              }
            } else {
              recentElement = payload
              talkback?(.next(.none))
            }
          } else {
            talkback?(.completed(.finished))
          }
        case .completed:
          if !didReceiveCompletion {
            if case let .some(element) = recentElement {
              sink(element)
            }
          }
          sink(payload)
        }
      }
    }
  }
}