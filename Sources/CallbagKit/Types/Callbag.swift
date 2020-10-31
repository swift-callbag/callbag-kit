/// A Callbag dynamically receives input of type Input
/// and dynamically delivers output of type Output
public enum Callbag<Input, Output> {

  indirect case start((Callbag<Output, Input>) -> Void)

  case next(Input)

  case completed(Completion)
}

public extension Callbag {
  var isForcedToComplete: Bool {
    switch self {
    case .completed(.failed): return true
    default:                  return false
    }
  }
}

public extension Callbag {
  static func talkback<T>(_ tb: Optional<SourceTalkback<T>>) -> Callbag {
    return Callbag.start({
      switch $0 {
      case .start: return
      case let .next(element):
        tb?(.next(element as? T))
      case let .completed(completion):
        tb?(.completed(completion))
      }
    })
  }

  static func whenReceiveCompletion(_ closure: @escaping () -> Void) -> Callbag {
    return Callbag.start({
      if case .completed = $0 {
        closure()
      }
    })
  }
}

extension Callbag: Equatable where Input: Equatable {
	public static func == (lhs: Callbag, rhs: Callbag) -> Bool {
    switch (lhs, rhs) {
    case let (.next(a), .next(b)):
      return a == b
    case let (.completed(a), .completed(b)):
      return a == b
    default:
      return false
    }
	}

	public static func == (lhs: Callbag, rhs: Input) -> Bool {
    switch (lhs, rhs) {
    case let (.next(a), b):
      return a == b
    default:
      return false
    }
	}
}

public func == <I, O>(lhs: Callbag<I, O>, rhs: Completion) -> Bool {
  switch (lhs, rhs) {
  case let (.completed(a), b):
    return a == b
  default:
    return false
  }
}

extension Callbag {
	public var isStart: Bool {
    if case .start = self {
      return true
    } else {
      return false
    }
	}

	public var isNext: Bool {
    if case .next = self {
      return true
    } else {
      return false
    }
	}

	public var isCompleted: Bool {
    if case .completed = self {
      return true
    } else {
      return false
    }
	}

	public var talkback: Optional<(Callbag<Output, Input>) -> Void> {
    if case let .start(tb) = self {
      return .some(tb)
    } else {
      return .none
    }
	}

	public var element: Optional<Input> {
    if case let .next(element) = self {
      return .some(element)
    } else {
      return .none
    }
	}

	public var completion: Optional<Completion> {
    if case let .completed(completion) = self {
      return .some(completion)
    } else {
      return .none
    }
	}
}

extension Callbag: CustomStringConvertible {
	public var description: String {
    switch self {
    case .start:
      if Output.self is Optional<Any>.Type {
        return "start((Source<\(Input.self)>) -> Void)"
      } else if Input.self is Optional<Any>.Type {
        return "start((Sink<\(Output.self)>) -> Void)"
      } else {
        return "start((Callbag<\(Output.self), \(Input.self)>) -> Void)"
      }
    case .next(let item):
      return "next(\(item))"
    case .completed(let c):
      return "completed(\(c))"
    }
	}
}