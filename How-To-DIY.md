<h1>How to do it yourself</h1>

> The original [Callbag spec][JS-Callbag-Spec] is unopinionated and doesn't
> dictate how the implementation should go. This guide gives opinionated examples
> of how to implement some Callbag patterns. It helps you to get a concrete
> understanding how to use the spec.

- [JS and Swift implementation of Callbag vs CallbagKit](#js-and-swift-implementation-of-callbag-vs-callbagkit)
- [Extending the Callbag protocol?](#extending-the-callbag-protocol)
- [Handshakes and talkbacks](#handshakes-and-talkbacks)
- [Producers and Consumers](#producers-and-consumers)
- [Creating a sink](#creating-a-sink)
  - [Original-Listener](#original-listener)
  - [Modified-Listener](#modified-listener)
  - [Original-Puller](#original-puller)
  - [Modified-Puller](#modified-puller)
- [Creating a source](#creating-a-source)
  - [Original-Listenable](#original-listenable)
  - [Modified-Listenable](#modified-listenable)
  - [Original-Pullable](#original-pullable)
  - [Modified-Pullable](#modified-pullable)
- [Creating an operator](#creating-an-operator)
  - [Original-Operator](#original-operator)
  - [Modified-Operator](#modified-operator)
- [Factories](#factories)
- [Inspiration](#inspiration)

<hr align="center" style="background-color: #393939; height: 2px">

## JS and Swift implementation of Callbag vs CallbagKit

Well they both are the same except in swift no need for the `type` parameter,
because the cases of `enums` in swift can have names.

So in the original [Callbag-Spec][JS-Callbag-Spec]: Callbag defined as following.

```ts
  export type Callbag<I, O> = {
    (t: START, d: Callbag<O, I>): void;
    (t: DATA, d: I): void;
    (t: END, d?: any): void;
  };
```

In swift we can define Callbag as following.

```swift
  enum Callbag<I, O> {
    case start(Callbag<O, I>)
    case data(I)
    case end(Any?)
  }
```

But in [CallbagKit-Spec][Swift-Callbag-Spec]: we went a bit far.

```swift
  enum Callbag<I, O> {
    case start(Callbag<O, I>)
    case next(I)
    case completed(Completion)
  }

  // `Completion` is just another `Enum`

  enum Completion {
    case failed(Error)
    case finished
  }
```

*Current **Callbag**Kit implementation of Callbag protocol ends here.* However
the ideas in the section below may comes handy in the future.

<hr align="center" style="background-color: #393939; height: 2px">

## Extending the Callbag protocol?

The following is just an ideas that extends the Callbag protocol to be a bit
efficient, controlled, as well as drives to cleaner understandable code. 

`Completion` as a `Enum` type allow us to extend the protocol of `Callbag` in
future when its needed to have a new type of `Completion` e.g.
```swift
  case cancelled
```

instead of treat finished as cancelled which is already happen

Or add
```swift
  case terminated
```
Which will help to identify weather if process stopped normally, or been forced
by the app processor `Ctrl+C`

Or maybe change the `next(I)` to be `next(Emission<I>)`
```swift
  enum Emission<I> {
    //// Source will use this case to deliver items.
    case value(I)
    
    //-------------------------------------------------------------------------
    //// Sink can use these cases to talkback to source.

    // the following 2 cases can be used to tell source to pause/resume emissions
    case pause
    case resume

    // the following case can be used tell source to restart emissions.
    // Without the need of `repeats` operator
    case rewind

    // the following case can be used by the sink to request next emission from
    // pulllable source. Instead of using .next(nil)
    case wantItem
  }
```

Technically pause/resume can be achieved by creating a wrapper operator around the
`filter` operator. But it will not notify the source that we are pausing/resuming.
Which means source is actually emitting items but the `filter` operator is avoiding
them.

However, using pause/resume as protocol extension will assure that source is not
emitting, this leads to speed up the process of downstream/upstream talking.
Which drives to less talking, less memory allocating, also means less time (faster
execution) on benchmarking tests.

<hr align="center" style="background-color: #393939; height: 2px">

## Handshakes and talkbacks

A handshake is when the sink greets the source and the source greets the sink
back. Usually the order is `source(.start(sink))` then inside the implementation of
`source` we call `sink(.start(talkback))`. Notice that `talkback` is the payload. It
is possible that `talkback === source`, but often the talkback will be another
function.

Talkbacks receive `.next` and `.completed` messages from the sink, but never `.start`,
because the handshake has already occurred (it's just two `.start` messages, not
more than two).

We will see later with examples how this is important. But first let's define
some types that will help to make the explaining process more easy to understand.

The following two types were introduced in the original [Callbag-Spec][JS-Callbag-Spec]

```swift
  /**
  * A source only delivers data
  */
  typealias Source<T> = Callbag<Optional<Any>, T>

  /**
  * A sink only receives data
  */
  typealias Sink<T> = Callbag<T, Optional<Any>>
```

However, the following type wasn't introduced in the original [Callbag-Spec][JS-Callbag-Spec]

```swift
  /**
  * A way to let Sink to talkback to Source
  */
  typealias SourceTalkback<T> = (Source<T>) -> Void
```

<hr align="center" style="background-color: #393939; height: 2px">

## Producers and Consumers

As explained above sources takes a `.start` in order to subscribe a sink to it
like `source(.start(sink))`. Well, producer/consumer behave the same way but
without the need to call `.start`. So same behavior can be achieved as following
`producer(consumer)`, this is just for simplicity and writing less code.

A producer is simply a function that takes a consumer as an argument. While consumer
is a function that takes a [Callbag<I, O>][Swift-Callbag-Spec] as
an argument.

Literally they are just a swift `typealias`

```swift
  /**
  * A callback function only receives data
  */
  typealias Consumer<T> = (Sink<T>) -> Void

  /**
  * A callback function only delivers data
  */
  typealias Producer<T> = (Consumer<T>) -> Void
```

And this is why **Callbag**Kit is using `producer(consumer)` handshaking style
instead of `source(.start(sink))`, the following examples will walk through the
transformation process step by step from classic `source(.start(sink))` to modern
`producer(consumer)`.

<hr align="center" style="background-color: #393939; height: 2px">

## Creating a sink

Sinks are easy to create because they are meant for just receiving data, and
require less code to work. Sinks can be either listeners or pullers. Let's first
implement a listener sink.

### Original-Listener

A classic listener sink is a callbag function:

```swift
  func sink(_ payload: Sink<Int>) {

  }
```

The name of the argument doesn't matter.

```swift
  func sink(_ payload: Sink<Int>) {
    if case let .start(tb) = payload {
      // ...
    }
  }
```

The sink can use this talkback to terminate the relationship with the source.
For instance, we can terminate after 3 seconds have passed. 

```swift
  func sink(_ payload: Sink<Int>) {
    if case let .start(tb) = payload {
      /// Notice `tb` type is SourceTalkback<Int>
      _ = Timer.scheduledTimer(withTimeInterval: 3000, repeats: false) {
        tb(.completed(.finished))
      }      
    }
  }
```

To make the sink actually receive data, we need to pick `.next`:

```swift
  func sink(_ payload: Sink<Int>) {
    if case let .start(tb) = payload {
      /// Notice `tb` type is SourceTalkback<Int>
      _ = Timer.scheduledTimer(withTimeInterval: 3000, repeats: false) {
        tb(.completed(.finished))
      }      
    }
    if case let .next(data) = payload {
      // consume the data here, for instance:
      print(data)
    }
  }
```

If the sink receives `.completed`, it means the source is terminating the sink,
and it's the right moment to dispose of resources. For instance, we should cancel
that setTimeout, but for that we need to keep a reference to the returned timeout
handle:

```swift
  var handle: Timer?
  func sink(_ payload: Sink<Int>) {
    switch payload {
    case let .start(tb):
      handle = Timer.scheduledTimer(withTimeInterval: 3000, repeats: false) {
        tb(.completed(.finished))
      }      
    case let .next(data):
      print(data)
    case .completed:
      handle?.invalidate()
      handle = nil
    }
  }
```

Because it's common to keep state in a closure, we convert the code above into a
sink factory function:

```swift
  func makeSink() -> (Sink<Int>) -> Void {
    var handle: Timer?
    return { payload in
      switch payload {
      case let .start(tb):
        handle = Timer.scheduledTimer(withTimeInterval: 3000, repeats: false) {
          tb(.completed(.finished))
        }
      case let .next(data):
        print(data)
      case .completed:
        handle?.invalidate()
        handle = nil
      }
    }
  }

  /// this can be used like
  source(.start(makeSink()))
```

### Modified-Listener

```swift
  func sink(_ consumer: Consumer<Int>) -> Producer<Int> -> Void {
    return { producer in
      /// this is what we meant by `producer(consumer)`
      producer { payload in
        switch payload {
        case let .start(tb):
          handle = Timer.scheduledTimer(withTimeInterval: 3000, repeats: false) {
            tb(.completed(.finished))
          }
        case .next:
          consumer(payload)
        case .completed:
          consumer(payload)
          handle?.invalidate()
          handle = nil
        }
      }
    }
  }

  /// this can be used like
  sink(print)(source)
```

### Original-Puller

A puller sink can call the `talkback` with `.next` as argument. In the example
below, the puller requests data from the source until source emit a completion:

```swift
  func makeSink() -> (Sink<Int>) -> Void {
    var talkback: SourceTalkback<Int>?
    return { payload in
      switch payload {
      case let .start(tb):
        talkback = tb
        talkback?(.next(nil))
      case let .next(data):
        print(data)
        talkback?(.next(nil))
      case let .completed(completion):
        print(completion)
        talkback = nil
      }
    }
  }
```

### Modified-Puller

```swift
  func sink(_ consumer: @escaping Consumer<Int>) -> (Producer<Int>) -> Void {
    return { producer in
      var talkback: SourceTalkback<Int>?
      producer { payload in
        switch payload {
        case let .start(tb):
          talkback = tb
          talkback?(.next(nil))
        case .next:
          consumer(payload)
          talkback?(.next(nil))
        case .completed:
          consumer(payload)
          talkback = nil
        }
      }
    }
  }
```

<hr align="center" style="background-color: #393939; height: 2px">

## Creating a source

Now that you know how to create sinks (consumers of data), we can create sources
(producers of data) of two modes: listenables or pullables.

### Original-Listenable

A listenable source sends data to a sink regardless of requests `.next` from the
sink to the source. A basic example is to create a listenable source that wraps
the `Timer` API. In the example below, we will send `0` to the sink every
1 second:

```swift
  func source(_ payload: Source<Int>) {
    if case let .start(sink) = payload {
      _ = Timer.scheduledTimer(withTimeInterval: 3000, repeats: false) {
        sink(.next(0))
      }
    }
  }
```

We are missing something important, though: greeting the sink with a talkback
function (see [Handshake](#handshakes-and-talkbacks) section above).

```swift
  func source(_ payload: Source<Int>) {
    if case let .start(sink) = payload {
      _ = Timer.scheduledTimer(withTimeInterval: 3000, repeats: false) {
        sink(.next(0))
      }
      sink(.start(/* talkback callbag here */));
    }
  }
```

Now the question is: what should be the talkback? Its purpose is for the sink to
send `.completed` messages upwards, for cancelling the `Timer` for instance. If
we make `talkback=source`, then we lose support for multiple sinks. How? Think
about it: if the source is called multiple times with `.start` and a sink payload,
then we have called `Timer` multiple times. When one of those sinks sends
`.completed` upwards, we want to stop the `Timer` only for that sink, not for all
of them. This is why we need a talkback for every different sink. Below, we make
the talkback recognize `.completed` messages and clear the `Timer`:

```swift
  func source(_ payload: Source<Int>) {
    if case let .start(sink) = payload {
      let handle = Timer.scheduledTimer(withTimeInterval: 3000, repeats: false) {
        sink(.next(0))
      }
      let talkback: SourceTalkback<Int> = { talkbackPayload in
        if case .completed = talkbackPayload {
          handle?.invalidate()
          handle = nil
        }
      }
      sink(.start(talkback))
    }
  }
```

Notice we don't need to handle `.next` neither `.completed` for the `source` because its
only purpose is to setup the `Timer` and then plug the sink with the talkback.
Basically the sink thinks that the source is the talkback. It's so common to only
handle `.start` in sources.

### Modified-Listenable

```swift
  func source() -> Producer<Int> {
    return { sink in
      let handle = Timer.scheduledTimer(withTimeInterval: 3000, repeats: false) {
        sink(.next(0))
      }
      let talkback: SourceTalkback<Int> = { talkbackPayload in
        if case .completed = talkbackPayload {
          handle?.invalidate()
          handle = nil
        }
      }
      sink(.start(talkback))
    }
  }
```

### Original-Pullable

A pullable source differs from a listenable source in that it waits for the sink
to send a `.next` request to the talkback before sending a `.next` response back.
The example below sends numbers 10 until 20, only on demand:

```swift
  func source(_ payload: Source<Int>) {
    if case let .start(sink) = payload {
      var i = 10
      let talkback: SourceTalkback<Int> = { talkbackPayload in
        if case .next = talkbackPayload {
          defer { i += 1 }
          sink(.next(i))
        }
      }
      sink(.start(talkback))
    }
  }
```

Notice that in this case the talkback doesn't need to check `.completed` messages,
because there is nothing to be disposed. Some pullable sources may have resources
to be disposed upon `.completed`, though. Also it is important to send-back `.completed`
as well as preventing sink from requesting another `.next` after requesting `.completed`:

```swift
  func source(_ payload: Source<Int>) {
    if case let .start(sink) = payload {
      var i: Int? = 10
      let talkback: SourceTalkback<Int> = { talkbackPayload in
        if case .next = talkbackPayload {
          if let currentI = i, currentI <= 20 {
            i! += 1
            sink(.next(currentI))
          } else {
            sink(.completed(.finished))
          }
        }
        if case .completed = talkbackPayload {
          i = nil
          sink(.completed(.finished))
        }
      }
      sink(.start(talkback))
    }
  }
```

### Modified-Pullable

```swift
  func source() -> Producer<Int> {
    return { sink in
      var i: Int? = 10
      let talkback: SourceTalkback<Int> = { talkbackPayload in
        if case .next = talkbackPayload {
          if let currentI = i, currentI <= 20 {
            i! += 1
            sink(.next(currentI))
          } else {
            sink(.completed(.finished))
          }
        }
        if case .completed = talkbackPayload {
          i = nil
          sink(.completed(.finished))
        }
      }
      sink(.start(talkback))
    }
  }
```

<hr align="center" style="background-color: #393939; height: 2px">

## Creating an operator

Operators are functions that take a source as input and return another source
based on the first one. They are useful for creating transformation pipelines
through a utility like [pipe](./Documentation/Pipes/README.md). The
Callbag spec itself doesn't dictate how you should create operators, but if you
want to keep your operators interoperable with `pipe`, then follow the simple
convention:

```swift
let myOperator = args -> inputSource -> outputSource
```

This way, when you call it in a pipe as `myOperator(args)`:

```swift
  pipe(
    source,
    myOperator(args),
    sink(print)
  )
```

Let's see an example operator called `multiplyBy` that works on a source of integers:

### Original-Operator

```swift
  func multiplyBy(_ factor: Int) -> (@escaping SourceTalkback<Int>) -> SourceTalkback<Int> {
    return { inputSource in
      return { outputSource in
        var inputSourceTalkback: Optional<SourceTalkback<Int>> = .none
        switch outputSource {
        case let .start(outputSink):
          inputSource(.start{ payload in
            switch payload {
            case let .start(tb):
              inputSourceTalkback = .some(tb)
              inputSourceTalkback?(.next(.none))
            case let .next(element):
              outputSink(.next(element * factor))
              inputSourceTalkback?(.next(.none))
            case .completed:
              outputSink(payload)
            }
          })
        default: break
        }
      }
    }
  }
```

How to use original-operator
```swift
  // using:
  //  - original-puller sink
  //  - original-pullable source

  let composedSource = multiplyBy(10)(source)
  composedSource(.start(makeSink())) // 100
                                     // 110
                                     // 120
                                     // 130
                                     // 140
                                     // ...
                                     // 200
                                     // finished
```

### Modified-Operator

```swift
  func multiplyBy(_ factor: Int) -> (@escaping Producer<Int>) -> Producer<Int> {
    return { inputSource in
      return { outputSource in
        var inputSourceTalkback: Optional<SourceTalkback<Int>> = .none
        inputSource { payload in
          switch payload {
          case let .start(tb):
            inputSourceTalkback = .some(tb)
            inputSourceTalkback?(.next(.none))
          case let .next(element):
            outputSource(.next(element * factor))
            inputSourceTalkback?(.next(.none))
          case .completed:
            outputSource(payload)
          }
        }
      }
    }
  }
```

How to use modified-operator
```swift
  // using:
  //  - modified-puller sink
  //  - modified-pullable source

  let composedSource = multiplyBy(10)(source())
  sink({
    print($0)
  })(composedSource) // next(100)
                     // next(110)
                     // next(120)
                     // next(130)
                     // next(140)
                     // ...
                     // next(200)
                     // completed(finished)
```

Two patterns are worth remembering:

- Calling the operator returns `inputSource => outputSource`
- Inside the implementation of `outputSource`, call `inputSource`

The input source is called with `(Consumer<Int>) -> ...`, an anonymous sink that does the
core logic of the operator. In this case, we multiply `inputSource` data by
`factor`, and pass it to the output sink.

<hr align="center" style="background-color: #393939; height: 2px">

## Factories

Factories of sources are similar, but even simpler than operators. They just
don't have `inputSource` arguments. So it's just:

`let myFactory = args -> outputSource`

Examples are:
[from](./Sources/CallbagKit/Sources/Creating/From.swift),
[interval](./Sources/CallbagKit/Sources/Creating/Interval.swift),
[combine](./Sources/CallbagKit/Operators/Combining/Combine.swift).

<hr align="center" style="background-color: #393939; height: 2px">

## Inspiration

For more examples, look at real source code for some existing operators. Since
it's often short, it's possible to understand quickly. Examples:

- [scan](./Sources/CallbagKit/Operators/Transforming/Scan.swift)
- [take](./Sources/CallbagKit/Operators/Filtering/Take.swift)
- [merge](./Sources/CallbagKit/Operators/Combining/Concat.swift)
- [async](./Sources/CallbagKit/Operators/Threading/Async.swift)

[JS-Callbag-Spec]: <https://github.com/callbag/callbag/blob/master/types.d.ts>
[Swift-Callbag-Spec]: <./Sources/CallbagKit/Types/Callbag.swift>