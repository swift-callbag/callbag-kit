public func share<T>(_ source: @escaping Producer<T>) -> Producer<T> {
  let lock: RecursiveLock = RecursiveLock(label: DOMAIN("share"))
  var sinks: Array<Optional<Consumer<T>>> = .init()
  var talkback: Optional<SourceTalkback<T>> = .none
  return { sink in
    lock.withLock {
      let index = sinks.endIndex
      sinks.append(sink)
      sink(.start({ payload in
        lock.withLock {
          switch payload {
          case .start: return
          case .next: talkback?(.next(.none))
          case .completed:
            sink(.completed(.finished))
            sinks[index] = .none
          }
        }
      }))
      if sinks.count == 1 {
        source { payload in
          lock.withLock {
            switch payload {
            case let .start(tb):
              talkback = tb
              sinks.forEach { $0?(payload) }
            case .next:
              sinks.forEach { $0?(payload) }
            case .completed:      
              sinks.forEach { $0?(payload) }
              sinks = []
            }
          }
        }
      }
    }
  }
}