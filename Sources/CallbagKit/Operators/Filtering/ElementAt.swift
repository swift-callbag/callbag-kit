public func elementAt<T>(_ index: Int) ->  Operator<T, T> {
  return { source in
    return { sink in
      var talkback: Optional<SourceTalkback<T>> = .none
      var currentIndex: Int = 0
      source { payload in
        switch payload {
        case let .start(tb):
          talkback = .some(tb)
          sink(.talkback(tb))
        case .next:
          let isAtIndex: Bool = currentIndex == index
          let isAfterIndex: Bool = currentIndex > index
          currentIndex = currentIndex + 1
          if isAtIndex {
            sink(payload)
          } else if isAfterIndex {
            talkback?(.completed(.finished))
          } else {
            talkback?(.next(.none))
          }
        case .completed:
          sink(payload)
        }
      }
    }
  }
}