public func mapError<T>(
  _ transform: @escaping (Error) -> Error
) ->  Operator<T, T> {
  return { source in
    return { sink in
      source { payload in
        switch payload {
        case let .start(tb):
          sink(.talkback(tb))
        case .next:
          sink(payload)
        case let .completed(.failed(error)):
          sink(.completed(.failed(transform(error))))
        case .completed:
          sink(payload)
        }
      }
    }
  }
}