public enum FlattenStrategy {
  case concat, merge, latest, race
}

public func flatten<T>(_ strategy: FlattenStrategy) ->  Operator<Producer<T>, T> {
  switch strategy {
  case .concat:
    return concat()
  case .merge:
    return merge()
  case .latest:
    return switchLatest()
  case .race:
    return race()
  }
}