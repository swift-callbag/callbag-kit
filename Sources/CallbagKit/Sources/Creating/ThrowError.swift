public func throwError<T>(_ error: Error) ->  Producer<T> {
  return { sink in
    sink(.start({ _ in }))
    sink(.completed(.failed(error)))
  }
}

public func throwError(_ error: Error) ->  Producer<Void> {
  return { sink in
    sink(.start({ _ in }))
    sink(.completed(.failed(error)))
  }
}