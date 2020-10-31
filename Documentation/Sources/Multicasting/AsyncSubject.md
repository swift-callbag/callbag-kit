#### [CallbagKit][Callbag] › [Documentation][Documentation] › [Sources][Sources] › [Multicasting][Multicasting]
# AsyncSubject
> A Callbag [source][Sources] that emits the last value (and only the last value)
> emitted by the source, and only after that source completes.
> (If the source does not emit any values, the `AsyncSubject` also
> completes without emitting any values.)
>
> It will also emit this same final value to any subsequent observers. However,
> if the source terminates with an error, the `AsyncSubject` will not emit any
> items, but will simply pass along the error notification from the source. And
> it is a [listenable][Sources] source.

**Examples**

```swift
  let subject: Subject<Int> = makeSubject(.async)
  // OR
  let subject: Subject<Int> = makeAsyncSubject()

  _ = from(subject)
    |> forEach(print) // 5


  for i in 1...5 {
    subject(.next(i))
  }
  // Important to terminate subject here, otherwise it will act as `never`
  subject(.completed(.finished))
```

```swift
  let subject: Subject<Int> = makeSubject(.async)
  // OR
  let subject: Subject<Int> = makeAsyncSubject()

  _ = from(subject)
    |> sink(print) // completed(.failed(SomeError))


  for i in 1...5 {
    subject(.next(i))
  }
  // Important to terminate subject here, otherwise it will act as `never`
  subject(.completed(.failed(SomeError())))
```

[Callbag]: <../../../README.md> (Callbag)
[Documentation]: <../../README.md> (Documentation)
[Sources]: <../README.md> (Sources)
[Multicasting]: <./README.md> (Multicasting)