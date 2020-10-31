public func dropFirst<T>(_ count: Int = 1) ->  Operator<T, T> {
  return { source in
    return { sink in
      var talkback: Optional<SourceTalkback<T>> = .none
      var count = count
      source { payload in
        switch payload {
        case let .start(tb):
          talkback = .some(tb)
          sink(.talkback(tb))
        case .next:
          if count < 1 {
            sink(payload)
          } else {
            count = count - 1
            talkback?(.next(.none))
          }
        case .completed:
          sink(payload)
        }
      }
    }
  }
}

public func dropLast<T>(_ count: Int = 1) ->  Operator<T, T> {
  return { source in
    return { sink in
      var talkback: Optional<SourceTalkback<T>> = .none
      var buffer: Array<Optional<T>> = .init(repeating: .none, count: count)
      var currentIndex: Int = 0
      var isBufferFull: Bool {
        return buffer.allSatisfy(notEquals(.none))
      }
      source { payload in
        switch payload {
        case let .start(tb):
          talkback = .some(tb)
          sink(.talkback(tb))
        case let .next(element):
          let e = buffer[currentIndex]
          buffer[currentIndex] = element
          currentIndex = (currentIndex + 1) % count
          if case let .some(element) = e {
            sink(.next(element))
          } else {
            talkback?(.next(.none))
          }
        case .completed:
          sink(payload)
        }
      }
    }
  }
}

public func dropWhile<T>(_ predicate: @escaping (T) throws -> Bool) ->  Operator<T, T> {
  return { source in
    return { sink in
      var talkback: Optional<SourceTalkback<T>> = .none
      var failure: Optional<Completion> = .none
      var didStopDropping: Bool = false
      source { payload in
        switch payload {
        case let .start(tb):
          talkback = tb
          sink(.talkback(tb))
        case let .next(element):            
          do {
            if didStopDropping {
              sink(payload)
            } else if try !predicate(element) {
              didStopDropping = true
              sink(payload)
            } else {
              talkback?(.next(.none))
            }
          } catch {
            failure = .failed(error)
            talkback?(.completed(.finished))
          }
        case .completed:
          if case let .some(failed) = failure {
            sink(.completed(failed))
          } else {
            sink(payload)
          }
        }
      }
    }
  }
}

public func dropWhile<T, U>(_ notifier: @escaping Producer<U>) ->  Operator<T, T> {
  return { source in
    return { sink in
      let lock: RecursiveLock = RecursiveLock(label: DOMAIN("dropWhile"))
      var talkback: Optional<SourceTalkback<T>> = .none
      var notifierTalkback: Optional<SourceTalkback<U>> = .none
      var didReceiveNotifierCompletion: Bool = false
      source { payload in
        lock.withLock {
          switch payload {
          case let .start(tb):
            talkback = tb
            notifier { payload in
              lock.withLock {
                switch payload {
                case let .start(tb):
                  notifierTalkback = tb
                  notifierTalkback?(.next(.none))
                case .next:
                  notifierTalkback?(.next(.none))
                case .completed:
                  didReceiveNotifierCompletion = true
                }
              }
            }
            sink(.talkback(tb))
          case .next:
            if didReceiveNotifierCompletion {
              sink(payload)
            } else {
              talkback?(.next(.none))
            }
          case .completed:
            sink(payload)
          }
        }
      }
    }
  }
}

public func dropUntil<T, U>(_ notifier: @escaping Producer<U>) ->  Operator<T, T> {
  return { source in
    return { sink in
      let lock: RecursiveLock = RecursiveLock(label: DOMAIN("dropUntil"))
      var talkback: Optional<SourceTalkback<T>> = .none
      var notifierTalkback: Optional<SourceTalkback<U>> = .none
      var didReceiveElementFromNotifier: Bool = false
      source { payload in
        lock.withLock {
          switch payload {
          case let .start(tb):
            talkback = tb
            notifier { payload in
              lock.withLock {
                switch payload {
                case let .start(tb):
                  notifierTalkback = tb
                  notifierTalkback?(.next(.none))
                case .next:
                  didReceiveElementFromNotifier = true
                  notifierTalkback?(.completed(.finished))
                case .completed: return
                }
              }
            }
            sink(.talkback(tb))
          case .next:
            if didReceiveElementFromNotifier {
              sink(payload)
            } else {
              talkback?(.next(.none))
            }
          case .completed:
            sink(payload)
          }
        }
      }
    }
  }
}