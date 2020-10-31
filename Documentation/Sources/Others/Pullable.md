#### [CallbagKit][Callbag] › [Documentation][Documentation] › [Sources][Sources] › [Others][Others]
# Pullable
> A Callbag [source][Sources] that convert a [listenable][Sources] to a [pullable][Sources].

```swift
A: ───────────────(0)─────(1)───────────────(2)────────(3)─────(4)──────>
```

*Note:* this operator will cause blocking on the current thread.

**Examples**

```swift
  var source = pullable(interval(.second) |> map(add(1)))

  var talkback: SourceTalkback<Int>!
  source {
    switch $0 {
    case let .start(tb):
      talkback = tb
    default:
      print($0) // next(1)
                // next(2)
                // next(3)
                // completed(finished)
    }
  }

  for _ in 1...3 {
    talkback(.next(.none))
  }

  talkback(.completed(.finished))
```

[Callbag]: <../../../README.md> (Callbag)
[Documentation]: <../../README.md> (Documentation)
[Sources]: <../README.md> (Sources)
[Others]: <./README.md> (Others)