public func split<T>(
  maxSplits: Int = .max,
  omittingEmptySequence: Bool = true,
  _ predicate: @escaping (T) throws -> (Bool)
) ->  Operator<T, Array<T>> {
  return { source in
    return { sink in
      var talkback: Optional<SourceTalkback<T>> = .none
      var didReceiveCompletion: Bool = false
      var failure: Optional<Completion> = .none
      var tempItems: Array<T> = .init()
      var splitsCount: Int = 0
      source { payload in
        switch payload {
        case let .start(tb):
          talkback = .some(tb)
          sink(.whenReceiveCompletion({ didReceiveCompletion = true }))
          talkback?(.next(.none))
        case let .next(element):
          if !didReceiveCompletion {
            do {
              if splitsCount < maxSplits {
                if try predicate(element) {
                  if tempItems.count > 0 {
                    sink(.next(tempItems))
                    tempItems = []
                    splitsCount = splitsCount + 1
                  } else if !omittingEmptySequence {
                    sink(.next([]))
                    splitsCount = splitsCount + 1
                  }
                } else {
                  tempItems.append(element)
                }
              } else {
                tempItems.append(element)
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
            if !didReceiveCompletion {
              if tempItems.count > 0 {
                sink(.next(tempItems))
              } else if !omittingEmptySequence {
                sink(.next([]))
              }
            }
            sink(.completed(completion))
          }
        }
      }
    }
  }
}

public func split<T: Equatable>(
  _ separators: T ...,
  maxSplits: Int = .max,
  omittingEmptySequence: Bool = true
) ->  Operator<T, Array<T>> {
  return split(maxSplits: maxSplits, omittingEmptySequence: omittingEmptySequence, separators.contains)
}

public func split<S: Sequence>(
  _ separators: S,
  maxSplits: Int = .max,
  omittingEmptySequence: Bool = true
) ->  Operator<S.Element, Array<S.Element>> where S.Element: Equatable {
  return split(maxSplits: maxSplits, omittingEmptySequence: omittingEmptySequence, separators.contains)
}