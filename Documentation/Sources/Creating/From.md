#### [CallbagKit][Callbag] › [Documentation][Documentation] › [Sources][Sources] › [Creating][Creating]
# From
> A Callbag [source][Sources] that will convert various other objects and data
> types into a source. And it is either [listenable][Sources] / [pullable][Sources]
> source, depends on the given parameters.

```swift
A: ────(🔵)────(🟢)────(🟡)────(🔴)──|─>
```

**Examples**

```swift
  func range(_ min: Int, max: Int) -> () -> Optional<Int> {
    var current = min
    return {
      if current < max {
        defer { current += 1 }
        return current
      } else {
        current = min
        return .none
      }
    }
  }

  let source = from(range(1, 5)) // pullable
  _ = source // <~ Sink<Int>
    |> take(4)
    |> forEach(print) // 1
                      // 2
                      // 3
                      // 4
```

```swift
  // indirect as a `Sequence`
  let source = from(1..<5) // pullable
  // OR directly as a `IteratorProtocol`
  let source = from((1..<5).makeIterator) // pullable

  _ = source // <~ Sink<Int>
    |> take(4)
    |> forEach(print) // 1
                      // 2
                      // 3
                      // 4
```

```swift
  let subject: Subject<Int> = makeSubject() // by default is PublisherSubject
  let source = from(subject) // listenable

  _ = source // <~ Sink<Int>
    |> take(4)
    |> forEach(print) // 1
                      // 2
                      // 3
                      // 4

  for i in 1...4 {
    subject(.next(i))
  }

  subject(.completed(.finished))
```

[Callbag]: <../../../README.md> (Callbag)
[Documentation]: <../../README.md> (Documentation)
[Sources]: <../README.md> (Sources)
[Creating]: <./README.md> (Creating)