public func compact<T, R: OptionalProtocol>(
  _ transform: @escaping (T) throws -> R
) ->  Operator<T, R.Wrapped> {
  return { source in
    return { sink in
      var talkback: Optional<SourceTalkback<T>> = .none
      var failure: Optional<Completion> = .none
      source { payload in
        switch payload {
        case let .start(tb):
          talkback = .some(tb)
          sink(.talkback(tb))
        case let .next(element):
          do {
            if let transformedElement = try transform(element).optionalValue {
              sink(.next(transformedElement))
            } else {
              talkback?(.next(.none))
            }
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

public func compact<T: OptionalProtocol>() ->  Operator<T, T.Wrapped> {
  return { source in
    return { sink in
      var talkback: Optional<SourceTalkback<T>> = .none
      source { payload in
        switch payload {
        case let .start(tb):
          talkback = .some(tb)
          sink(.talkback(tb))
        case let .next(element):
          if let wrappedElement = element.optionalValue {
            sink(.next(wrappedElement))
          } else {
            talkback?(.next(.none))
          }
        case let .completed(completion):
          sink(.completed(completion))
        }
      }
    }
  }
}