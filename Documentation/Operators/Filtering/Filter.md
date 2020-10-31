#### [CallbagKit][Callbag] › [Documentation][Documentation] › [Operators][Operators] › [Filtering][Filtering]
# Filter
> A Callbag [operator][Operators] that will emit only the elements that meet a
> certain condition. And it returns a [pullable][Sources] / [listenable][Sources]
> source, depends on the given callbag sources types.

<img src="./Filter.png">

<!-- ```swift
A: ────(🔴)────(🟡)────(🟢)────(🔵)────(🔵)────(🟢)────(🟡)────(🔴)──|─>
         │       │       │       │       │       │       │       │    │
         ⅴ       ⅴ       ⅴ       ⅴ       ⅴ       ⅴ       ⅴ       ⅴ    ⅴ
    ┌──────────────────────────────────────────────────────────────────┐
    │                                                                  │
    │                    filter({ $0 != 🟢 }) -> B                     │
    │                                                                  │
    └────┬───────┬───────────────┬───────┬───────────────┬───────┬────┬┘
         ⅴ       ⅴ               ⅴ       ⅴ               ⅴ       ⅴ    ⅴ
B: ────(🔴)────(🟡)────────────(🔵)────(🔵)────────────(🟡)────(🔴)──|─>
``` -->

**Examples**

```swift
  let source = from(1...10)

  _ = source
    |> filter({ $0 % 2 == 0 })
    |> forEach(print) // 2
                      // 4
                      // 6
                      // 8
                      // 10
```

[Callbag]: <../../../README.md> (Callbag)
[Documentation]: <../../README.md> (Documentation)
[Operators]: <../README.md> (Operators)
[Filtering]: <./README.md> (Filtering)

[Sources]: <../../Sources/README.md> (Sources)