import Dispatch

public func buffer<T>(_ count: Int) ->  Operator<T, Array<T>> {
  return { source in
    return { sink in
      var talkback: Optional<SourceTalkback<T>> = .none
      var didReceiveCompletion: Bool = false
      var elements = Array<T>()
      source { payload in
        switch payload {
        case let .start(tb):
          talkback = .some(tb)
          sink(.whenReceiveCompletion({
            didReceiveCompletion = true
          }))
          talkback?(.next(.none))
        case let .next(element):
          if !didReceiveCompletion {
            if elements.count < count {
              elements.append(element)
            } else {
              sink(.next(elements))
              elements = [element]
            }
            talkback?(.next(.none))
          } else {
            talkback?(.completed(.finished))
          }
        case let .completed(completion):
          if case .finished = completion {
            if !didReceiveCompletion && elements.count > 0 {
              sink(.next(elements))
            }
          }
          sink(.completed(completion))
        }
      }
    }
  }
}

public func buffer<T>(
  _ duration: DispatchTimeInterval,
  on queue: DispatchQueue = DispatchQueue(label: DOMAIN("buffer"))
) ->  Operator<T, Array<T>> {
  return { source in
    return { sink in
      var talkback: Optional<SourceTalkback<T>> = .none
      var didReceiveCompletion: Bool = false
      let lock = RecursiveLock(label: DOMAIN("buffer"))
      var elements = Array<T>()
      var didSendCompletion = false
      func asyncSink() {
        queue.asyncAfter(deadline: .now() + duration) {
          lock.withLock {
            if !didReceiveCompletion && !didSendCompletion {
              if elements.count > 0 {
                sink(.next(elements))
                elements = []
              }
              asyncSink()
            }
          }
        }
      }
      asyncSink()
      source { payload in
        switch payload {
        case let .start(tb):
          talkback = tb
          sink(.whenReceiveCompletion({
            lock.withLock { didReceiveCompletion = true }
          }))
          talkback?(.next(.none))
        case let .next(element):
          queue.async {
            lock.withLock {
              if !didReceiveCompletion {
                elements.append(element)
              } else {
                elements = []
                talkback?(.completed(.finished))
              }
            }
          }
          talkback?(.next(.none))
        case let .completed(completion):
          queue.asyncAfter(deadline: .now() + duration) {
            lock.withLock {
              didSendCompletion = true
              if elements.count > 0 {
                sink(.next(elements))
                elements = []
              }
              sink(.completed(completion))
            }
          }
        }
      }
    }
  }
}

public func buffer<T, U>(_ notifier: @escaping Producer<U>) ->  Operator<T, Array<T>> {
  return { source in
    return { sink in
      var talkback: Optional<SourceTalkback<T>> = .none
      var notifierTalkback: Optional<SourceTalkback<U>> = .none
      var didReceiveCompletion: Bool = false
      let lock = RecursiveLock(label: DOMAIN("buffer"))
      var elements = Array<T>()
      var didSendCompletion = false
      notifier { payload in
        switch payload {
        case let .start(tb):
          notifierTalkback = tb
          notifierTalkback?(.next(.none))
        case .next:
          lock.withLock {
            if !didReceiveCompletion && !didSendCompletion {
              if elements.count > 0 {
                sink(.next(elements))
                elements = []
              }
              notifierTalkback?(.next(.none))
            } else {
              notifierTalkback?(.completed(.finished))
            }
          }
        case .completed:
          lock.withLock { didReceiveCompletion = true }
        }
      }
      source { payload in
        switch payload {
        case let .start(tb):
          talkback = tb
          sink(.whenReceiveCompletion({
            lock.withLock { didReceiveCompletion = true }
          }))
          talkback?(.next(.none))
        case let .next(element):
          lock.withLock {
            if !didReceiveCompletion {
              elements.append(element)
              talkback?(.next(.none))
            } else {
              elements = []
              talkback?(.completed(.finished))
            }
          }
        case let .completed(completion):
          lock.withLock {
            didSendCompletion = true
            sink(.completed(completion))
          }
        }
      }
    }
  }
}