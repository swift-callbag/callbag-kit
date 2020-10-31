<h1 style="font-size: 4em;">Callbag<i>Kit</i> 🧰</h1>

> **Callbag**Kit is an open-source, a lightweight Swift framework, an implementation
> of *[Callbag][cb-js]*, and last but not least built with ❤️.
>
> The framework is following the functional-programming style, that means it is just
> a pure functions that can be composed together to create a one composed-function.
> Plus the framework is compatible with all Apple platforms & Linux.
>
> **Callbag**Kit has rich starter functions to help you entering the
> reactive-programming world with ease. Check out [How-To-DIY](./How-To-DIY.md)
> for brief-explanation how this framework actually works, and how to write your
> own utilities functions to fulfil your desire goal.
> 
> Special thanks to [@André Staltz](https://github.com/staltz) for introducing
> such as concept.

- [Introduction](#introduction)
- [Documentation](#documentation)
- [Requirements](#requirements)
- [Dependencies](#dependencies)
- [Installation](#installation)
- [Contributing](#contributing)
- [License](#license)


<hr align="center" style="background-color: #393939; height: 2px">

## Introduction

Imagine a hybrid between an Observable and an (Async) Iterable, that's what
callbags are all about. In addition, the internals are tiny because it's all
done with a few simple callbacks, following the [callbag spec][cb-js]. As a
result, it's tiny and fast.

If you are new to reactive programming, read this article [What is ReactiveProgramming?][WhatIsReactiveProgramming?]
before jumping to [How-To-DIY](./How-To-DIY.md).

**Highlights:**

- Supports reactive stream programming
- Supports iterable programming (also!)
- Same operator works for both of the above
- Really Fast! [Faster than][Benchmark] ([ReactiveSwift][ReactiveSwift] and [RxSwift][RxSwift])
- Extensible: no core library! Everything is a utility function

**Terminology**

- **source**: a callbag that delivers data
- **sink**: a callbag that receives data
- **puller sink**: a sink that actively requests data from the source
- **pullable source**: a source that delivers data only on demand (on receiving a request)
- **listener sink**: a sink that passively receives data from the source
- **listenable source**: source which sends data to the sink without waiting for requests
- **operator**: a callbag based on another callbag which applies some operation

<hr align="center" style="background-color: #393939; height: 2px">

## Documentation
A list of all the functionalities provided by this framework are in
[documentation](./Documentation/README.md), along with descriptions, visual
representations and examples. However, this framework is divided into these four parts:

1. [Sources](./Documentation/Sources/README.md)
2. [Sinkers](./Documentation/Sinkers/README.md)
3. [Operators](./Documentation/Operators/README.md)
4. [Pipes](./Documentation/Pipes/README.md)

<hr align="center" style="background-color: #393939; height: 2px">

## Requirements
**Swift 5.0+**

<hr align="center" style="background-color: #393939; height: 2px">

## Dependencies
No external dependencies imported, only using Swift's `Foundation`, and `Dispatch`

<hr align="center" style="background-color: #393939; height: 2px">

## Installation

**Swift Package Manager**

```swift
  .package(url: "https://github.com/swift-callbag/callbag-kit.git", from: "0.0.1")
```
<hr align="center" style="background-color: #393939; height: 2px">

## Contributing
The Callbag philosophy is: build it yourself 😁, *But you may take a look at our
[contributing](./CONTRIBUTING.md) guidelines if you're interested in helping!*

**Pending features** that ( must! / maybe? ) arrive in future.

- [X] - [Benchmarks!][Benchmark]
- [ ] - Unit Tests!
- [ ] - Compilable code examples!
- [ ] - installation via [CocoaPods](https://cocoapods.org/)?
- [ ] - installation via [Carthage](https://github.com/Carthage/Carthage)?

<hr align="center" style="background-color: #393939; height: 2px">

## License

This framework is under the [MIT License](./LICENSE.md)

[cb-js]: <https://github.com/callbag/callbag> (CB-JS)

[Benchmark]: <https://github.com/swift-callbag/callbag-benchmark.git> (Benchmark)
[WhatIsReactiveProgramming?]: <https://github.com/Atimca/Reactive-programming-Article> (What is Reactive Programming?)
[ReactiveSwift]: <https://github.com/ReactiveCocoa/ReactiveSwift> (ReactiveSwift)
[RxSwift]: <https://github.com/ReactiveX/RxSwift> (RxSwift)