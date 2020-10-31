public func count<T>() ->  Operator<T, Int> {
  return { source in
    return { sink in
      var talkback: Optional<SourceTalkback<T>> = .none
      var didReceiveCompletion: Bool = false
      var totalCount: Int = 0
      source { payload in
        switch payload {
        case let .start(tb):
          talkback = tb
          sink(.whenReceiveCompletion({
            didReceiveCompletion = true
          }))
          talkback?(.next(.none))
        case .next:
          if !didReceiveCompletion {
            totalCount = totalCount + 1
            talkback?(.next(.none))
          } else {
            talkback?(.completed(.finished))
          }
        case let .completed(completion):
          if case .finished = completion, !didReceiveCompletion {
            sink(.next(totalCount))
          }
          sink(.completed(completion))
        }
      }
    }
  }
}