public func loop<T, R, U>(
  _ initialResult: R,
  _ nextNewResult: @escaping (R, T) throws -> (R, U)
) ->  Operator<T, U> {
  return { source in
    return { sink in
      var talkback: Optional<SourceTalkback<T>> = .none
      var failure: Optional<Completion> = .none
      var latestResult = initialResult
      source { payload in
        switch payload {
        case let .start(tb):
          talkback = .some(tb)
          sink(.talkback(tb))
        case let .next(element):
          do {
            let newResult = try nextNewResult(latestResult, element)
            latestResult = newResult.0
            sink(.next(newResult.1))
          } catch {
            failure = .failed(error)
            talkback?(.completed(.finished))
          }
        case let .completed(completion):
          if case let .some(failed) = failure {
            sink(.completed(failed))
          } else {
            sink(.completed(completion))
          }
        }
      }
    }
  }
}