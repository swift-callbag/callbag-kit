import Dispatch
import Foundation

/// this will work for main dispatch-queue
@discardableResult
public func blockingMain<T>() -> Operator<T, T> {
  return { source  in
    return { sink in
      source { payload in
        switch payload {
        case let .start(tb):
          sink(.talkback(tb))
        case .next:
          sink(payload)
        case .completed:
          sink(payload)
          exit(EXIT_SUCCESS)
        }
      }
      dispatchMain()
    }
  }
}

/// this will work for non-main dispatch-queue
@discardableResult
public func blocking<T>() -> Operator<T, T> {
  return { source  in
    return { sink in
      let semaphore = DispatchSemaphore(value: 0)
      source { payload in
        switch payload {
        case let .start(tb):
          sink(.talkback(tb))
        case .next:
          sink(payload)
        case .completed:
          sink(payload)
          semaphore.signal()
        }
      }
      semaphore.wait()
    }
  }
}