public func print<T>(_ item: T) {
  Swift.print(item, terminator: "\n")
}

public func print<T, U>(_ prefix: T) -> (U) -> Void {
  return { item in
    Swift.print("\(prefix)\(item)", terminator: "\n")
  }
}