public func assert<T>(
  _ prefix: String = "",
  file: StaticString = #file,
  line: UInt = #line
) ->  Operator<T, T> {
  return { source in
    return { sink in
      source { payload in
        switch payload {
        case let .start(tb):
          sink(.talkback(tb))
        case .next:
          sink(payload)
        case let .completed(.failed(error)):
          if prefix == "" {
            fatalError("\(error)", file: file, line: line)
          } else {
            fatalError("\(error)\nmessage: \(prefix)", file: file, line: line)
          }
        case .completed:
          sink(payload)
        }
      }
    }
  }
}