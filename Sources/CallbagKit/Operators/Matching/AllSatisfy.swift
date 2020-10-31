public func allSatisfy<T>(
  _ predicate: @escaping (T) throws -> Bool
) ->  Operator<T, Bool> {
  return { source in
    return { sink in
      var talkback: Optional<SourceTalkback<T>> = .none
      var failure: Optional<Completion> = .none
      var didReceiveCompletion: Bool = false
      var doesContainsElement: Bool = true
      source { payload in
        switch payload {
        case let .start(tb):
          talkback = .some(tb)
          sink(.whenReceiveCompletion({
            didReceiveCompletion = true
          }))
          talkback?(.next(.none))
        case let .next(element):
          if !didReceiveCompletion {
            do {
              if try !predicate(element) {
                doesContainsElement = false
                talkback?(.completed(.finished))
              } else {
                talkback?(.next(.none))
              }
            } catch{
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
              sink(.next(doesContainsElement))
            }
            sink(.completed(completion))
          }
        }
      }
    }
  }
}