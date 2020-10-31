#### [CallbagKit][Callbag] › [Documentation][Documentation] › [Sources][Sources] › [Others][Others]
# Iteratable
> A Callbag [source][Sources] that convert a [listenable][Sources] to a [pullable][Sources],
> much similar to `pullable` except you cannot request a completion.

```swift
A: ───────────────(0)─────(1)───────────────(2)────────(3)─────(4)──────>
```

*Note:* this operator will cause blocking on the current thread.

**Examples**

```swift
var next = makeIterator(interval(.second) |> map(add(1)) |> take(5))

while let element = next() {
  print(element) // 1
                 // 2
                 // 3
                 // 4
                 // 5
}

print(next()) // nil
```

[Callbag]: <../../../README.md> (Callbag)
[Documentation]: <../../README.md> (Documentation)
[Sources]: <../README.md> (Sources)
[Others]: <./README.md> (Others)