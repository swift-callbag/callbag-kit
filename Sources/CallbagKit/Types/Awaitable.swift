import struct Foundation.UUID
import Dispatch

public protocol AwaitableDelegate {
  var cancel: () -> Void { get }
}

public final class Awaitable<T> {

  private let uuid: UUID

  private var result: Optional<Result<Optional<T>, Error>>

  private let lock: RecursiveLock

  private let semaphore: DispatchSemaphore

  internal var delegate: Optional<AwaitableDelegate>

  public var isCancelled: Bool {
    return lock.withLock { delegate == nil }
  }

  public var isCompleted: Bool {
    return lock.withLock { result != nil }
  }

  internal init() {
    self.uuid = UUID()
    self.result = .none
    self.lock = RecursiveLock(label: "future")
    self.semaphore = DispatchSemaphore(value: 0)
    self.delegate = .none
  }

  internal func success(_ value: Optional<T>) {
    lock.withLock {
      result = .success(value)
      semaphore.signal()
    }
  }

  internal func failure(_ error: Error) {
    lock.withLock {
      result = .failure(error)
      semaphore.signal()
    }
  }

  public func cancel() {
    lock.withLock {
      delegate?.cancel()
      delegate = .none
      semaphore.signal()
    }
  }

  public func wait(
    _ timeout: DispatchTimeInterval = .never
  ) -> Optional<Result<Optional<T>, Error>> {
    _ = semaphore.wait(timeout: .now() + timeout)
    return lock.withLock { result }
  }
}

extension Awaitable: Equatable {
  public static func ==(lhs: Awaitable, rhs: Awaitable) -> Bool {
    return lhs === rhs
  }
}

extension Awaitable: Hashable {
  public func hash(into hasher: inout Hasher) {
    hasher.combine(uuid)
  }
}