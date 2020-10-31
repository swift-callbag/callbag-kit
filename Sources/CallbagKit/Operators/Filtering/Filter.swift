public func filter<T>(
  _ predicate: @escaping (T) throws -> Bool
) ->  Operator<T, T> {
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
            if try predicate(element) {
              sink(payload)
            } else {
              talkback?(.next(.none))
            }
          } catch {
            failure = .failed(error)
            talkback?(.completed(.finished))
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