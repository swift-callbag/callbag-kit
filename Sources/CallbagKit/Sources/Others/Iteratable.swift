public func makeIterator<T>(_ source: @escaping Producer<T>) -> () -> Optional<T> {
  let source = pullable(source)
  var talkback: SourceTalkback<T>!
  let elements: UnsafeArray<T> = .init()
  var didCompleteAlready: Bool = false
  source {
    switch $0 {
    case let .start(tb):
      talkback = tb
    case let .next(element):
      elements.append(element)
    case .completed:
      didCompleteAlready = true
    }
  }
  return {
    talkback?(.next(.none))
    if didCompleteAlready {
      return nil
    } else {
      return elements.removeFirst()
    }
  }
}