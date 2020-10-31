public func flatMap<T, R>(
  _ transform: @escaping (T) throws -> Producer<R>
) ->  Operator<T, R> {
  return { source in
    return { sink in
      var talkback: Optional<SourceTalkback<T>> = .none
      var failure: Optional<Completion> = .none
      var sources: Array<Producer<R>> = .init()
      var didReceiveCompletion: Bool = false
      source { payload in
        switch payload {
        case let .start(tb):
          talkback = .some(tb)
          sink(.whenReceiveCompletion({ didReceiveCompletion = true }))
          talkback?(.next(.none))
        case let .next(element):
          do {
            sources.append(try transform(element))
            talkback?(.next(.none))
          } catch {
            failure = .failed(error)
            talkback?(.completed(.finished))
          }
        case let .completed(completion):
          if case let .some(failed) = failure {
            sink(.completed(failed))
          } else if payload.isForcedToComplete || sources.count == 0 {
            sink(.completed(completion))
          } else {
            var completionCount = 0
            var didSendCompletion = false
            var talkbacks: Array<Optional<SourceTalkback<R>>> = .init(
              repeating: .none,
              count: sources.count
            )
            var iterator = sources.indices.makeIterator()
            while let i = iterator.next() {
              sources[i]({ payload in
                switch payload {
                case let .start(tb):
                  talkbacks[i] = .some(tb)
                  talkbacks[i]?(.next(.none))
                case .next:
                  if !didReceiveCompletion && !didSendCompletion {
                    sink(payload)
                    talkbacks[i]?(.next(.none))
                  } else {
                    talkbacks[i]?(.completed(.finished))
                  }
                case .completed:
                  if payload.isForcedToComplete {
                    didSendCompletion = true
                    sink(payload)
                    /// stop all sources other than this one
                    var iterator = sources.indices.makeIterator()
                    while let j = iterator.next() {
                      if i != j {
                        talkbacks[i]?(.completed(.finished))
                      }                  
                    }
                  } else {
                    completionCount = completionCount + 1
                    if !didSendCompletion && completionCount == sources.count {
                      sink(payload)
                    }
                  }
                }
              })
            }
          }
        }
      }
    }
  }
}