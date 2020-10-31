public func average<T: BinaryInteger>() ->  Operator<T, Double> {
  return { source in
    return { sink in
      var talkback: Optional<SourceTalkback<T>> = .none
      var didReceiveCompletion: Bool = false
      var totalCount: Double = 0
      var sumOfElements: T = 0
      source { payload in
        switch payload {
        case let .start(tb):
          talkback = tb
          sink(.whenReceiveCompletion({
            didReceiveCompletion = true
          }))
          talkback?(.next(.none))
        case let .next(element):
          if !didReceiveCompletion {
            totalCount = totalCount + 1
            sumOfElements = sumOfElements + element
            talkback?(.next(.none))
          } else {
            talkback?(.completed(.finished))
          }
        case let .completed(completion):
          if case .finished = completion, !didReceiveCompletion {
            if totalCount > 0 {
              sink(.next(Double(sumOfElements)/totalCount))
            }
          }
          sink(.completed(completion))
        }
      }
    }
  }
}

public func average<T: BinaryFloatingPoint>() ->  Operator<T, Double> {
  return { source in
    return { sink in
      var talkback: Optional<SourceTalkback<T>> = .none
      var didReceiveCompletion: Bool = false
      var totalCount: Double = 0
      var sumOfElements: T = 0
      source { payload in
        switch payload {
        case let .start(tb):
          talkback = tb
          sink(.whenReceiveCompletion({
            didReceiveCompletion = true
          }))
          talkback?(.next(.none))
        case let .next(element):
          if !didReceiveCompletion {
            totalCount = totalCount + 1
            sumOfElements = sumOfElements + element
            talkback?(.next(.none))
          } else {
            talkback?(.completed(.finished))
          }
        case let .completed(completion):
          if case .finished = completion, !didReceiveCompletion {
            if totalCount > 0 {
              sink(.next(Double(sumOfElements)/totalCount))
            }
          }
          sink(.completed(completion))
        }
      }
    }
  }
}