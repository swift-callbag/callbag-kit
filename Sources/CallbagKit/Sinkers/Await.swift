public func await<T>() -> AwaitableProducer<T> {
  return { source in
    let awaitable = Awaitable<T>()
    var recentElement: Optional<T> = .none
    let cancellable = sink({
      switch $0 {
      case .start: return
      case let .next(element):
        recentElement = .some(element)
      case let .completed(.failed(error)):
        awaitable.failure(error)
      case .completed(.finished):
        awaitable.success(recentElement)
      }
    })(source)

    awaitable.delegate = cancellable
    return awaitable
  }
}