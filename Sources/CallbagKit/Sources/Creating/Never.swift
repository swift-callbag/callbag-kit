public func never<T>() ->  Producer<T> {
  return { sink in
    sink(.start({ _ in }))
  }
}

public func never() ->  Producer<Never> {
  return { sink in
    sink(.start({ _ in }))
  }
}