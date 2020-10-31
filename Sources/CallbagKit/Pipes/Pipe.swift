import Dispatch
import struct Foundation.Data

public struct Pipe<Element> {
  public let producer: Producer<Element>
}

/// MARK: Sources

public extension Pipe {
  init(_ producer: @escaping Producer<Element>) {
    self.producer = producer
  }

  init(_ producer: @escaping Subject<Element>) {
    self.producer = from(producer)
  }

  init(_ pipe: Pipe<Element>) {
    self.producer = pipe.producer
  }

  func share() -> Producer<Element> {
    return CallbagKit.share(producer)
  }
}

/// MARK: Sinkers

public extension Pipe {
  @discardableResult
  func sink(_ consumer: @escaping Consumer<Element>) -> Cancellable {
    return CallbagKit.sink(consumer)(producer)
  }

  @discardableResult
  func forEach<R>(_ consumer: @escaping (Element) -> R) -> Cancellable {
    return CallbagKit.forEach(consumer)(producer)
  }

  @discardableResult
  func enumerate(_ consumer: @escaping ((Int, Element)) -> Void) -> Cancellable {
    return CallbagKit.enumerate(consumer)(producer)
  }

  @discardableResult
  func assign<Root>(
    to keyPath: ReferenceWritableKeyPath<Root, Element>,
    on object: Root
  ) -> Cancellable {
    return CallbagKit.assign(to: keyPath, on: object)(producer)
  }

  @discardableResult
  func assign<Root>(
    to keyPath: WritableKeyPath<Root, Element>,
    on object: UnsafeMutablePointer<Root>
  ) -> Cancellable {
    return CallbagKit.assign(to: keyPath, on: object)(producer)
  }

  @discardableResult
  func assign(
    to object: UnsafeMutablePointer<Element>
  ) -> Cancellable {
    return CallbagKit.assign(to: object)(producer)
  }

  func await() -> Awaitable<Element> {
    return CallbagKit.await()(producer)
  }
}

/// MARK: Combining

public extension Pipe {
  static func combine<A, B>(
    _ a: @escaping Producer<A>,
    _ b: @escaping Producer<B>
  ) -> Pipe<(A, B)> {
    return Pipe<(A, B)>(
      CallbagKit.combine(a, b)
    )
  }

  static func combine<A, B, C>(
    _ a: @escaping Producer<A>,
    _ b: @escaping Producer<B>,
    _ c: @escaping Producer<C>
  ) -> Pipe<(A, B, C)> {
    return Pipe<(A, B, C)>(
      CallbagKit.combine(a, b, c)
    )
  }

  static func combine<A, B, C, D>(
    _ a: @escaping Producer<A>,
    _ b: @escaping Producer<B>,
    _ c: @escaping Producer<C>,
    _ d: @escaping Producer<D>
  ) -> Pipe<(A, B, C, D)> {
    return Pipe<(A, B, C, D)>(
      CallbagKit.combine(a, b, c, d)
    )
  }

  static func combine<A, B, C, D, E>(
    _ a: @escaping Producer<A>,
    _ b: @escaping Producer<B>,
    _ c: @escaping Producer<C>,
    _ d: @escaping Producer<D>,
    _ e: @escaping Producer<E>
  ) -> Pipe<(A, B, C, D, E)> {
    return Pipe<(A, B, C, D, E)>(
      CallbagKit.combine(a, b, c, d, e)
    )
  }

  static func combine<A, B, C, D, E, F>(
    _ a: @escaping Producer<A>,
    _ b: @escaping Producer<B>,
    _ c: @escaping Producer<C>,
    _ d: @escaping Producer<D>,
    _ e: @escaping Producer<E>,
    _ f: @escaping Producer<F>
  ) -> Pipe<(A, B, C, D, E, F)> {
    return Pipe<(A, B, C, D, E, F)>(
      CallbagKit.combine(a, b, c, d, e, f)
    )
  }

  func combine<B>(
    _ b: @escaping Producer<B>
  ) -> Pipe<(Element, B)> {
    return Pipe<(Element, B)>(
      CallbagKit.combine(producer, b)
    )
  }

  func combine<B, C>(
    _ b: @escaping Producer<B>,
    _ c: @escaping Producer<C>
  ) -> Pipe<(Element, B, C)> {
    return Pipe<(Element, B, C)>(
      CallbagKit.combine(producer, b, c)
    )
  }

  func combine<B, C, D>(
    _ b: @escaping Producer<B>,
    _ c: @escaping Producer<C>,
    _ d: @escaping Producer<D>
  ) -> Pipe<(Element, B, C, D)> {
    return Pipe<(Element, B, C, D)>(
      CallbagKit.combine(producer, b, c, d)
    )
  }

  func combine<B, C, D, E>(
    _ b: @escaping Producer<B>,
    _ c: @escaping Producer<C>,
    _ d: @escaping Producer<D>,
    _ e: @escaping Producer<E>
  ) -> Pipe<(Element, B, C, D, E)> {
    return Pipe<(Element, B, C, D, E)>(
      CallbagKit.combine(producer, b, c, d, e)
    )
  }

  func combine<B, C, D, E, F>(
    _ b: @escaping Producer<B>,
    _ c: @escaping Producer<C>,
    _ d: @escaping Producer<D>,
    _ e: @escaping Producer<E>,
    _ f: @escaping Producer<F>
  ) -> Pipe<(Element, B, C, D, E, F)> {
    return Pipe<(Element, B, C, D, E, F)>(
      CallbagKit.combine(producer, b, c, d, e, f)
    )
  }

  static func concat<T>(_ sources: Producer<T> ...) -> Pipe<T> {
    return Pipe<T>(CallbagKit.concat(sources))
  }

  static func concat<T>(_ sources: Array<Producer<T>>) -> Pipe<T> {
    return Pipe<T>(CallbagKit.concat(sources))
  }

  func concat<T>() -> Pipe<T> where Element == Producer<T> {
    return Pipe<T>(CallbagKit.concat()(producer))
  }

  func concat(_ b: @escaping Producer<Element>) -> Pipe {
    return Pipe(CallbagKit.concat(b)(producer))
  }

  func append(_ b: @escaping Producer<Element>) -> Pipe {
    return Pipe(CallbagKit.concat(b)(producer))
  }

  func prepend(_ b: @escaping Producer<Element>) -> Pipe {
    return Pipe(CallbagKit.concat(producer)(b))
  }

  static func merge<T>(_ sources: Producer<T> ...) -> Pipe<T> {
    return Pipe<T>(CallbagKit.merge(sources))
  }

  static func merge<T>(_ sources: Array<Producer<T>>) -> Pipe<T> {
    return Pipe<T>(CallbagKit.merge(sources))
  }

  func merge<T>() -> Pipe<T> where Element == Producer<T> {
    return Pipe<T>(CallbagKit.merge()(producer))
  }

  static func race<T>(_ sources: Producer<T> ...) -> Pipe<T> {
    return Pipe<T>(CallbagKit.race(sources))
  }

  static func race<T>(_ sources: Array<Producer<T>>) -> Pipe<T> {
    return Pipe<T>(CallbagKit.race(sources))
  }

  func race<T>() -> Pipe<T> where Element == Producer<T> {
    return Pipe<T>(CallbagKit.race()(producer))
  }

  static func switchLatest<T>(_ sources: Producer<T> ...) -> Pipe<T> {
    return Pipe<T>(CallbagKit.switchLatest(sources))
  }

  static func switchLatest<T>(_ sources: Array<Producer<T>>) -> Pipe<T> {
    return Pipe<T>(CallbagKit.switchLatest(sources))
  }

  func switchLatest<T>() -> Pipe<T> where Element == Producer<T> {
    return Pipe<T>(CallbagKit.switchLatest()(producer))
  }

  static func zip<A, B>(
    _ a: @escaping Producer<A>,
    _ b: @escaping Producer<B>
  ) -> Pipe<(A, B)> {
    return Pipe<(A, B)>(
      CallbagKit.zip(a, b)
    )
  }

  static func zip<A, B, C>(
    _ a: @escaping Producer<A>,
    _ b: @escaping Producer<B>,
    _ c: @escaping Producer<C>
  ) -> Pipe<(A, B, C)> {
    return Pipe<(A, B, C)>(
      CallbagKit.zip(a, b, c)
    )
  }

  static func zip<A, B, C, D>(
    _ a: @escaping Producer<A>,
    _ b: @escaping Producer<B>,
    _ c: @escaping Producer<C>,
    _ d: @escaping Producer<D>
  ) -> Pipe<(A, B, C, D)> {
    return Pipe<(A, B, C, D)>(
      CallbagKit.zip(a, b, c, d)
    )
  }

  static func zip<A, B, C, D, E>(
    _ a: @escaping Producer<A>,
    _ b: @escaping Producer<B>,
    _ c: @escaping Producer<C>,
    _ d: @escaping Producer<D>,
    _ e: @escaping Producer<E>
  ) -> Pipe<(A, B, C, D, E)> {
    return Pipe<(A, B, C, D, E)>(
      CallbagKit.zip(a, b, c, d, e)
    )
  }

  static func zip<A, B, C, D, E, F>(
    _ a: @escaping Producer<A>,
    _ b: @escaping Producer<B>,
    _ c: @escaping Producer<C>,
    _ d: @escaping Producer<D>,
    _ e: @escaping Producer<E>,
    _ f: @escaping Producer<F>
  ) -> Pipe<(A, B, C, D, E, F)> {
    return Pipe<(A, B, C, D, E, F)>(
      CallbagKit.zip(a, b, c, d, e, f)
    )
  }

  func zip<B>(
    _ b: @escaping Producer<B>
  ) -> Pipe<(Element, B)> {
    return Pipe<(Element, B)>(
      CallbagKit.zip(producer, b)
    )
  }

  func zip<B, C>(
    _ b: @escaping Producer<B>,
    _ c: @escaping Producer<C>
  ) -> Pipe<(Element, B, C)> {
    return Pipe<(Element, B, C)>(
      CallbagKit.zip(producer, b, c)
    )
  }

  func zip<B, C, D>(
    _ b: @escaping Producer<B>,
    _ c: @escaping Producer<C>,
    _ d: @escaping Producer<D>
  ) -> Pipe<(Element, B, C, D)> {
    return Pipe<(Element, B, C, D)>(
      CallbagKit.zip(producer, b, c, d)
    )
  }

  func zip<B, C, D, E>(
    _ b: @escaping Producer<B>,
    _ c: @escaping Producer<C>,
    _ d: @escaping Producer<D>,
    _ e: @escaping Producer<E>
  ) -> Pipe<(Element, B, C, D, E)> {
    return Pipe<(Element, B, C, D, E)>(
      CallbagKit.zip(producer, b, c, d, e)
    )
  }

  func zip<B, C, D, E, F>(
    _ b: @escaping Producer<B>,
    _ c: @escaping Producer<C>,
    _ d: @escaping Producer<D>,
    _ e: @escaping Producer<E>,
    _ f: @escaping Producer<F>
  ) -> Pipe<(Element, B, C, D, E, F)> {
    return Pipe<(Element, B, C, D, E, F)>(
      CallbagKit.zip(producer, b, c, d, e, f)
    )
  }
}

/// MARK: Debugging

public extension Pipe {
  func breakpoint(_ receive: @escaping (Sink<Element>) -> Bool) -> Pipe {
    return Pipe(CallbagKit.breakpoint(receive)(producer))
  }

  func breakpoint(
    receiveStart: ((SourceTalkback<Element>) -> Bool)? = nil,
    receiveElement: ((Element) -> Bool)? = nil,
    receiveCompletion: ((Completion) -> Bool)? = nil
  ) -> Pipe {
    return Pipe(
      CallbagKit.breakpoint(
        receiveStart: receiveStart,
        receiveElement: receiveElement,
        receiveCompletion: receiveCompletion
      )(producer)
    )
  }

  func debug(
    _ message: @escaping @autoclosure () -> (String) = "",
    includeArrows: Bool = true
  ) -> Pipe {
    return Pipe(
      CallbagKit.debug(
        message(),
        includeArrows: includeArrows
      )(producer)
    )
  }

  func print(
    _ message: @escaping @autoclosure () -> (String) = "",
    includeArrows: Bool = true,
    to stream: Optional<TextOutputStream> = .none
  ) -> Pipe {
    return Pipe(
      CallbagKit.print(
        message(),
        includeArrows: includeArrows,
        to: stream
      )(producer)
    )
  }

  func tap(_ receive: @escaping (Sink<Element>) -> Void) -> Pipe {
    return Pipe(CallbagKit.tap(receive)(producer))
  }

  func tap(
    receiveStart: ((SourceTalkback<Element>) -> Void)? = nil,
    receiveElement: ((Element) -> Void)? = nil,
    receiveCompletion: ((Completion) -> Void)? = nil
  ) -> Pipe {
    return Pipe(
      CallbagKit.tap(
        receiveStart: receiveStart,
        receiveElement: receiveElement,
        receiveCompletion: receiveCompletion
      )(producer)
    )
  }
}

/// MARK: ErrorHandling

public extension Pipe {
  func assert(
    _ prefix: String = "",
    file: StaticString = #file,
    line: UInt = #line
  ) -> Pipe {
    return Pipe(
      CallbagKit.assert(
        prefix,
        file: file,
        line: line
      )(producer)
    )
  }

  func catchError(
    _ handler: @escaping (Error) throws -> Producer<Element>
  ) -> Pipe {
    return Pipe(CallbagKit.catchError(handler)(producer))
  }

  func mapError(
    _ handler: @escaping (Error) -> Error
  ) -> Pipe {
    return Pipe(CallbagKit.mapError(handler)(producer))
  }

  func retry(
    _ countOfRetries: Int
  ) -> Pipe {
    return Pipe(CallbagKit.retry(countOfRetries)(producer))
  }
}

/// MARK: Filtering

public extension Pipe where Element: Equatable {
  func distinct() -> Pipe {
    return Pipe(CallbagKit.distinct()(producer))
  }

  func distinctUntilChanged() -> Pipe {
    return Pipe(CallbagKit.distinctUntilChanged()(producer))
  }
}

public extension Pipe {
  func dropFirst(_ count: Int = 1) -> Pipe {
    return Pipe(CallbagKit.dropFirst(count)(producer))
  }

  func dropLast(_ count: Int = 1) -> Pipe {
    return Pipe(CallbagKit.dropLast(count)(producer))
  }

  func dropWhile(_ predicate: @escaping (Element) throws -> Bool) -> Pipe {
    return Pipe(CallbagKit.dropWhile(predicate)(producer))
  }

  func dropWhile<U>(_ notifier: @escaping Producer<U>) -> Pipe {
    return Pipe(CallbagKit.dropWhile(notifier)(producer))
  }

  func dropUntil<U>(_ notifier: @escaping Producer<U>) -> Pipe {
    return Pipe(CallbagKit.dropUntil(notifier)(producer))
  }

  func elementAt(_ index: Int) -> Pipe {
    return Pipe(CallbagKit.elementAt(index)(producer))
  }

  func filter(_ predicate: @escaping (Element) throws -> Bool) -> Pipe {
    return Pipe(CallbagKit.filter(predicate)(producer))
  }

  func first(_ count: Int = 1) -> Pipe {
    return Pipe(CallbagKit.take(count)(producer))
  }

  func first(
    _ count: Int = 1,
    _ predicate: @escaping (Element) throws -> Bool
  ) ->  Pipe {
    return Pipe(CallbagKit.take(count)(CallbagKit.filter(predicate)(producer)))
  }

  func last(_ count: Int = 1) -> Pipe {
    return Pipe(CallbagKit.takeLast(count)(producer))
  }

  func last(
    _ count: Int = 1,
    _ predicate: @escaping (Element) throws -> Bool
  ) ->  Pipe {
    return Pipe(CallbagKit.takeLast(count)(CallbagKit.filter(predicate)(producer)))
  }

  func ignoreElements() -> Pipe {
    return Pipe(CallbagKit.ignoreElements()(producer))
  }

  func reject(_ predicate: @escaping (Element) throws -> Bool) -> Pipe {
    return Pipe(CallbagKit.filter(not(predicate))(producer))
  }

  func skip(_ count: Int) -> Pipe {
    return Pipe(CallbagKit.dropFirst(count)(producer))
  }

  func skipLast(_ count: Int = 1) -> Pipe {
    return Pipe(CallbagKit.dropLast(count)(producer))
  }

  func skipWhile(_ predicate: @escaping (Element) throws -> Bool) -> Pipe {
    return Pipe(CallbagKit.dropWhile(predicate)(producer))
  }

  func skipWhile<U>(_ notifier: @escaping Producer<U>) -> Pipe {
    return Pipe(CallbagKit.dropWhile(notifier)(producer))
  }

  func skipUntil<U>(_ notifier: @escaping Producer<U>) -> Pipe {
    return Pipe(CallbagKit.dropUntil(notifier)(producer))
  }

  func take(_ count: Int) -> Pipe {
    return Pipe(CallbagKit.take(count)(producer))
  }

  func takeLast(_ count: Int = 1) -> Pipe {
    return Pipe(CallbagKit.takeLast(count)(producer))
  }

  func takeWhile(_ predicate: @escaping (Element) throws -> Bool) -> Pipe {
    return Pipe(CallbagKit.takeWhile(predicate)(producer))
  }

  func takeWhile<U>(_ notifier: @escaping Producer<U>) -> Pipe {
    return Pipe(CallbagKit.takeWhile(notifier)(producer))
  }

  func takeUntil<U>(_ notifier: @escaping Producer<U>) -> Pipe {
    return Pipe(CallbagKit.takeUntil(notifier)(producer))
  }
}

/// MARK: Matching

public extension Pipe {
  func allSatisfy(_ predicate: @escaping (Element) throws -> Bool) -> Pipe<Bool> {
    return Pipe<Bool>(CallbagKit.allSatisfy(predicate)(producer))
  }
}

public extension Pipe where Element: Equatable {
  func contains(_ predicateElement: Element) -> Pipe<Bool> {
    return Pipe<Bool>(CallbagKit.contains(predicateElement)(producer))
  }
}

public extension Pipe {
  func contains(_ predicate: @escaping (Element) throws -> Bool) -> Pipe<Bool> {
    return Pipe<Bool>(CallbagKit.contains(predicate)(producer))
  }
}

/// MARK: Mathematical

public extension Pipe where Element: BinaryInteger {
  func average() -> Pipe<Double> {
    return Pipe<Double>(CallbagKit.average()(producer))
  }
}

public extension Pipe where Element: BinaryFloatingPoint {
  func average() -> Pipe<Double> {
    return Pipe<Double>(CallbagKit.average()(producer))
  }
}

public extension Pipe {
  func count() -> Pipe<Int> {
    return Pipe<Int>(CallbagKit.count()(producer))
  }
}

public extension Pipe where Element: Comparable {
  func max() -> Pipe {
    return Pipe(CallbagKit.max()(producer))
  }
}

public extension Pipe {
  func max(by areInIncreasingOrder: @escaping (Element, Element) throws -> Bool) -> Pipe {
    return Pipe(CallbagKit.max(by: areInIncreasingOrder)(producer))
  }
}

public extension Pipe where Element: Comparable {
  func min() -> Pipe {
    return Pipe(CallbagKit.min()(producer))
  }
}

public extension Pipe {
  func min(by areInIncreasingOrder: @escaping (Element, Element) throws -> Bool) -> Pipe {
    return Pipe(CallbagKit.min(by: areInIncreasingOrder)(producer))
  }
}

public extension Pipe where Element: BinaryInteger {
  func sum() -> Pipe {
    return Pipe(CallbagKit.reduce(0, +)(producer))
  }
}

public extension Pipe where Element: BinaryFloatingPoint {
  func sum() -> Pipe {
    return Pipe(CallbagKit.reduce(0, +)(producer))
  }
}

/// MARK: Threading

public extension Pipe {
  func async(on queue: DispatchQueue = DispatchQueue(label: DOMAIN("async"))) -> Pipe {
    return Pipe(CallbagKit.async(on: queue)(producer))
  }

  func blockingMain() -> Pipe {
    return Pipe(CallbagKit.blockingMain()(producer))
  }

  func blocking() -> Pipe {
    return Pipe(CallbagKit.blocking()(producer))
  }

  func sync() -> Pipe {
    return Pipe(CallbagKit.sync()(producer))
  }
}

/// MARK: Timing

public extension Pipe where Element: Equatable {
  func debounce(
    _ duration: DispatchTimeInterval,
    on queue: DispatchQueue = DispatchQueue(label: DOMAIN("debounce"))
  ) -> Pipe {
    return Pipe(CallbagKit.debounce(duration, on: queue)(producer))
  }
}

public extension Pipe {
  func delay(
    _ duration: DispatchTimeInterval,
    on queue: DispatchQueue = DispatchQueue(label: DOMAIN("delay"))
  ) -> Pipe {
    return Pipe(CallbagKit.delay(duration, on: queue)(producer))
  }

  func durations() -> Pipe<(Double, Element)> {
    return Pipe<(Double, Element)>(CallbagKit.durations()(producer))
  }

  func throttle(
    _ duration: DispatchTimeInterval,
    on queue: DispatchQueue = DispatchQueue(label: DOMAIN("throttle")),
    strategy: ThrottleStrategy = .latest
  ) -> Pipe {
    return Pipe(CallbagKit.throttle(duration, on: queue, strategy: strategy)(producer))
  }

  func timeout(
    _ duration: DispatchTimeInterval,
    on queue: DispatchQueue = DispatchQueue(label: DOMAIN("timeout")),
    customError: Error? = nil
  ) -> Pipe {
    return Pipe(CallbagKit.timeout(duration, on: queue, customError: customError)(producer))
  }

  func timestamps() -> Pipe<(Double, Element)> {
    return Pipe<(Double, Element)>(CallbagKit.timestamps()(producer))
  }

  func wait(
    _ duration: DispatchTimeInterval,
    on queue: DispatchQueue = DispatchQueue(label: DOMAIN("wait"))
  ) -> Pipe {
    return Pipe(CallbagKit.wait(duration, on: queue)(producer))
  }
}

/// MARK: Transforming

public extension Pipe {
  func buffer(_ count: Int) -> Pipe<Array<Element>> {
    return Pipe<Array<Element>>(CallbagKit.buffer(count)(producer))
  }

  func buffer(
    _ duration: DispatchTimeInterval,
    on queue: DispatchQueue = DispatchQueue(label: DOMAIN("buffer"))
  ) -> Pipe<Array<Element>> {
    return Pipe<Array<Element>>(CallbagKit.buffer(duration, on: queue)(producer))
  }

  func buffer<U>(_ notifier: @escaping Producer<U>) -> Pipe<Array<Element>> {
    return Pipe<Array<Element>>(CallbagKit.buffer(notifier)(producer))
  }
}

public extension Pipe where Element: Encodable {
  func encode<Coder: TopLevelEncoder, Encoded>(encoder: Coder) -> Pipe<Encoded>  where Coder.Output == Encoded {
    return Pipe<Encoded>(CallbagKit.map(encoder.encode)(producer))
  }
}

public extension Pipe where Element == Data {
  func decode<Coder: TopLevelDecoder, Decoded: Decodable>(
    type: Decoded.Type,
    decoder: Coder
  ) -> Pipe<Decoded> where Coder.Input == Data {
    return Pipe<Decoded>(CallbagKit.map({ try decoder.decode(type, from: $0) })(producer))
  }
}

public extension Pipe {
  func collect() -> Pipe<Array<Element>> {
    return Pipe<Array<Element>>(CallbagKit.reduce([], { $0 + [$1]})(producer))
  }

  func collect(_ count: Int) -> Pipe<Array<Element>> {
    return Pipe<Array<Element>>(CallbagKit.take(1)(CallbagKit.buffer(count)(producer)))
  }
}

public extension Pipe {
  func compact<R: OptionalProtocol>(
    _ transform: @escaping (Element) throws -> R
  ) -> Pipe<R.Wrapped> {
    return Pipe<R.Wrapped>(CallbagKit.compact(transform)(producer))
  }
}

public extension Pipe where Element: OptionalProtocol {
  func compact() -> Pipe<Element.Wrapped> {
    return Pipe<Element.Wrapped>(CallbagKit.compact()(producer))
  }
}

public extension Pipe where Element == Character {
  func components(
    maxSplits: Int = .max,
    omittingEmptySequence: Bool = true,
    _ predicate: @escaping (Character) throws -> (Bool)
  ) -> Pipe<String> {
    return Pipe<String>(
      CallbagKit.flatMap({
        CallbagKit.reduce("", +)(CallbagKit.map(String.init)(from($0)))
      })(CallbagKit.split(maxSplits: maxSplits, omittingEmptySequence: omittingEmptySequence, predicate)(producer))
    )
  }

  func components(
    _ separators: Character ...,
    maxSplits: Int = .max,
    omittingEmptySequence: Bool = true
  ) -> Pipe<String> {
    return Pipe<String>(
      CallbagKit.flatMap({
        CallbagKit.reduce("", +)(CallbagKit.map(String.init)(from($0)))
      })(CallbagKit.split(maxSplits: maxSplits, omittingEmptySequence: omittingEmptySequence, separators.contains)(producer))
    )
  }

  func components(
    _ separators: String,
    maxSplits: Int = .max,
    omittingEmptySequence: Bool = true
  ) -> Pipe<String> {
    return Pipe<String>(
      CallbagKit.flatMap({
        CallbagKit.reduce("", +)(CallbagKit.map(String.init)(from($0)))
      })(CallbagKit.split(maxSplits: maxSplits, omittingEmptySequence: omittingEmptySequence, separators.contains)(producer))
    )
  }
}

public extension Pipe {
  func materialize() -> Pipe<Sink<Element>> {
    return Pipe<Sink<Element>>(
      CallbagKit.materialize()(producer)
    )
  }

  func dematerialize<T>() -> Pipe<T> where Element == Sink<T> {
    return Pipe<T>(
      CallbagKit.dematerialize()(producer)
    )
  }

  func flatMap<R>(_ transform: @escaping (Element) throws -> Producer<R>) -> Pipe<R> {
    return Pipe<R>(
      CallbagKit.flatMap(transform)(producer)
    )
  }

  func flatten<R>(_ strategy: FlattenStrategy) -> Pipe<R> where Element == Producer<R> {
    return Pipe<R>(
      CallbagKit.flatten(strategy)(producer)
    )
  }

  func group<Key: Hashable>(_ predicate: @escaping (Element) throws -> Key) -> Pipe<(key: Key, source: Producer<Element>)> {
    return Pipe<(key: Key, source: Producer<Element>)>(
      CallbagKit.group(predicate)(producer)
    )
  }

  func indices() -> Pipe<(Int, Element)> {
    return Pipe<(Int, Element)>(
      CallbagKit.indices()(producer)
    )
  }

  func joined(_ separator: Element) -> Pipe {
    return Pipe(
      CallbagKit.joined(separator)(producer)
    )
  }

  func loop<R, U>(
    _ initialResult: R,
    _ nextNewResult: @escaping (R, Element) throws -> (R, U)
  ) -> Pipe<U> {
    return Pipe<U>(
      CallbagKit.loop(initialResult, nextNewResult)(producer)
    )
  }

  func map<R>(
    _ transform: @escaping (Element) throws -> R
  ) -> Pipe<R> {
    return Pipe<R>(CallbagKit.map(transform)(producer))
  }

  func map<T>(
    _ keyPath: KeyPath<Element, T>
  ) -> Pipe<T> {
    return Pipe<T>(CallbagKit.map({ root in
      root[keyPath: keyPath]
    })(producer))
  }

  func map<T0, T1>(
    _ keyPath0: KeyPath<Element, T0>,
    _ keyPath1: KeyPath<Element, T1>
  ) -> Pipe<(T0, T1)> {
    return Pipe<(T0, T1)>(CallbagKit.map({ root in
      (
        root[keyPath: keyPath0],
        root[keyPath: keyPath1]
      )
    })(producer))
  }

  func map<T0, T1, T2>(
    _ keyPath0: KeyPath<Element, T0>,
    _ keyPath1: KeyPath<Element, T1>,
    _ keyPath2: KeyPath<Element, T2>
  ) -> Pipe<(T0, T1, T2)> {
    return Pipe<(T0, T1, T2)>(CallbagKit.map({ root in
      (
        root[keyPath: keyPath0],
        root[keyPath: keyPath1],
        root[keyPath: keyPath2]
      )
    })(producer))
  }

  func map<T0, T1, T2, T3>(
    _ keyPath0: KeyPath<Element, T0>,
    _ keyPath1: KeyPath<Element, T1>,
    _ keyPath2: KeyPath<Element, T2>,
    _ keyPath3: KeyPath<Element, T3>
  ) -> Pipe<(T0, T1, T2, T3)> {
    return Pipe<(T0, T1, T2, T3)>(CallbagKit.map({ root in
      (
        root[keyPath: keyPath0],
        root[keyPath: keyPath1],
        root[keyPath: keyPath2],
        root[keyPath: keyPath3]
      )
    })(producer))
  }

  func partition(_ predicate: @escaping (Element) throws -> Bool) -> Pipe<Producer<Element>> {
    return Pipe<Producer<Element>>(
      CallbagKit.map({ $0.source })(CallbagKit.group(predicate)(producer))
    )
  }

  func pluck<Key: Hashable, Value>(_ byKey: Key) -> Pipe<Value> where Element == Dictionary<Key, Value> {
    return Pipe<Value>(
      CallbagKit.compact({ $0[byKey] })(producer)
    )
  }

  func pluck<Key: Equatable, Value>(_ byKey: Key) -> Pipe<Value> where Element == KeyValuePairs<Key, Value> {
    return Pipe<Value>(
      CallbagKit.compact({ element in
        element.first(
          where: { pair in
            pair.key == byKey
          }
        )?.value
      })(producer)
    )
  }

  func pluck<Key: Equatable, Value>(_ byKey: Key) -> Pipe<Value> where Element == Array<(Key, Value)> {
    return Pipe<Value>(
      CallbagKit.compact({ element in
        element.first(
          where: { pair in
            pair.0 == byKey
          }
        )?.1
      })(producer)
    )
  }

  func pluck<Key: Equatable, Value>(_ byKey: Key) -> Pipe<Value> where Element == (Key, Value) {
    return Pipe<Value>(
      CallbagKit.compact({ pair in
        pair.0 == byKey ? pair.1 : nil
      })(producer)
    )
  }

  func pluck<Value>(_ keyPath: KeyPath<Element, Value>) -> Pipe<Value> {
    return Pipe<Value>(
      CallbagKit.map({ root in
        root[keyPath: keyPath]
      })(producer)
    )
  }

  func reduce<R>(
    _ initialResult: R,
    _ nextNewResult: @escaping (R, Element) throws -> R
  ) -> Pipe<R> {
    return Pipe<R>(
      CallbagKit.reduce(initialResult, nextNewResult)(producer)
    )
  }

  func repeats(
    _ countOfRetries: Int
  ) -> Pipe {
    return Pipe(CallbagKit.repeats(countOfRetries)(producer))
  }

  func repeats() -> Pipe {
    return Pipe(CallbagKit.repeats()(producer))
  }
}

public extension Pipe where Element: OptionalProtocol {
  func replaceNil(with nonNilElement: Element.Wrapped) -> Pipe<Element.Wrapped> {
    return Pipe<Element.Wrapped>(
      CallbagKit.replaceNil(with: nonNilElement)(producer)
    )
  }
}

public extension Pipe {
  func replaceEmpty(with element: Element) -> Pipe {
    return Pipe(
      CallbagKit.replaceEmpty(with: element)(producer)
    )
  }

  func replaceFirst(_ count: Int = 1, with element: Element) -> Pipe {
    return Pipe(
      CallbagKit.replaceFirst(count, with: element)(producer)
    )
  }

  func replaceLast(_ count: Int = 1, with element: Element) -> Pipe {
    return Pipe(
      CallbagKit.replaceLast(count, with: element)(producer)
    )
  }

  func replaceAll(with element: Element) -> Pipe {
    return Pipe(
      CallbagKit.map({ _ in element })(producer)
    )
  }
}

public extension Pipe where Element: Equatable {
  func replaceAll(_ elements: Element ..., with element: Element) -> Pipe {
    return Pipe(
      CallbagKit.map({ elements.contains($0) ? element : $0 })(producer)
    )
  }

  func replaceAll<S: Sequence>(_ elements: S, with element: Element) -> Pipe where Element == S.Element {
    return Pipe(
      CallbagKit.map({ elements.contains($0) ? element : $0 })(producer)
    )
  }
}

public extension Pipe {
  func scan(
    _ nextNewResult: @escaping (Element, Element) throws -> Element
  ) -> Pipe {
    return Pipe(
      CallbagKit.scan(nextNewResult)(producer)
    )
  }

  func scan<R>(
    _ initialResult: R,
    _ nextNewResult: @escaping (R, Element) throws -> R
  ) -> Pipe<R> {
    return Pipe<R>(
      CallbagKit.scan(initialResult, nextNewResult)(producer)
    )
  }
}

public extension Pipe {
  func split(
    maxSplits: Int = .max,
    omittingEmptySequence: Bool = true,
    _ predicate: @escaping (Element) throws -> (Bool)
  ) -> Pipe<Array<Element>> {
    return Pipe<Array<Element>>(
      CallbagKit.split(maxSplits: maxSplits, omittingEmptySequence: omittingEmptySequence, predicate)(producer)
    )
  }
}

public extension Pipe where Element: Equatable {
  func split(
    _ separators: Element ...,
    maxSplits: Int = .max,
    omittingEmptySequence: Bool = true
  ) -> Pipe<Array<Element>> {
    return Pipe<Array<Element>>(
      CallbagKit.split(maxSplits: maxSplits, omittingEmptySequence: omittingEmptySequence, separators.contains)(producer)
    )
  }

  func split<S: Sequence>(
    _ separators: S,
    maxSplits: Int = .max,
    omittingEmptySequence: Bool = true
  ) -> Pipe<Array<Element>> where Element == S.Element {
    return Pipe<Array<Element>>(
      CallbagKit.split(maxSplits: maxSplits, omittingEmptySequence: omittingEmptySequence, separators.contains)(producer)
    )
  }
}