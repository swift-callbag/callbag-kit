public func replaceNil<T: OptionalProtocol>(
  with nonNilElement: T.Wrapped
) ->  Operator<T, T.Wrapped> {
  return { source in
    return { sink in
      source { payload in
        switch payload {
        case let .start(tb):
          sink(.talkback(tb))
        case let .next(element):
          if let wrappedElement = element.optionalValue {
            sink(.next(wrappedElement))
          } else {
            sink(.next(nonNilElement))
          }
        case let .completed(completion):
          sink(.completed(completion))
        }
      }
    }
  }
}

public func replaceEmpty<T>(with element: T) ->  Operator<T, T> {
  return { source in
    return { sink in
      var talkback: Optional<SourceTalkback<T>> = .none
      var didReceiveCompletion: Bool = false
      var didSendAtLeastOneElement: Bool = false
      source { payload in
        switch payload {
        case let .start(tb):
          talkback = .some(tb)
          sink(.whenReceiveCompletion({ didReceiveCompletion = true }))
          talkback?(.next(.none))
        case .next:
          if !didReceiveCompletion {
            didSendAtLeastOneElement = true
            sink(payload)
            talkback?(.next(.none))
          } else {
            talkback?(.completed(.finished))
          }
        case .completed:
          if !didSendAtLeastOneElement {
            sink(.next(element))
          }
          sink(payload)
        }
      }
    }
  }
}

/// same as `dropFirst(n).prepend([Element](repeating: element, count: n))`
/// but will lose the time aspect if source was a `.interval(duration)`
/// thus this implementation won't
public func replaceFirst<T>(
  _ count: Int = 1,
  with element: T
) ->  Operator<T, T> {
  return { source in
    return { sink in
      var count = count
      source { payload in
        switch payload {
        case let .start(tb):
          sink(.talkback(tb))
        case .next:
          if count < 1 {
            sink(payload)
          } else {
            count = count - 1
            sink(.next(element))
          }
        case .completed:
          sink(payload)
        }
      }
    }
  }
}

/// same as `dropLast(n).append([Element](repeating: element, count: n))`
/// any how it will lose the time aspect if source was a `.interval(duration)`
/// even with this implementation, but this is a bit faster `less-func-calls`
public func replaceLast<T>(
  _ count: Int = 1,
  with element: T
) ->  Operator<T, T> {
  return { source in
    return { sink in
      var talkback: Optional<SourceTalkback<T>> = .none
      var didReceiveCompletion: Bool = false
      var buffer: Array<Optional<T>> = .init(repeating: .none, count: count)
      var currentIndex: Int = 0
      var isBufferFull: Bool {
        return buffer.allSatisfy(notEquals(.none))
      }
      source { payload in
        switch payload {
        case let .start(tb):
          talkback = .some(tb)
          sink(.whenReceiveCompletion({ didReceiveCompletion = true }))
          talkback?(.next(.none))
        case let .next(element):
          if !didReceiveCompletion {
            if case let .some(element) = buffer[currentIndex] {
              sink(.next(element))
            }
            buffer[currentIndex] = element
            currentIndex = (currentIndex + 1) % count
            talkback?(.next(.none))
          } else {
            talkback?(.completed(.finished))
          }
        case .completed:
          for _ in 0..<count {
            if didReceiveCompletion {
              break
            }
            sink(.next(element))
          }
          sink(payload)
        }
      }
    }
  }
}

public func replaceAll<T>(
  with element: T
) ->  Operator<T, T> {
  return map { _ in element }
}

public func replaceAll<T: Equatable>(
  _ elements: T ...,
  with element: T
) ->  Operator<T, T> {
  return map { elements.contains($0) ? element : $0 }
}

public func replaceAll<S: Sequence>(
  _ elements: S,
  with element: S.Element
) ->  Operator<S.Element, S.Element> where S.Element: Equatable {
  return map { elements.contains($0) ? element : $0 }
}