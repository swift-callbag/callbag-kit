#### [CallbagKit][Callbag] › [Documentation][Documentation] › [Sources][Sources] › [Multicasting][Multicasting]
# PublishSubject
> A Callbag [source][Sources] that emits to an observer only those items that are
> emitted by the source Observable(s) subsequent to the time of the subscription.
> And it is a [listenable][Sources] source.
>
> Note that a `PublishSubject` may begin emitting items immediately upon creation
> (unless you have taken steps to prevent this), and so there is a risk that one
> or more items may be lost between the time the Subject is created and the observer
> subscribes to it. If you need to guarantee delivery of all items from the source
> Observable, you’ll need either to form that Observable with Create so that you can
> manually reintroduce “cold” Observable behavior (checking to see that all observers
> have subscribed before beginning to emit items), or switch to using a ReplaySubject
> instead.
>
> If the source Observable terminates with an error, the `PublishSubject` will
> not emit any items to subsequent observers, but will simply pass along the error
> notification from the source Observable.

**Examples**

```swift
  let subject: Subject<Int> = makeSubject()
  // OR
  let subject: Subject<Int> = makeSubject(.publish)
  // OR
  let subject: Subject<Int> = makePublishSubject()

  _ = from(subject)
    |> forEach(print) // 1
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
  let subject: Subject<Int> = makeSubject()
  // OR
  let subject: Subject<Int> = makeSubject(.publish)
  // OR
  let subject: Subject<Int> = makePublishSubject()

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

  subject(.completed(.failed(SomeError())))
```

[Callbag]: <../../../README.md> (Callbag)
[Documentation]: <../../README.md> (Documentation)
[Sources]: <../README.md> (Sources)
[Multicasting]: <./README.md> (Multicasting)