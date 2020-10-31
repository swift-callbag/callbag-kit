#### [CallbagKit][Callbag] › [Documentation][Documentation] › [Sources][Sources] › [Multicasting][Multicasting]
# Share
> A Callbag [source][Sources] that broadcasts a source to multiple sinks.
> Does reference counting on sinks and starts the source when the first sink gets
> connected. And it is either a [pullable][Sources] / [listenable][Sources]
> source, depends on the given callbag sources types.

```swift
A: ───────────────(0)─────(1)─────(2)─────(3)─────(4)──────>
```

**Examples**

Share a listenable source to two listeners:

```swift
  let source = share(interval(.second))

  _ = source
    |> map { "a\($0)" }
    |> forEach(print) // a0
                      // a1
                      // a2
                      // a3
                      // ...

  _ = source
    |> delay(.seconds(4))
    |> map { "b\($0)" }
    |> forEach(print) // b3
                      // b4
                      // b5
                      // b6
                      // ...
```

Share a pullable source to two pullers:

```swift
  let source = share(from(stride(from: 0, through: 2, by: 0.5)))

  var talkbackA: SourceTalkback<Double>!
  var talkbackB: SourceTalkback<Double>!
  source {
    if case let .start(tb) = $0 {
      talkbackA = tb
    } else {
      print("a", $0)
    }
  }

  source {
    if case let .start(tb) = $0 {
      talkbackB = tb
    } else {
      print("b", $0)
    }
  }

  talkbackA(.next(.none))
  // a next(0.0)
  // b next(0.0)
  talkbackA(.next(.none))
  // a next(0.5)
  // b next(0.5)
  talkbackB(.completed(.finished))
  // b completed(finished)
  talkbackA(.next(.none))
  // a next(1.0)
```

```swift
  var source = share(from(1...5))

  _ = sink({
    print("a", $0) // a next(1)
                   // a next(2)
                   // a next(3)
                   // a next(4)
                   // a next(5)
                   // a completed(finished)
  })(source)


  _ = sink({
    print("b", $0) // b completed(finished)
  })(source)
```

[Callbag]: <../../../README.md> (Callbag)
[Documentation]: <../../README.md> (Documentation)
[Sources]: <../README.md> (Sources)
[Multicasting]: <./README.md> (Multicasting)