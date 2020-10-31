#### [CallbagKit][Callbag] › [Documentation][Documentation] › [Operators][Operators] › [Matching][Matching]
## Contains-Element
> A Callbag [operator][Operators] that will determine whether a specific item
> exists among all items emitted from source. And it returns a [single][Sources]
> source.

<img src="./Contains1.png">

<!-- ```swift
A: ────(🔵)────(🟡)────(🟢)────(🟡)────(🔴)────(🔴)────(🟡)────(🟡)──|─>
         │       │       │       │       │
         ⅴ       ⅴ       ⅴ       ⅴ       ⅴ
    ┌──────────────────────────────────────────────────────────────────┐
    │                                                                  │
    │                          contains(🔴) -> B                       │
    │                                                                  │
    └────────────────────────────────────┬─────────────────────────────┘
                                         ⅴ
B: ───────────────────────────────────(true)|─>
``` -->
**Note**
> Available when `Output` conforms to `Equatable`

**Examples**

```swift
  let source = from(1...10)

  _ = source
    |> contains(2)
    |> forEach(print) // true
```

---

## Contains-Where
> A Callbag [operator][Operators] that will determine whether an item exists among
> all items emitted from source that passes a predicate test. And it returns a
> [single][Sources] source.

<img src="./Contains2.png">

<!-- ```swift
A: ────(🔵)────(🟡)────(🟢)────(🟡)────(🔴)────(🔴)────(🟡)────(🟡)──|─>
         │       │       │       │       │
         ⅴ       ⅴ       ⅴ       ⅴ       ⅴ
    ┌──────────────────────────────────────────────────────────────────┐
    │                                                                  │
    │                     contains({ $0 == 🔴 }) -> B                  │
    │                                                                  │
    └────────────────────────────────────┬─────────────────────────────┘
                                         ⅴ
B: ───────────────────────────────────(true)|─>
``` -->

**Examples**

```swift
  let source = from(1...10)

  _ = source
    |> contains({ $0 % 2 == 0 })
    |> forEach(print) // true
```

[Callbag]: <../../../README.md> (Callbag)
[Documentation]: <../../README.md> (Documentation)
[Operators]: <../README.md> (Operators)
[Matching]: <./README.md> (Matching)

[Sources]: <../../Sources/README.md> (Sources)