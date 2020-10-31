public func skip<T>(_ count: Int) ->  Operator<T, T> {
  return dropFirst(count)
}

public func skipLast<T>(_ count: Int = 1) ->  Operator<T, T> {
  return dropLast(count)
}

public func skipWhile<T>(_ predicate: @escaping (T) throws -> Bool) ->  Operator<T, T> {
  return dropWhile(predicate)
}

public func skipWhile<T, U>(_ notifier: @escaping Producer<U>) ->  Operator<T, T> {
  return dropWhile(notifier)
}

public func skipUntil<T, U>(_ notifier: @escaping Producer<U>) ->  Operator<T, T> {
  return dropUntil(notifier)
}