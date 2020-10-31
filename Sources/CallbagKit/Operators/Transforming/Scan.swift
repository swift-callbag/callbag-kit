public func scan<T>(
  _ nextPartialResult: @escaping (T, T) throws -> T
) ->  Operator<T, T> {
  return { source in
    return { sink in
      var talkback: Optional<SourceTalkback<T>> = .none
      var failure: Optional<Completion> = .none
      var latestResult: Optional<T> = .none
      source { payload in
        switch payload {
        case let .start(tb):
          talkback = .some(tb)
          sink(.talkback(tb))
        case let .next(element):
          if latestResult != nil {
            do {
              latestResult = try nextPartialResult(latestResult!, element)
              sink(.next(latestResult!))
            } catch {
              failure = .failed(error)
              talkback?(.completed(.finished))
            }
          } else {
            latestResult = element
            sink(.next(element))
          }
        case .completed:
          if case let .some(failed) = failure {
            sink(.completed(failed))
          } else {
            sink(payload)
          }
        }
      }
    }
  }
}

public func scan<T, R>(
  _ initialResult: R,
  _ nextPartialResult: @escaping (R, T) throws -> R
) ->  Operator<T, R> {
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
            latestResult = try nextPartialResult(latestResult, element)
            sink(.next(latestResult))
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