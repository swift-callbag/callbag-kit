public func max<T: Comparable>() ->  Operator<T, T> {
  return { source in
    return { sink in
      var talkback: Optional<SourceTalkback<T>> = .none
      var didReceiveCompletion: Bool = false
      var maximumElement: Optional<T> = .none
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
            if case let .some(maximum) = maximumElement {
              if maximum < element {
                maximumElement = .some(element)
              }
            } else {
              maximumElement = .some(element)
            }
            talkback?(.next(.none))
          } else {
            talkback?(.completed(.finished))
          }
        case let .completed(completion):
          if case .finished = completion, !didReceiveCompletion {
            if case let .some(maximum) = maximumElement {
              sink(.next(maximum))
            }            
          }
          sink(.completed(completion))
        }
      }
    }
  }
}

public func max<T>(
  by areInIncreasingOrder: @escaping (T, T) throws -> Bool
) ->  Operator<T, T> {
  return { source in
    return { sink in
      var talkback: Optional<SourceTalkback<T>> = .none
      var didReceiveCompletion: Bool = false
      var failure: Optional<Completion> = .none
      var maximumElement: Optional<T> = .none
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
            do {
              if case let .some(maximum) = maximumElement {
                if try !areInIncreasingOrder(maximum, element) {
                  maximumElement = .some(element)
                }
              } else {
                maximumElement = .some(element)
              }
              talkback?(.next(.none))
            } catch {
              failure = .failed(error)
              talkback?(.completed(.finished))
            }
          } else {
            talkback?(.completed(.finished))
          }
        case let .completed(completion):
          if case let .some(failed) = failure {
            sink(.completed(failed))
          } else {
            if case .finished = completion, !didReceiveCompletion {
              if case let .some(maximum) = maximumElement {
                sink(.next(maximum))
              }            
            }
            sink(.completed(completion))
          }
        }
      }
    }
  }
}