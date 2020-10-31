public func combine<A, B>(
  _ a: @escaping Producer<A>,
  _ b: @escaping Producer<B>
) ->  Producer<(A, B)> {
  return { sink in
    let lock: RecursiveLock = RecursiveLock(label: DOMAIN("combine"))
    var didReceiveCompletion: Bool = false
    var didSendCompletion: Bool = false
    let sources: Array<Any> = Array(arrayLiteral: a, b)
    var talkbacks: Array<Optional<Any>> = .init(repeating: .none, count: 2)
    var didStartSource: Array<Bool> = .init(repeating: false, count: 2)
    var latestElements: Array<Optional<Any>> = .init(repeating: .none, count: 2)
    var didSetInitials: Bool = false
    let publish: (Int, Any) -> Void = { (index, element) in
      latestElements[index] = element
      if didSetInitials {
        sink(.next((
          latestElements[0] as! A,
          latestElements[1] as! B
        )))
      }
      if latestElements.allSatisfy(notEquals(.none)) {
        didSetInitials = true
        sink(.next((
          latestElements[0] as! A,
          latestElements[1] as! B
        )))
      }
    }
    func start<T>( _ index: Int, _ source: @escaping Producer<T>) {
      source { payload in
        lock.withLock {
          switch payload {
          case let .start(tb):
            didStartSource[index] = true
            talkbacks[index] = .some(tb)
          case let .next(element):
            if !didReceiveCompletion {
              publish(index, element)
            } else {
              (talkbacks[index] as! SourceTalkback<T>)(.completed(.finished))
            }
          case let .completed(completion):
            if !didSendCompletion {
              talkbacks[index] = .none
              if payload.isForcedToComplete {
                didSendCompletion = true
                sink(.completed(completion))
                /// stop the other payload
                if index == 0 {
                  (talkbacks[1] as? SourceTalkback<B>)?(.completed(.finished))
                } else {
                  (talkbacks[0] as? SourceTalkback<A>)?(.completed(.finished))
                }
              } else if talkbacks.allSatisfy(equals(.none)) && 
                    didStartSource.allSatisfy(equals(true)) {
                didSendCompletion = true
                sink(.completed(completion))
              }
            }
          }
        }
      }
    }
    sink(.start({ _ in lock.withLock { didReceiveCompletion = true } }))
    start(0, sources[0] as! Producer<A>)
    start(1, sources[1] as! Producer<B>)
  }
}

public func combine<A, B, C>(
  _ a: @escaping Producer<A>,
  _ b: @escaping Producer<B>,
  _ c: @escaping Producer<C>
) ->  Producer<(A, B, C)> {
  return map(unpackTuple)(
    combine( combine(a, b), c )
  )
}

public func combine<A, B, C, D>(
  _ a: @escaping Producer<A>,
  _ b: @escaping Producer<B>,
  _ c: @escaping Producer<C>,
  _ d: @escaping Producer<D>
) ->  Producer<(A, B, C, D)> {
  return map(unpackTuple)(
    combine( combine( combine(a, b), c ), d )
  )
}

public func combine<A, B, C, D, E>(
  _ a: @escaping Producer<A>,
  _ b: @escaping Producer<B>,
  _ c: @escaping Producer<C>,
  _ d: @escaping Producer<D>,
  _ e: @escaping Producer<E>
) ->  Producer<(A, B, C, D, E)> {
  return map(unpackTuple)(
    combine( combine( combine( combine(a, b), c ), d ), e )
  )
}

public func combine<A, B, C, D, E, F>(
  _ a: @escaping Producer<A>,
  _ b: @escaping Producer<B>,
  _ c: @escaping Producer<C>,
  _ d: @escaping Producer<D>,
  _ e: @escaping Producer<E>,
  _ f: @escaping Producer<F>
) ->  Producer<(A, B, C, D, E, F)> {
  return map(unpackTuple)(
    combine( combine( combine( combine( combine(a, b), c ), d ), e ), f )
  )
}

public func combine<A, B>(
  _ b: @escaping Producer<B>
) ->  Operator<A, (A, B)> {
  return { a in
    return { sink in
      combine(a, b)(sink)
    }
  }
}

public func combine<A, B, C>(
  _ b: @escaping Producer<B>,
  _ c: @escaping Producer<C>
) ->  Operator<A, (A, B, C)> {
  return { a in
    return { sink in
      combine(a, b, c)(sink)
    }
  }
}

public func combine<A, B, C, D>(
  _ b: @escaping Producer<B>,
  _ c: @escaping Producer<C>,
  _ d: @escaping Producer<D>
) ->  Operator<A, (A, B, C, D)> {
  return { a in
    return { sink in
      combine(a, b, c, d)(sink)
    }
  }
}

public func combine<A, B, C, D, E>(
  _ b: @escaping Producer<B>,
  _ c: @escaping Producer<C>,
  _ d: @escaping Producer<D>,
  _ e: @escaping Producer<E>
) ->  Operator<A, (A, B, C, D, E)> {
  return { a in
    return { sink in
      combine(a, b, c, d, e)(sink)
    }
  }
}

public func combine<A, B, C, D, E, F>(
  _ b: @escaping Producer<B>,
  _ c: @escaping Producer<C>,
  _ d: @escaping Producer<D>,
  _ e: @escaping Producer<E>,
  _ f: @escaping Producer<F>
) ->  Operator<A, (A, B, C, D, E, F)> {
  return { a in
    return { sink in
      combine(a, b, c, d, e, f)(sink)
    }
  }
}