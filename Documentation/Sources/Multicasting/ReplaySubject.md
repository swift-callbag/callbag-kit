#### [CallbagKit][Callbag] › [Documentation][Documentation] › [Sources][Sources] › [Multicasting][Multicasting]
# ReplaySubject
> A Callbag [source][Sources] that emits to any observer all of the items that
> were emitted by the source Observable(s), regardless of when the observer
> subscribes. And it is a [listenable][Sources] source.
>
> There are also versions of `ReplaySubject` that will throw away old items once
> the replay buffer threatens to grow beyond a certain size, or when a specified
> timespan has passed since the items were originally emitted.
>
> If you use a `ReplaySubject` as an observer, take care not to call its onNext
> method (or its other on methods) from multiple threads, as this could lead
> to coincident (non-sequential) calls, which violates the Observable contract
> and creates an ambiguity in the resulting Subject as to which item or notification
> should be replayed first.

**Examples**

```swift
  let subject: Subject<Int> = makeSubject(.replay)
  // OR
  let subject: Subject<Int> = makeReplaySubject()

  _ = from(subject)
    |> forEach(print) // 1
                      // 2
                      // 3
                      // 4
                      // 5


  for i in 1...5 {
    subject(.next(i))
  }


  _ = from(subject)
    |> forEach(print) // 1
                      // 2
                      // 3
                      // 4
                      // 5

  subject(.completed(.finished))
```

```swift
  let subject: Subject<Int> = makeSubject(.replay)
  // OR
  let subject: Subject<Int> = makeReplaySubject()

  _ = from(subject)
    |> sink(print) // next(1)
                   // next(2)
                   // next(3)
                   // next(4)
                   // next(5)
                   // completed(.failed(SomeError))


  for i in 1...5 {
    subject(.next(i))
  }

  _ = from(subject)
    |> sink(print) // next(1)
                   // next(2)
                   // next(3)
                   // next(4)
                   // next(5)
                   // completed(.failed(SomeError))

  subject(.completed(.failed(SomeError())))
```

[Callbag]: <../../../README.md> (Callbag)
[Documentation]: <../../README.md> (Documentation)
[Sources]: <../README.md> (Sources)
[Multicasting]: <./README.md> (Multicasting)