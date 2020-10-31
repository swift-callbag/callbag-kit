#### [CallbagKit][Callbag] › [Documentation][Documentation] › [Sources][Sources] › [Creating][Creating]
# Just
> A Callbag [source][Sources] that will emit value from a given parameter.
> And it is a [single][Sources] source.

```swift
A: ─────(1)─────|─>
```

**Examples**

```swift
  func fetchFile(_ path: String) throws -> Data {
    if File.exists(path) {
      return File.read(path)
    } else {
      throw FileError.notFound(path)
    }
  }

  let source = just(fetchFile("fake/path/to/file")) // <~ Sink<Data>

  _ = source
    |> forEach(print) // Data 1023948 bytes
```

```swift
  let source = just("Hola") // <~ Sink<String>

  _ = source
    |> forEach(print) // "Hola"
```

```swift
  let source = just(from(1...4)) // <~ Sink<Sink<Int>>

  _ = source
    |> flatten()
    |> forEach(print) // 1
                      // 2
                      // 3
                      // 4
```

[Callbag]: <../../../README.md> (Callbag)
[Documentation]: <../../README.md> (Documentation)
[Sources]: <../README.md> (Sources)
[Creating]: <./README.md> (Creating)