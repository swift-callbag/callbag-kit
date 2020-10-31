import struct Foundation.Date

public func timestamps<T>() ->  Operator<T, (Double, T)> {
  return { source in
    return { sink in
      source { payload in
        switch payload {
        case let .start(tb):
          sink(.talkback(tb))
        case let .next(element):
          /// in seconds
          sink(.next((Date().timeIntervalSince1970, element)))
        case let .completed(completion):
          sink(.completed(completion))
        }
      }
    }
  }
}