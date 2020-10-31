public func forEach<T, R>(_ consumer: @escaping (T) -> R) -> CancellableProducer<T> {
  return sink {
    if case let .next(element) = $0 {
      _ = consumer(element)
    }
  }
}