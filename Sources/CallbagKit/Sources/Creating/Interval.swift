import Dispatch
import func Foundation.usleep

public func interval(
  _ duration: DispatchTimeInterval,
  on queue: DispatchQueue = DispatchQueue(label: DOMAIN("interval"))
) -> Producer<Int> {
  return { sink in
    let lock = RecursiveLock(label: DOMAIN("interval"))
    var didReceiveCompletion: Bool = false
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
        usleep(1)
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
    asyncRepeating()
  }
}