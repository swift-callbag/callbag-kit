public func empty<T>() -> Producer<T> {
  return { sink in
    sink(.start({ _ in }))
    sink(.completed(.finished))
  }
}

public func empty() -> Producer<Void> {
  return { sink in
    sink(.start({ _ in }))
    sink(.completed(.finished))
  }
}