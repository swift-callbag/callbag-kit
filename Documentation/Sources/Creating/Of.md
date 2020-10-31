#### [CallbagKit][Callbag] › [Documentation][Documentation] › [Sources][Sources] › [Creating][Creating]
# Of
> A Callbag [source][Sources] that will emit values from a given parameters.
> And it is a [pullable][Sources] source.

```swift
A: ─────(1)─────(2)─────(3)─────(4)─────|─>
```

**Examples**

```swift
  let source = of() // <~ Sink<Void> aka empty()

  _ = source
    |> sink(print) // completed(.finished)
```

```swift
  let source = of(-2, 3) // <~ Sink<Int>

  _ = source
    |> forEach(print) // -2
                      // -1
```

```swift
  let source = of(from(1...2), from(3...4)) // <~ Sink<Sink<Int>>

  _ = source
    |> merge()
    |> forEach(print) // 1
                      // 2
                      // 3
                      // 4
```

[Callbag]: <../../../README.md> (Callbag)
[Documentation]: <../../README.md> (Documentation)
[Sources]: <../README.md> (Sources)
[Creating]: <./README.md> (Creating)