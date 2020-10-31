public func ignoreElements<T>() ->  Operator<T, T> {
  return { source in
    return { sink in
      var talkback: Optional<SourceTalkback<T>> = .none
      source { payload in
        switch payload {
        case let .start(tb):
          talkback = .some(tb)
          sink(.talkback(tb))
        case .next:
          talkback?(.next(.none))
        case .completed:
          sink(payload)
        }
      }
    }
  }
}