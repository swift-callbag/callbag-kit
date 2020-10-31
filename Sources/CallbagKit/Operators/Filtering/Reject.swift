public func reject<T>(
  _ predicate: @escaping (T) throws -> Bool
) ->  Operator<T, T> {
  return filter(not(predicate))
}