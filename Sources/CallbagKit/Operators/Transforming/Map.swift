public func map<T, R>(
  _ transform: @escaping (T) throws -> R
) ->  Operator<T, R> {
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
            sink(.next(try transform(element)))
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

/// https://developer.apple.com/documentation/swift/keypath
/// https://medium.com/@jllnmercier/swift-keypaths-db326852d66a
/// https://developer.apple.com/documentation/combine/publisher/map(_:)-6sm0a
public func map<Root, T>(_ keyPath: KeyPath<Root, T>) -> Operator<Root, T> {
  return map { root in
    root[keyPath: keyPath]
  }
}

/// https://developer.apple.com/documentation/combine/publisher/map(_:_:)
public func map<Root, T0, T1>(
  _ keyPath0: KeyPath<Root, T0>,
  _ keyPath1: KeyPath<Root, T1>
) -> Operator<Root, (T0, T1)> {
  return map { root in
    (
      root[keyPath: keyPath0],
      root[keyPath: keyPath1]
    )
  }
}

/// https://developer.apple.com/documentation/combine/publisher/map(_:_:_:)
public func map<Root, T0, T1, T2>(
  _ keyPath0: KeyPath<Root, T0>,
  _ keyPath1: KeyPath<Root, T1>,
  _ keyPath2: KeyPath<Root, T2>
) -> Operator<Root, (T0, T1, T2)> {
  return map { root in
    (
      root[keyPath: keyPath0],
      root[keyPath: keyPath1],
      root[keyPath: keyPath2]
    )
  }
}

public func map<Root, T0, T1, T2, T3>(
  _ keyPath0: KeyPath<Root, T0>,
  _ keyPath1: KeyPath<Root, T1>,
  _ keyPath2: KeyPath<Root, T2>,
  _ keyPath3: KeyPath<Root, T3>
) -> Operator<Root, (T0, T1, T2, T3)> {
  return map { root in
    (
      root[keyPath: keyPath0],
      root[keyPath: keyPath1],
      root[keyPath: keyPath2],
      root[keyPath: keyPath3]
    )
  }
}