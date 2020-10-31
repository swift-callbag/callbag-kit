public func first<T>(_ count: Int = 1) ->  Operator<T, T> {
  return take(count)
}

public func first<T>(
  _ count: Int = 1,
  _ predicate: @escaping (T) throws -> Bool
) ->  Operator<T, T> {
  return { source in
    return take(count)(filter(predicate)(source))
  }
}

public func last<T>(_ count: Int = 1) ->  Operator<T, T> {
  return takeLast(count)
}

public func last<T>(
  _ count: Int = 1,
  _ predicate: @escaping (T) throws -> Bool
) ->  Operator<T, T> {
  return { source in
    return takeLast(count)(filter(predicate)(source))
  }
}