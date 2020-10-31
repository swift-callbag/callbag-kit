import struct Foundation.Date

public func durations<T>() ->  Operator<T, (Double, T)> {
  return { source in
    return { sink in
      var start: Double = Date().timeIntervalSince1970
      source { payload in
        switch payload {
        case let .start(tb):
          sink(.talkback(tb))
        case let .next(element):
          let end: Double = Date().timeIntervalSince1970
          /// in seconds
          let duration = end - start
          start = Date().timeIntervalSince1970
          sink(.next((duration, element)))
        case let .completed(completion):
          sink(.completed(completion))
        }
      }
    }
  }
}