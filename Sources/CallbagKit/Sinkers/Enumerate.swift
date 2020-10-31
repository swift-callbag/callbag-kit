public func enumerate<T>(_ consumer: @escaping ((Int, T)) -> Void) -> CancellableProducer<T> {
  return { source  in
    var currentIndex: Int = 0
    return sink({
      if case let .next(element) = $0 {
        consumer((currentIndex, element))
        currentIndex = currentIndex + 1
      }
    })(source)
  }
}