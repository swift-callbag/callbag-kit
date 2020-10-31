#### [CallbagKit][Callbag] › [Documentation][Documentation] › [Sinkers][Sinkers]
# Await
> A Callbag sinker that will wait until the last next event value and then this
> last value can be retrieved if and only if this sinker received a completion
> `.finished` event. And it returns a `Awaitable`.

*Note:* this will hold the current thread, which means it cannot be used on mainThread similar to `blocking` unless if it was used for testing.

**Examples**

```swift
let awaitable = interval(.second)
              |> map(add(1))
              |> take(10)
              |> await()

print(awaitable.wait()) // 10
```

```swift
let awaitable = interval(.second)
              |> map(add(1))
              |> take(10)
              |> await()

print(awaitable.wait(.seconds(9))) // nil
```

```swift
let awaitable = interval(.second)
              |> map(add(1))
              |> take(10)
              |> await()

DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(9)) {
  awaitable.cancel()
  Config.sharedVar = Config.defaultSharedVar
}

DispatchQueue.background.async {
  let tempSharedVar = awaitable.wait()
  if tempSharedVar != nil {
    Config.sharedVar = tempSharedVar
  }
}

```

[Callbag]: <../../README.md> (Callbag)
[Documentation]: <../README.md> (Documentation)
[Sinkers]: <./README.md> (Sinkers)