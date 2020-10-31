public func sum<T: BinaryInteger>() ->  Operator<T, T> {
  return reduce(0, +)
}

public func sum<T: BinaryFloatingPoint>() ->  Operator<T, T> {
  return reduce(0, +)
}