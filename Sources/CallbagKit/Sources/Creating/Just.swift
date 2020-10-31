public func just<T>(
  _ getElement: @escaping () throws -> T
) -> Producer<T> {
  return { sink in
    var didSendAlready: Bool = false
    sink(.start({
      switch $0 {
      // NestedStartsNotAllowed From A Producer Perspective
      case .start: return
      case .next:
        do {
          if !didSendAlready {
            didSendAlready = true
            sink(.next(try getElement()))
          } else {
            sink(.completed(.finished))
          }
        } catch {
          sink(.completed(.failed(error)))
        }
      case .completed:
        sink(.completed(.finished))
      }
    }))
  }
}

public func just<T>(
  _ element: T
) -> Producer<T> {
  return { sink in
    var didSendAlready: Bool = false
    sink(.start({
      switch $0 {
      // NestedStartsNotAllowed From A Producer Perspective
      case .start: return
      case .next:
        if !didSendAlready {
          didSendAlready = true
          sink(.next(element))
        } else {
          sink(.completed(.finished))
        }
      case .completed:
        sink(.completed(.finished))
      }
    }))
  }
}

