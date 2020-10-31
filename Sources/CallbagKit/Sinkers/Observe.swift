public func observe<T>(_ consumer: @escaping Consumer<T>) -> CancellableProducer<T> {
  return { source  in
    var talkback: Optional<SourceTalkback<T>> = .none
    var shouldCancelNow = false
    var isCompletedAlready = false
    
    source { payload in
      switch payload {
      case let .start(tb):
        talkback = tb
        if shouldCancelNow && !isCompletedAlready {
          talkback?(.completed(.finished))
        }
      case .next:
        // to prevent inappropriate implemented factories/operators
        // from sending next after sending completion...
        if !isCompletedAlready {
          return consumer(payload)
        }
      case .completed:
        if !isCompletedAlready {
          isCompletedAlready = true
          return consumer(payload)
        }
      }
    }
    
    return Cancellable {
      if !isCompletedAlready {
        if talkback != nil {
          talkback?(.completed(.finished))
        } else {
          shouldCancelNow = true
        }
      }
    }
  }
}