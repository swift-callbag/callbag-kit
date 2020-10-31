public func from<T>(
  _ iterator: @escaping () -> Optional<T>
) -> Producer<T> {
  return { sink in
    sink(.start({
      switch $0 {
      // NestedStartsNotAllowed From A Producer Perspective
      case .start: return
      case .next:
        if let element = iterator() {
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

public func from<I: IteratorProtocol>(
  _ makeIterator: @escaping () -> I
) -> Producer<I.Element> {
  return { sink in
    var iterator = makeIterator()
    sink(.start({
      switch $0 {
      // NestedStartsNotAllowed From A Producer Perspective
      case .start: return
      case .next:
        if let element = iterator.next() {
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

public func from<S: Sequence>(
  _ sequence: S
) -> Producer<S.Element> {
  return from(sequence.makeIterator)
}

public func from<T>(_ subject: @escaping Subject<T>) -> Producer<T> {
  return { sink in
    subject(.start({ payload in
      switch payload {
      case let .start(tb):
        sink(.whenReceiveCompletion({
          tb(.completed(.finished))
        }))
      case let .next(element):
        sink(.next(element))
      case let .completed(completion):
        sink(.completed(completion))
      }
    }))
  }
}