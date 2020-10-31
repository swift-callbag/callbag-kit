public enum Completion {

  case finished

  case failed(Error)
}

extension Completion: Equatable {
	public static func == (lhs: Completion, rhs: Completion) -> Bool {
    switch (lhs, rhs) {
    case (.finished, .finished):
      return true
    default:
      return false
    }
	}
}

extension Completion: CustomStringConvertible {
	public var description: String {
    switch self {
    case .finished:
      return "finished"
    case .failed(let e):
      return "failed(\(e))"
    }
	}
}