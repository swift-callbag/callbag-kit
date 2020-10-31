#### [CallbagKit][Callbag] › [Documentation][Documentation] › [Operators][Operators] › [Timing][Timing]
# Wait
> A Callbag [operator][Operators] that shift the emissions from a source forward
> in time by a particular amount. And it returns a [listenable][Sources] source.

<img src="./Wait.png">

<!-- ```swift
A: ─(🔴)────(🟡)────(🟢)────(🔵)────(🔵)────(🟢)────(🟡)────(🔴)──|─>
      │       │       │       │       │       │       │       │    │
      ⅴ       ⅴ       ⅴ       ⅴ       ⅴ       ⅴ       ⅴ       ⅴ    ⅴ
    ┌──────────────────────────────────────────────────────────────────┐
    │                                                                  │
    │                        wait([  ⏱️  ]) -> B                      │
    │                                                                  │
    └────┬───────┬───────┬───────┬───────┬───────┬───────┬───────┬────┬┘
         ⅴ       ⅴ       ⅴ       ⅴ       ⅴ       ⅴ       ⅴ       ⅴ    ⅴ
B: ────(🔴)────(🟡)────(🟢)────(🔵)────(🔵)────(🟢)────(🟡)────(🔴)──|─>
``` -->

**Examples**

```swift
_ = from(1...3)
  |> wait(.second)
  |> sink(print) // 1 after .second
                 // 2 after .second from previous emission
                 // 3 after .second from previous emission
```

[Callbag]: <../../../README.md> (Callbag)
[Documentation]: <../../README.md> (Documentation)
[Operators]: <../README.md> (Operators)
[Timing]: <./README.md> (Timing)

[Sources]: <../../Sources/README.md> (Sources)