public func even(_ x: Int) -> Bool {
  return x%2 == 0
}

public func even(_ x: Double) -> Bool {
  return Int(x)%2 == 0
}

public func odd(_ x: Int) -> Bool {
  return x%2 == 1
}

public func odd(_ x: Double) -> Bool {
  return Int(x)%2 == 1
}

public func equals<T: Equatable>(_ y: T) -> (T) -> Bool {
  return { x in
    return x == y
  }
}

public func equals<T: Equatable>(_ y: Optional<T>) -> (Optional<T>) -> Bool {
  return { x in
    return x == y
  }
}

public func equals(_ y: Optional<Any>) -> (Optional<Any>) -> Bool {
  return { x in
    switch (x, y) {
    case (.none, .none):
      return true
    default:
      return false
    }
  }
}

public func notEquals<T: Equatable>(_ y: T) -> (T) -> Bool {
  return { x in
    return x != y
  }
}

public func notEquals<T: Equatable>(_ y: Optional<T>) -> (Optional<T>) -> Bool {
  return { x in
    return x != y
  }
}

public func notEquals(_ y: Optional<Any>) -> (Optional<Any>) -> Bool {
  return { x in
    switch (x, y) {
    case (.none, .none):
      return false
    default:
      return true
    }
  }
}

public func empty<T: Collection>(_ x: T) -> Bool {
  return x.count == 0
}

public func notEmpty<T: Collection>(_ x: T) -> Bool {
  return x.count > 0
}


public func not<T>(_ predicate: @escaping (T) throws -> Bool) -> (T) throws -> Bool {
  return { x in
    return try !predicate(x)
  }
}



public func multiply(_ y: Int) -> (Int) -> (Int) {
  return { x in
    return x * y
  }
}

public func add(_ y: Int) -> (Int) -> (Int) {
  return { x in
    return x + y
  }
}

public func sub(_ y: Int) -> (Int) -> (Int) {
  return { x in
    return x - y
  }
}

public func divide(_ y: Int) -> (Int) -> (Double) {
  return { x in
    return Double(x) / Double(y)
  }
}