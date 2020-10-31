public func group<T, Key: Hashable>(
  _ predicate: @escaping (T) throws -> Key
) ->  Operator<T, (key: Key, source: Producer<T>)> {
  return { source in
    return { sink in
      var talkback: Optional<SourceTalkback<T>> = .none
      var didReceiveCompletion: Bool = false
      var failure: Optional<Completion> = .none
      var terminateKeysInOrder = Array<Key>()
      var elements = Dictionary<Key, Array<T>>()
      source { payload in
        switch payload {
        case let .start(tb):
          talkback = .some(tb)
          sink(.whenReceiveCompletion({ didReceiveCompletion = true }))
          talkback?(.next(.none))
        case let .next(element):
          do {
            let key = try predicate(element)
            if var elementsForKey = elements[key] {
              elementsForKey.append(element)
              elements[key] = elementsForKey
            } else {
              elements[key] = .init(arrayLiteral: element)
              terminateKeysInOrder.append(key)
            }
            talkback?(.next(.none))
          } catch {
            failure = .failed(error)
            talkback?(.completed(.finished))
          }
        case let .completed(completion):
          var iterator = terminateKeysInOrder.makeIterator()
          while let key = iterator.next(), !didReceiveCompletion {
            if let elementsForKey = elements[key] {
              sink(.next((key: key, source: from(elementsForKey))))
            }
          }
          if case let .some(failed) = failure {
            sink(.completed(failed))
          } else {
            sink(.completed(completion))
          }
        }
      }
    }
  }
}