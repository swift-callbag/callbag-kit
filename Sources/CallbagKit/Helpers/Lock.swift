import protocol Foundation.NSLocking
import class Foundation.NSLock
import class Foundation.NSRecursiveLock

public typealias Lock = NSLock
public typealias RecursiveLock = NSRecursiveLock

public extension NSLocking {
  func withLock<T>(_ task: () -> T) -> T {
    lock()
    let value = task()
    unlock()
    return value
  }
}

public extension NSLock {
  convenience init(label: String) {
    self.init()
    self.name = label
  }
}

public extension NSRecursiveLock {
  convenience init(label: String) {
    self.init()
    self.name = label
  }
}