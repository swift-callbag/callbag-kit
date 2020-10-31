public func indices<T>() ->  Operator<T, (Int, T)> {
  return { source in
    return { sink in
      var currentIndex: Int = -1
      source { payload in
        switch payload {
        case let .start(tb):
          sink(.talkback(tb))
        case let .next(element):
          currentIndex = currentIndex + 1
          sink(.next((currentIndex, element)))
        case let .completed(completion):
          sink(.completed(completion))
        }
      }
    }
  }
}