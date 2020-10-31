public func collect<T>() ->  Operator<T, Array<T>> {
  return reduce([], { $0 + [$1]})
}

public func collect<T>(count: Int) ->  Operator<T, Array<T>> {
  return { source in
    return take(1)(buffer(count)(source))
  }
}