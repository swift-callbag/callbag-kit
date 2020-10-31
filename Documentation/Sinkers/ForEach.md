#### [CallbagKit][Callbag] › [Documentation][Documentation] › [Sinkers][Sinkers]
# ForEach
> A Callbag sinker that will only emit next event values. And it returns a `Cancellable`.

**Examples**

```swift
_ = from(0...5)
  |> forEach(print) // 0
                    // 1
                    // 2
                    // 3
                    // 4
```

[Callbag]: <../../README.md> (Callbag)
[Documentation]: <../README.md> (Documentation)
[Sinkers]: <./README.md> (Sinkers)