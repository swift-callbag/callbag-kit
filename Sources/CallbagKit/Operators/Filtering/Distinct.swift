public func distinct<T: Equatable>() ->  Operator<T, T> {
  return { source in
    return { sink in
      var talkback: Optional<SourceTalkback<T>> = .none
      var cache: Array<T> = .init()
      source { payload in
        switch payload {
        case let .start(tb):
          talkback = .some(tb)
          sink(.talkback(tb))
        case let .next(element):
          if !cache.contains(element) {
            cache.append(element)
            sink(payload)
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

public func distinctUntilChanged<T: Equatable>() ->  Operator<T, T> {
  return { source in
    return { sink in
      var talkback: Optional<SourceTalkback<T>> = .none
      var latestElement: Optional<T> = .none
      source { payload in
        switch payload {
        case let .start(tb):
          talkback = .some(tb)
          sink(.talkback(tb))
        case let .next(element):
          switch latestElement {
          case .none:
            latestElement = .some(element)
            sink(payload)
          case let .some(latest):
            if latest != element {
              latestElement = .some(element)
              sink(payload)
            } else {
              talkback?(.next(.none))
            }
          }
        case .completed:
          sink(payload)
        }
      }
    }
  }
}