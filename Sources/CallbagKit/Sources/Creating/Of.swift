public func of<T>(
  _ collection: T ...
) -> Producer<T> {
  return from(collection.makeIterator)
}