public typealias Subject<T> = (Source<T>) -> Void

public enum SubjectStrategy<T> {
  case
    publish,
    behavior(T),
    replay,
    async
}

public func makeSubject<E>(_ strategy: SubjectStrategy<E> = .publish) -> Subject<E> {
  switch strategy {
  case .publish:          return makePublishSubject()
  case .behavior(let e):  return makeBehaviorSubject(e)
  case .replay:           return makeReplaySubject()
  case .async:            return makeAsyncSubject()
  }
}