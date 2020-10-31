public typealias Sink<T> = Callbag<T, Optional<Any>>
public typealias Source<T> = Callbag<Optional<Any>, T>

public typealias Consumer<T> = (Sink<T>) -> Void
public typealias Producer<T> = (@escaping Consumer<T>) -> Void

public typealias SourceTalkback<T> = (Source<T>) -> Void

public typealias Operator<A, B> = (@escaping Producer<A>) -> Producer<B>
public typealias CancellableProducer<T> = (Producer<T>) -> Cancellable
public typealias AwaitableProducer<T> = (Producer<T>) -> Awaitable<T>

infix operator |>: AdditionPrecedence

public func |> <A, B>(
  source: @escaping Producer<A>,
  `operator`: @escaping Operator<A, B>
) -> Producer<B> {
  return `operator`(source)
}

public func |> <T>(
  source: @escaping Producer<T>,
  sink: @escaping CancellableProducer<T>
) -> Cancellable {
  return sink(source)
}

public func |> <T>(
  source: @escaping Producer<T>,
  sink: @escaping AwaitableProducer<T>
) -> Awaitable<T> {
  return sink(source)
}