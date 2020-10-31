import class Dispatch.DispatchQueue
import struct Dispatch.DispatchQoS

public extension DispatchQueue {
  /// The quality-of-service class for user-interactive tasks, such as 
  /// animations, event handling, or updating your app's user interface.
  static var userInteractive: DispatchQueue {
    return .global(qos: .userInteractive)
  }

  /// The quality-of-service class for tasks that prevent the user from
  /// actively using your app.
  static var userInitiated: DispatchQueue {
    return .global(qos: .userInitiated)
  }
  
  /// The default quality-of-service class.
  static var `default`: DispatchQueue {
    return .global(qos: .`default`)
  }

  /// The quality-of-service class for tasks that the user does not track
  /// actively.
  static var utility: DispatchQueue {
    return .global(qos: .utility)
  }

  /// The quality-of-service class for maintenance or cleanup tasks that you
  /// create.
  static var background: DispatchQueue {
    return .global(qos: .background)
  }

  /// The absence of a quality-of-service class.
  static var unspecified: DispatchQueue {
    return .global(qos: .unspecified)
  }
}

public extension DispatchQueue {
  static func concurrent(
    label: String,
    qos: DispatchQoS = .unspecified,
    autoreleaseFrequency: DispatchQueue.AutoreleaseFrequency = .inherit,
    target: DispatchQueue? = nil
  ) -> DispatchQueue {
    return .init(
      label: label,
      qos: qos,
      attributes: .concurrent,
      autoreleaseFrequency: autoreleaseFrequency,
      target: target
    )
  }
}