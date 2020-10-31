#### [CallbagKit][Callbag] › [Documentation][Documentation] › [Sources][Sources] › [Creating][Creating]
# Interval
> A Callbag [source][Sources] that will emits a sequence of integers spaced by a
> given time interval. And it is a [listenable][Sources] source.

```swift
A: ─────(0)─────(1)─────(2)─────(3)─────(4)──────>
```

**Examples**

```swift
  let source = interval(.second) // <~ Sink<Int>

  _ = source
    |> take(4)
    |> forEach(print) // 1
                      // 2
                      // 3
                      // 4
```

[Callbag]: <../../../README.md> (Callbag)
[Documentation]: <../../README.md> (Documentation)
[Sources]: <../README.md> (Sources)
[Creating]: <./README.md> (Creating)