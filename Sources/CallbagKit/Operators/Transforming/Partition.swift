public func partition<T>(
  _ predicate: @escaping (T) throws -> (Bool)
) -> Operator<T, Producer<T>> {
  return { source in
    return map({ $0.source })(group(predicate)(source))
  }
}