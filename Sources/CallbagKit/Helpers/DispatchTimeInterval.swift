import enum Dispatch.DispatchTimeInterval

public extension DispatchTimeInterval {
  static var second: DispatchTimeInterval {
    return .milliseconds(1000)
  }

  static func seconds(_ interval: Double) -> DispatchTimeInterval {
    return .milliseconds(Int(interval * 1000))
  }

  static var millisecond: DispatchTimeInterval {
    return .microseconds(1000)
  }

  static func milliseconds(_ interval: Double) -> DispatchTimeInterval {
    return .microseconds(Int(interval * 1000))
  }

  static var microsecond: DispatchTimeInterval {
    return .nanoseconds(1000)
  }

  static func microseconds(_ interval: Double) -> DispatchTimeInterval {
    return .nanoseconds(Int(interval * 1000))
  }

  static var nanosecond: DispatchTimeInterval {
    return .nanoseconds(1)
  }

  func toSeconds() -> Double {
    switch self {
    case let .nanoseconds(n):
      return Double(n) / 1_000_000_000.0
    case let .microseconds(n):
      return Double(n) / 1_000_000.0
    case let .milliseconds(n):
      return Double(n) / 1_000.0
    case let .seconds(n):
      return Double(n)
    case .never:
      return 0
    }
  }
}