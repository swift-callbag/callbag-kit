public func take<T>(_ count: Int) ->  Operator<T, T> {
  return { source in
    return { sink in
      var talkback: Optional<SourceTalkback<T>> = .none
      var count = count
      source { payload in
        switch payload {
        case let .start(tb):
          talkback = tb
          sink(.talkback(tb))
        case .next:
          if count > 0 {
            count = count - 1
            sink(payload)
          } else {
            talkback?(.completed(.finished))
          }
        case .completed:
          sink(payload)
        }
      }
    }
  }
}

public func takeLast<T>(_ count: Int = 1) ->  Operator<T, T> {
  return { source in
    return { sink in
      var talkback: Optional<SourceTalkback<T>> = .none
      var didReceiveCompletion: Bool = false
      let lastElements: UnsafeArray<Sink<T>> = .init()
      var lastElementsCount: Int = 0
      source { payload in
        switch payload {
        case let .start(tb):
          talkback = tb
          sink(.whenReceiveCompletion({ didReceiveCompletion = true }))
          talkback?(.next(.none))
        case .next:
          if lastElementsCount < count {
            lastElements.append(payload)
            lastElementsCount = lastElementsCount + 1
          } else {
            _ = lastElements.removeFirst()
            lastElements.append(payload)              
          }
          talkback?(.next(.none))
        case .completed(.finished):
          while lastElements.first != nil && !didReceiveCompletion {
            sink(lastElements.removeFirst())
          }
          sink(payload)
        case .completed:
          sink(payload)
        }
      }
    }
  }
}

public func takeWhile<T>(_ predicate: @escaping (T) throws -> Bool) ->  Operator<T, T> {
  return { source in
    return { sink in
      var talkback: Optional<SourceTalkback<T>> = .none
      var failure: Optional<Completion> = .none
      source { payload in
        switch payload {
        case let .start(tb):
          talkback = tb
          sink(.talkback(tb))
        case let .next(element):            
          do {
            if try predicate(element) {
              sink(payload)
            } else {
              talkback?(.completed(.finished))
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

public func takeWhile<T, U>(_ notifier: @escaping Producer<U>) ->  Operator<T, T> {
  return { source in
    return { sink in
      let lock: RecursiveLock = RecursiveLock(label: DOMAIN("takeWhile"))
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
            if !didReceiveNotifierCompletion {
              sink(payload)
            } else {
              talkback?(.completed(.finished))
            }
          case .completed:
            sink(payload)
          }
        }
      }
    }
  }
}

public func takeUntil<T, U>(_ notifier: @escaping Producer<U>) ->  Operator<T, T> {
  return { source in
    return { sink in
      let lock: RecursiveLock = RecursiveLock(label: DOMAIN("takeUntil"))
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
            if !didReceiveElementFromNotifier {
              sink(payload)
            } else {
              talkback?(.completed(.finished))
            }
          case .completed:
            sink(payload)
          }
        }
      }
    }
  }
}