public protocol OptionalProtocol {
  associatedtype Wrapped
  var optionalValue: Optional<Wrapped> { get }
}

extension Optional: OptionalProtocol {
  public var optionalValue: Optional<Wrapped> {
    switch self {
    case let .some(value):
        return value
    default:
        return .none
    }
  }
}