public func concat<T>(_ sources: Producer<T> ...) ->  Producer<T> {
  return concat(sources)
}

public func concat<T>(_ sources: Array<Producer<T>>) ->  Producer<T> {
  if sources.count == 0 {
    return empty()
  } else {
    var iterator = sources.makeIterator()
    var source: Producer<T> = iterator.next()!
    while let nextSource = iterator.next() {
      source = concat(nextSource)(source)
    }
    return source
  }
}

public func concat<T>(_ secondProducer: @escaping Producer<T>) ->  Operator<T, T> {
  return { firstProducer in
    return { sink in
      let lock: RecursiveLock = RecursiveLock(label: DOMAIN("concat"))
      var talkback: Optional<SourceTalkback<T>> = .none
      var didReceiveCompletion = false
      firstProducer { payload in
        lock.withLock {
          switch payload {
          case let .start(tb):
            talkback = tb
            sink(.start({ payload in
              lock.withLock {
                switch payload {
                case .start: return
                case .next:
                  talkback?(payload)
                case .completed:
                  didReceiveCompletion = true
                  sink(.completed(.finished))
                }
              }
            }))
          case .next:
            sink(payload)
          case .completed:
            if didReceiveCompletion || payload.isForcedToComplete {
              sink(payload)
            } else {
              secondProducer { payload in
                lock.withLock {
                  switch payload {
                  case let .start(tb):
                    talkback = tb
                    talkback?(.next(.none))
                  case .next:
                    sink(payload)
                  case .completed:
                    sink(payload)
                  }
                }
              }
            }
          }
        }
      }
    }
  }
}

public func concat<T>() ->  Operator<Producer<T>, T> {
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
            concat(sources)(sink)
          }
        }
      }
    }
  }
}

public func append<T>(_ secondProducer: @escaping Producer<T>) ->  Operator<T, T> {
  return { firstProducer in
    return concat(secondProducer)(firstProducer)
  }
}

public func append<S: Sequence>(_ sequence: S) ->  Operator<S.Element, S.Element> {
  return { source in
    return concat(from(sequence.makeIterator))(source)
  }
}

public func prepend<T>(_ firstProducer: @escaping Producer<T>) ->  Operator<T, T> {
  return { secondProducer in
    return concat(secondProducer)(firstProducer)
  }
}

public func prepend<S: Sequence>(_ sequence: S) ->  Operator<S.Element, S.Element> {
  return { source in
    return concat(source)(from(sequence.makeIterator))
  }
}