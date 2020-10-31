public func race<T>(_ sources: Producer<T> ...) ->  Producer<T> {
  return race(sources)
}

public func race<T>(_ sources: [Producer<T>]) ->  Producer<T> {
  return { sink in
    if sources.count == 0 {
      sink(.completed(.finished))
    } else {
      let lock: RecursiveLock = RecursiveLock(label: DOMAIN("race"))
      var didReceiveCompletion: Bool = false
      var winnerProducerIndex: Int? = .none
      var talkbacks: Array<Optional<SourceTalkback<T>>> = .init(
        repeating: .none,
        count: sources.count
      )
      sink(.whenReceiveCompletion({ lock.withLock { didReceiveCompletion = true } }))
      var iterator = sources.indices.makeIterator()
      while let i = iterator.next() {
        sources[i]({ payload in
          lock.withLock {
            switch payload {
            case let .start(tb):
              talkbacks[i] = .some(tb)
              talkbacks[i]?(.next(.none))
            case .next:
              if winnerProducerIndex == .none {
                winnerProducerIndex = i
              }
              if !didReceiveCompletion && winnerProducerIndex == i {
                sink(payload)
                talkbacks[i]?(.next(.none))
              } else {
                talkbacks[i]?(.completed(.finished))
              }
            case .completed:
              if winnerProducerIndex == i {
                sink(payload)
              }
            }
          }
        })
      }
    }
  }
}

public func race<T>() ->  Operator<Producer<T>, T> {
  return { source in
    return { sink in
      var talkback: Optional<SourceTalkback<Producer<T>>> = .none
      var sources: Array<Producer<T>> = .init()
      source { payload in
        switch payload {
        case let .start(tb):
          talkback = .some(tb)
          talkback?(.next(.none))
        case let .next(source):
          sources.append(source)
          talkback?(.next(.none))
        case let .completed(completion):
          if payload.isForcedToComplete ||
             sources.count == 0         {
            sink(.completed(completion))
          } else {
            race(sources)(sink)
          }
        }
      }
    }
  }
}