#### [CallbagKit][Callbag] › [Documentation][Documentation] › [Sinkers][Sinkers]
# Observe
> A Callbag listener sinker that will only emit next, and completed events.
> And it returns a `Cancellable`. **Handles only listenable sources**.

**Examples**

```swift
_ = from(0...5)
  |> observe(print) // next(0)
                    // next(1)
                    // next(2)
                    // next(3)
                    // next(4)
                    // completed(.finished)
```

[Callbag]: <../../README.md> (Callbag)
[Documentation]: <../README.md> (Documentation)
[Sinkers]: <./README.md> (Sinkers)