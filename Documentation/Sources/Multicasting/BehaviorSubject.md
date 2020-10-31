#### [CallbagKit][Callbag] › [Documentation][Documentation] › [Sources][Sources] › [Multicasting][Multicasting]
# BehaviorSubject
> A Callbag [source][Sources] when a source subscribes to a `BehaviorSubject`,
> it begins by emitting the item most recently emitted by the source
> (or a seed/default value if none has yet been emitted) and then continues to
> emit any other items emitted later by the source(s).
>
> However, if the source terminates with an error, the `BehaviorSubject`
> will not emit any items to subsequent sources, but will simply pass along the
> error notification from the source. And it is a [listenable][Sources] source.

**Examples**

```swift
  let subject: Subject<Int> = makeSubject(.behavior(0))
  // OR
  let subject: Subject<Int> = makeBehaviorSubject(0)

  _ = from(subject)
    |> forEach(print) // 0
                      // 1
                      // 2
                      // 3
                      // 4
                      // 5


  for i in 1...5 {
    subject(.next(i))
  }

  subject(.completed(.finished))
```

```swift
  let subject: Subject<Int> = makeSubject(.behavior(0))
  // OR
  let subject: Subject<Int> = makeBehaviorSubject(0)

  _ = from(subject)
    |> sink(print) // next(0)
                   // next(1)
                   // next(2)
                   // next(3)
                   // next(4)
                   // next(5)
                   // completed(.failed(SomeError))


  for i in 1...5 {
    subject(.next(i))
  }

  subject(.completed(.failed(SomeError())))
```

[Callbag]: <../../../README.md> (Callbag)
[Documentation]: <../../README.md> (Documentation)
[Sources]: <../README.md> (Sources)
[Multicasting]: <./README.md> (Multicasting)