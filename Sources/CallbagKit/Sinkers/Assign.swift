/// works for reference types `classes`
public func assign<Root, T>(
  to keyPath: ReferenceWritableKeyPath<Root, T>,
  on object: Root
) -> CancellableProducer<T> {
  return sink {
    if case let .next(element) = $0 {
      object[keyPath: keyPath] = element
    }
  }
}

/// works for value types `structs`
/// pass either pointer or just use `&`
/// e.g.
/// let pointer = UnsafeMutablePointer<MyStruct>.allocate(capacity: 1)
/// pointer.pointee = myStruct
/// assign(to: \.fieldName, on: pointer)
/// or directly ...
/// assign(to: \.fieldName, on: &myStruct)
public func assign<Root, T>(
  to keyPath: WritableKeyPath<Root, T>,
  on object: UnsafeMutablePointer<Root>
) -> CancellableProducer<T> {
  return sink {
    if case let .next(element) = $0 {
      object.pointee[keyPath: keyPath] = element
    }
  }
}


/// works for value types `structs`
/// pass either pointer or just use `&`
/// e.g.
/// let pointer = UnsafeMutablePointer<MyStruct>.allocate(capacity: 1)
/// pointer.pointee = myStruct
/// assign(to: pointer)
/// or directly ...
/// assign(to: &myStruct)
public func assign<Root>(
  to object: UnsafeMutablePointer<Root>
) -> CancellableProducer<Root> {
  return sink {
    if case let .next(element) = $0 {
      object.pointee = element
    }
  }
}