public func pluck<Key: Hashable, Value>(
  _ byKey: Key
) -> Operator<Dictionary<Key, Value>, Value> {
  return compact { $0[byKey] }
}

public func pluck<Key: Equatable, Value>(
  _ byKey: Key
) -> Operator<KeyValuePairs<Key, Value>, Value> {
  return compact { element in
    element.first(
      where: { pair in
        pair.key == byKey
      }
    )?.value
  }
}

public func pluck<Key: Equatable, Value>(
  _ byKey: Key
) -> Operator<Array<(Key, Value)>, Value> {
  return compact { element in
    element.first(
      where: { pair in
        pair.0 == byKey
      }
    )?.1
  }
}

public func pluck<Key: Equatable, Value>(
  _ byKey: Key
) -> Operator<(Key, Value), Value> {
  return compact { pair in
    pair.0 == byKey ? pair.1 : nil
  }
}

public func pluck<Root, Value>(
  _ keyPath: KeyPath<Root, Value>
) -> Operator<Root, Value> {
  return map { root in
    root[keyPath: keyPath]
  }
}