import Dispatch

public func timer(
  _ delay: DispatchTimeInterval,
  _ duration: DispatchTimeInterval? = nil,
  on queue: DispatchQueue = DispatchQueue(label: DOMAIN("timer"))
) -> Producer<Int> {
  return { sink in
    queue.asyncAfter(deadline: .now() + delay) {
      if let duration = duration {
        var didReceiveCompletion: Bool = false
        let lock = RecursiveLock(label: DOMAIN("timer"))
        var i: Int = 0
        sink(.start({ payload in
          lock.withLock {
            switch payload {
            // NestedStartsNotAllowed From A Producer Perspective
            case .start: break
            case let .next(element):
              if let element = element as? Int {
                i = element
              }
            case .completed:
              didReceiveCompletion = true
            }
          }
        }))
        func asyncRepeating() {
          queue.asyncAfter(deadline: .now() + duration) {
            lock.withLock {
              if !didReceiveCompletion {
                sink(.next(i));
                i += 1;
                asyncRepeating()
              } else {
                sink(.completed(.finished))
              }
            }
          }
        }
        lock.withLock {
          if !didReceiveCompletion {
            sink(.next(i));
            i += 1;
            asyncRepeating()
          } else {
            sink(.completed(.finished))
          }
        }
      } else {
        sink(.next(0));
        sink(.completed(.finished))
      }
    }
  }
}