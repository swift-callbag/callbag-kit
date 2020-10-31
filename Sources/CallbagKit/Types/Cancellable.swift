import struct Foundation.UUID

public final class Cancellable: AwaitableDelegate {

  public private(set) var cancel: () -> Void

  private let uuid: UUID

  internal init(_ cancel: @escaping () -> Void = {}) {
    self.cancel = cancel
    self.uuid = UUID()
  }

  public func store(in collection: inout Set<Cancellable>) {
    collection.update(with: self)
  }
}

extension Cancellable: Equatable {
  public static func ==(lhs: Cancellable, rhs: Cancellable) -> Bool {
    return lhs.uuid == rhs.uuid
  }
}

extension Cancellable: Hashable {
  public func hash(into hasher: inout Hasher) {
    hasher.combine(uuid)
  }
}