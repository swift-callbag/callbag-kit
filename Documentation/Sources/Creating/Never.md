#### [CallbagKit][Callbag] › [Documentation][Documentation] › [Sources][Sources] › [Creating][Creating]
# Never
> A Callbag [source][Sources] that will emit only the start event.
> And it is a [harmful][Sources] source.

```swift
A: ──────>
```

*Note:* this will cause thread to hang forever. Even if used `timeout`, and using
`await` is the only way to get out of this.

**Examples**

With no threading involved
```swift
  let source = never() // <~ Sink<Never>

  _ = source
    |> sink(print) // nothing
```

With threading involved

```swift
  let source = never() // <~ Sink<Never>

  _ = source
    |> timeout(.second) // wil request completion after a second,
                        // but will not receive a completion
    |> sink(print) // will not even reach this stage
```

To avoid such scenario
```swift
  let source = never() // <~ Sink<Never>

  let awaitable = source
                |> await()

  _ = awaitable.wait() // will wait forever

  // can be avoided as following
  DispatchQueue.background.asyncAfter(deadline: .now() + .seconds(10)) {
    awaitable.cancel()
  }
  _ = awaitable.wait() // will only hang for 10 second, then it will get cancelled
```

[Callbag]: <../../../README.md> (Callbag)
[Documentation]: <../../README.md> (Documentation)
[Sources]: <../README.md> (Sources)
[Creating]: <./README.md> (Creating)