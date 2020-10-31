public func catchError<T>(
_ handler: @escaping (Error) throws -> Producer<T>
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
          do {
            let source = try handler(error)
            source(sink)
          } catch {
            sink(.completed(.failed(error)))
          }
        case .completed:
          sink(payload)
        }
      }
    }
  }
}