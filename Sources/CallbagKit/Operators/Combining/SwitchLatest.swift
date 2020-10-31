public func switchLatest<T>(_ sources: Producer<T> ...) ->  Producer<T> {
  return switchLatest(sources)
}

public func switchLatest<T>(_ sources: [Producer<T>]) ->  Producer<T> {
  return { sink in
    if sources.count == 0 {
      sink(.completed(.finished))
    } else {
      let lock: RecursiveLock = RecursiveLock(label: DOMAIN("switchLatest"))
      var didReceiveCompletion: Bool = false
      var completionCount: Int = 0
      var didSendCompletion: Bool = false
      var startedProducers: Array<Bool> = .init(
        repeating: false,
        count: sources.count
      )
      var stoppedProducers: Array<Bool> = .init(
        repeating: false,
        count: sources.count
      )
      var talkbacks: Array<Optional<SourceTalkback<T>>> = .init(
        repeating: .none,
        count: sources.count
      )
      func shouldSink(_ index: Int) -> Bool {
        if !startedProducers[index] {
          startedProducers[index] = true
          var iterator = startedProducers.indices.makeIterator()
          while let i = iterator.next() {
            if index != i {
              if startedProducers[i] && !stoppedProducers[i] {
                stoppedProducers[i] = true
              }
            }
          }
        }
        return !stoppedProducers[index]
      }
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
              if !didReceiveCompletion && shouldSink(i) {
                sink(payload)
                talkbacks[i]?(.next(.none))
              } else {
                talkbacks[i]?(.completed(.finished))
              }
            case let .completed(completion):
              if case .failed = completion {
                didSendCompletion = true
                sink(.completed(completion))
                /// stop all payloads other than this one
                var iterator = sources.indices.makeIterator()
                while let j = iterator.next() {
                  if i != j {
                    talkbacks[j]?(.completed(.finished))
                  }                  
                }
              } else {
                completionCount = completionCount + 1
                if !didSendCompletion && completionCount == sources.count {
                  sink(.completed(completion))
                }
              }
            }
          }
        })
      }
    }
  }
}

public func switchLatest<T>() ->  Operator<Producer<T>, T> {
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
            switchLatest(sources)(sink)
          }
        }
      }
    }
  }
}