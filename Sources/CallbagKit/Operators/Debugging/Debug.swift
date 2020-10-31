public func debug<T>(
  _ message: @escaping @autoclosure () -> (String) = "",
  includeArrows: Bool = true
) ->  Operator<T, T> {
  return { source in
    return { sink in
      var talkback: Optional<SourceTalkback<T>> = .none
      func sendMessage(_ output: String) {
        let m = message()
        Swift.print(m == "" ? output : "\(m): \(output)")
      }
      sendMessage("\(includeArrows ? "≺─ " : "")request \(Source<T>.start({_ in}))")
      source { payload in
        switch payload {
        case let .start(tb):
          talkback = .some(tb)
          sendMessage("\(includeArrows ? "─≻ " : "")receive \(payload)")
          sink(.start({ payload in
            switch payload {
            case .start: return
            case .next:
              sendMessage("\(includeArrows ? "≺─ " : "")request \(payload)")
              talkback?(payload)
            case .completed:
              sendMessage("\(includeArrows ? "≺─ " : "")request \(payload)")
              talkback?(payload)
            }
          }))
        case .next:
          sendMessage("\(includeArrows ? "─≻ " : "")receive \(payload)")
          sink(payload)
        case .completed:
          sendMessage("\(includeArrows ? "─≻ " : "")receive \(payload)")
          sink(payload)
        }
      }
    }
  }
}