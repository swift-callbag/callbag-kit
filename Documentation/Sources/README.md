#### [CallbagKit][Callbag] › [Documentation][Documentation]
# Sources

> In **Callbag**Kit a sinker subscribes to a source. Then that sinker reacts to
> whatever item or sequence of items the sources emits.
>
> There are three types of sources in general.
> 1. **Listenable** source which will emit items whenever there is an item
> available to be emitted.
> 
> 2. **Pullable** source emit items only upon request from sinker, an item per
> request.
> 
> 3. **Single** source is actually a **Listenable** source, but will only emit
> one item whenever it is available to be emitted.

1. [**Creating**](./Creating/README.md)
   1. [Empty](./Creating/Empty.md)
   2. [Never](./Creating/Never.md)
   3. [ThrowError](./Creating/ThrowError.md)
   4. [From](./Creating/From.md)
   5. [Of](./Creating/Of.md)
   6. [Just](./Creating/Just.md)
   7. [Interval](./Creating/Interval.md)
   8. [Timer](./Creating/Timer.md)
2. [**Multicasting**](./Multicasting/README.md)
   1. [Share](./Multicasting/Share.md)
   2. [PublishSubject](./Multicasting/PublishSubject.md)
   3. [AsyncSubject](./Multicasting/AsyncSubject.md)
   4. [BehaviorSubject](./Multicasting/BehaviorSubject.md)
   5. [ReplaySubject](./Multicasting/ReplaySubject.md)
3. [**Others**](./Others/README.md)
   1. [Pullable](./Others/Pullable.md)
   2.  [Iteratable](./Others/Iteratable.md)
  
[Callbag]: <../../README.md> (Callbag)
[Documentation]: <../README.md> (Documentation)