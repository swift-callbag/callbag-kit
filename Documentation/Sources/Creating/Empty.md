#### [CallbagKit][Callbag] › [Documentation][Documentation] › [Sources][Sources] › [Creating][Creating]
# Empty
> A Callbag [source][Sources] that will emit `completed(.finished)` event immediately.
> And it is a [single][Sources] source.

```swift
A: ─|─>
```

**Examples**

```swift
  let source = empty() // <~ Sink<Void>

  _ = source
    |> sink(print) // completed(.finished)
```

```swift
  _ = fetch("fake-domain.com/get/user/123456") // assume this will emit `Foundation.Data`
    |> decode(type: User.self, decoder: UserDecoder) // assume this will raise error
    |> catchError {
      // here you can log this error somewhere
      return empty() // <~ Sink<User>
    }
    |> sink(print) // completed(.finished)
```

[Callbag]: <../../../README.md> (Callbag)
[Documentation]: <../../README.md> (Documentation)
[Sources]: <../README.md> (Sources)
[Creating]: <./README.md> (Creating)