public func reduce<T, R>(
  _ initialResult: R,
  _ nextPartialResult: @escaping (R, T) throws -> R
) ->  Operator<T, R> {
  return { source in
    return { sink in
      var talkback: Optional<SourceTalkback<T>> = .none
      var didReceiveCompletion: Bool = false
      var failure: Optional<Completion> = .none
      var latestResult = initialResult
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
              latestResult = try nextPartialResult(latestResult, element)
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
              sink(.next(latestResult))
            }
            sink(.completed(completion))
          }
        }
      }
    }
  }
}