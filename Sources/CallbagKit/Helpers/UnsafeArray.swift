internal final class UnsafeArray<T> {
  internal final class Node { 
    let value: T
    var next: Optional<Node>

    init(_ v: T) {
      value = v
      next = nil
    }
  } 

  internal var first: Optional<Node>
  internal var last: Optional<Node>

  internal init() {
    first = nil
    last = nil
  } 

  internal func append(_ value: T) {
    let temp = Node(value)
    if last == nil { 
      first = temp
      last = temp
    } else {
      last!.next = temp
      last = temp
    }
  } 

  internal func removeFirst() -> T {
    let value = first!.value
    first = first?.next
    if first == nil {
      last = nil
    }
    return value
  }

  internal func removeAll() {
    while first != nil {
      first = first?.next
    }
  }
}