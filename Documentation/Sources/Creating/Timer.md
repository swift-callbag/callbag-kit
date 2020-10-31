#### [CallbagKit][Callbag] › [Documentation][Documentation] › [Sources][Sources] › [Creating][Creating]
# Timer
> A Callbag [source][Sources] that after given duration, emit numbers in sequence
> every specified duration. And it is a [listenable][Sources] source.

```swift
A: ───────────────(0)─────(1)─────(2)─────(3)─────(4)──────>
```

**Examples**

```swift
  let source = timer(.second, .seconds(5)) // <~ Sink<Int>

  _ = source
    |> take(5)
    |> forEach(print) // 0 after second
                      // 1 after 5 seconds from last emission
                      // 2 after 5 seconds from last emission
                      // 3 after 5 seconds from last emission
                      // 4 after 5 seconds from last emission
```

```swift
  let source = timer(.second) // <~ Sink<Int>
  // source is equivalent to `interval(.second) |> take(1)`
  _ = source
    |> sink(print) // completed(.finished)
```

[Callbag]: <../../../README.md> (Callbag)
[Documentation]: <../../README.md> (Documentation)
[Sources]: <../README.md> (Sources)
[Creating]: <./README.md> (Creating)