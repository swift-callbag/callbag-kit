public func min<T: Comparable>() ->  Operator<T, T> {
  return { source in
    return { sink in
      var talkback: Optional<SourceTalkback<T>> = .none
      var didReceiveCompletion: Bool = false
      var minimumElement: Optional<T> = .none
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
            if case let .some(minimum) = minimumElement {
              if minimum > element {
                minimumElement = .some(element)
              }
            } else {
              minimumElement = .some(element)
            }
            talkback?(.next(.none))
          } else {
            talkback?(.completed(.finished))
          }
        case let .completed(completion):
          if case .finished = completion {
            if case let .some(minimum) = minimumElement {
              sink(.next(minimum))
            }            
          }
          sink(.completed(completion))
        }
      }
    }
  }
}

public func min<T>(
  by areInIncreasingOrder: @escaping (T, T) throws -> Bool
) ->  Operator<T, T> {
  return { source in
    return { sink in
      var talkback: Optional<SourceTalkback<T>> = .none
      var didReceiveCompletion: Bool = false
      var failure: Optional<Completion> = .none
      var minimumElement: Optional<T> = .none
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
              if case let .some(minimum) = minimumElement {
                if try !areInIncreasingOrder(minimum, element) {
                  minimumElement = .some(element)
                }
              } else {
                minimumElement = .some(element)
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
            if case .finished = completion {
              if case let .some(minimum) = minimumElement {
                sink(.next(minimum))
              }            
            }
            sink(.completed(completion))
          }
        }
      }
    }
  }
}