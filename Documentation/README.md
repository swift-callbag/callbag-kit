#### [CallbagKit][Callbag]
<h1> Documentation </h1>

- [Sources](#sources)
- [Sinkers](#sinkers)
- [Operators](#operators)
- [Pipes](#pipes)

<hr align="center" style="background-color: #393939; height: 2px">

**Callbags** has three major layers.

> 1. #### Producer Layer *[Sources][Sources]*:
> This layer is responsible for sending data.
> 
> 2. #### Operator Layer *[Operators][Operators]*:
> This layer is responsible for receiving data and do some operation,
> then sending data. So this layer is considered as producer layer too.
> The only difference is that it cannot send data without receiving them first.
> 
> 3. #### Consumer Layer *[Sinkers][Sinkers]*:
> This layer is responsible for receiving data.

**Visually represented as:**
```
     required          optional         required
 ╭──────────────╮   ╭────────────╮   ╭────────────╮
 │              │<──│            │<──│            │
 │   Producer   │   │  Operator  │   │  Consumer  │
 │              │──>│            │──>│            │
 ╰──────────────╯   ╰────────────╯   ╰────────────╯
```

*Note:* each **Callbags** Layer has its own Architecture Design.
However they share the following concept:

> 1. *Subscribe* Stage:
> ```
>   ╭────────────────────────╮  
>   │ ╭────────────────────╮ │  
> <─┼─│    request Start   │<┼── Handshake (required)
>   │ ╰────────────────────╯ │  
>   │       Only once        │  
>   │ ╭────────────────────╮ │  
> ──┼>│    receive Start   ├─┼─> HandshakeBack (required)
>   │ ╰────────────────────╯ │  
>   ╰────────────────────────╯  
> ```
>
> 2. *Request/Receive Items* Stage:
> ```
>   ╭────────────────────────╮  
>   │ ╭────────────────────╮ │  
> <─┼─│    request Next    │<┼── WantItem (required for pullables)
>   │ ╰────────────────────╯ │  
>   │   As many as possible  │  
>   │ ╭────────────────────╮ │  
> ──┼>│    receive Next    ├─┼─> TakeItem (optional)
>   │ ╰────────────────────╯ │  
>   ╰────────────────────────╯  
> ```
>
> 3. *Unsubscribe* Stage:
> ```
>   ╭────────────────────────╮  
>   │ ╭────────────────────╮ │  
> <─┼─│ request Completion │<┼── Bye (optional)
>   │ ╰────────────────────╯ │  
>   │       Only once        │  
>   │ ╭────────────────────╮ │  
> ──┼>│ receive Completion ├─┼─> Bye/ByeBack (required)
>   │ ╰────────────────────╯ │  
>   ╰────────────────────────╯  
> ```

<hr align="center" style="background-color: #393939; height: 2px">

- ### *[Sources][Sources]*
  1. [**Creating**](./Sources/Creating/README.md)
     1. [Empty](./Sources/Creating/Empty.md)
     2. [Never](./Sources/Creating/Never.md)
     3. [ThrowError](./Sources/Creating/ThrowError.md)
     4. [From](./Sources/Creating/From.md)
     5. [Of](./Sources/Creating/Of.md)
     6. [Just](./Sources/Creating/Just.md)
     7. [Interval](./Sources/Creating/Interval.md)
     8. [Timer](./Sources/Creating/Timer.md)
  2. [**Multicasting**](./Sources/Multicasting/README.md)
     1. [Share](./Sources/Multicasting/Share.md)
     2. [PublishSubject](./Sources/Multicasting/PublishSubject.md)
     3. [AsyncSubject](./Sources/Multicasting/AsyncSubject.md)
     4. [BehaviorSubject](./Sources/Multicasting/BehaviorSubject.md)
     5. [ReplaySubject](./Sources/Multicasting/ReplaySubject.md)
  3. [**Others**](./Sources/Others/README.md)
     1. [Pullable](./Sources/Others/Pullable.md)
     2.  [Iteratable](./Sources/Others/Iteratable.md)
   
<hr align="center" style="background-color: #393939; height: 2px">

- ### *[Sinkers][Sinkers]*
  1. [Assign](./Sinkers/Assign.md)
  2. [Await](./Sinkers/Await.md)
  3. [ForEach](./Sinkers/ForEach.md)
  4. [Sink](./Sinkers/Sink.md)
  5. [Observe](./Sinkers/Observe.md)

<hr align="center" style="background-color: #393939; height: 2px">

- ### *[Operators][Operators]*
  1. [**Combining**](./Operators/Combining/README.md)
     1. [Combine](./Operators/Combining/Combine.md)
     2. [Concat](./Operators/Combining/Concat.md)
     3. [Merge](./Operators/Combining/Merge.md)
     4. [Race](./Operators/Combining/Race.md)
     5. [SwitchLatest](./Operators/Combining/SwitchLatest.md)
     6. [Zip](./Operators/Combining/Zip.md)
  2. [**Debugging**](./Operators/Debugging/README.md)
     1. [Breakpoint](./Operators/Debugging/Breakpoint.md)
     2. [Debug](./Operators/Debugging/Debug.md)
     3. [Print](./Operators/Debugging/Print.md)
     4.  [Tap](./Operators/Debugging/Tap.md)
  3. [**ErrorHandling**](./Operators/ErrorHandling/README.md)
     1.  [Assert](./Operators/ErrorHandling/Assert.md)
     2.  [CatchError](./Operators/ErrorHandling/CatchError.md)
     3.  [MapError](./Operators/ErrorHandling/MapError.md)
     4.  [Retry](./Operators/ErrorHandling/Retry.md)
  4.  [**Filtering**](./Operators/Filtering/README.md)
      1.  [Distinct](./Operators/Filtering/Distinct.md)
      2.  [Filter](./Operators/Filtering/Filter.md)
      3.  [Reject](./Operators/Filtering/Reject.md)
      4.  [IgnoreElements](./Operators/Filtering/IgnoreElements.md)
      5.  [First](./Operators/Filtering/First.md)
      6.  [Last](./Operators/Filtering/Last.md)
      7.  [Drop](./Operators/Filtering/Drop.md)
      8.  [Skip](./Operators/Filtering/Skip.md)
      9.  [Take](./Operators/Filtering/Take.md)
  5.  [**Matching**](./Operators/Matching/README.md)
      1.  [AllSatisfy](./Operators/Matching/AllSatisfy.md)
      2.  [Contains](./Operators/Matching/Contains.md)
  6.  [**Mathematical**](./Operators/Mathematical/README.md)
      1.  [Average](./Operators/Mathematical/Average.md)
      2.  [Count](./Operators/Mathematical/Count.md)
      3.  [Max](./Operators/Mathematical/Max.md)
      4.  [Min](./Operators/Mathematical/Min.md)
      5.  [Sum](./Operators/Mathematical/Sum.md)
  7.  [**Threading**](./Operators/Threading/README.md)
      1.  [Async](./Operators/Threading/Async.md)
      2.  [Sync](./Operators/Threading/Sync.md)
      3.  [Blocking](./Operators/Threading/Blocking.md)
  8.  [**Timing**](./Operators/Timing/README.md)
      1.  [Debounce](./Operators/Timing/Debounce.md)
      2.  [Throttle](./Operators/Timing/Throttle.md)
      3.  [Durations](./Operators/Timing/Durations.md)
      4.  [Timestamps](./Operators/Timing/Timestamps.md)
      5.  [Timeout](./Operators/Timing/Timeout.md)
      6.  [Delay](./Operators/Timing/Delay.md)
      7.  [Wait](./Operators/Timing/Wait.md)
  9.  [**Transforming**](./Operators/Transforming/README.md)
      1.  [Indices](./Operators/Transforming/Indices.md)
      2.  [Buffer](./Operators/Transforming/Buffer.md)
      3.  [Collect](./Operators/Transforming/Collect.md)
      4.  [Codable](./Operators/Transforming/Codable.md)
      5.  [Components](./Operators/Transforming/Components.md)
      6.  [Split](./Operators/Transforming/Split.md)
      7.  [Joined](./Operators/Transforming/Joined.md)
      8.  [De-Materialize](./Operators/Transforming/De-Materialize.md)
      9.  [Map](./Operators/Transforming/Map.md)
      10. [Compact](./Operators/Transforming/Compact.md)
      11. [FlatMap](./Operators/Transforming/FlatMap.md)
      12. [Pluck](./Operators/Transforming/Pluck.md)
      13. [Group](./Operators/Transforming/Group.md)
      14. [Partition](./Operators/Transforming/Partition.md)
      15. [Reduce](./Operators/Transforming/Reduce.md)
      16. [Loop](./Operators/Transforming/Loop.md)
      17. [Scan](./Operators/Transforming/Scan.md)
      18. [Repeats](./Operators/Transforming/Repeats.md)
      19. [Replace](./Operators/Transforming/Replace.md)

<hr align="center" style="background-color: #393939; height: 2px">

- ### *[Pipes][Pipes]*

[Callbag]: <../README.md> (Callbag)

[Pipes]: <./Pipes/README.md> (Pipes)
[Sources]: <./Sources/README.md> (Sources)
[Sinkers]: <./Sinkers/README.md> (Sinkers)
[Operators]: <./Operators/README.md> (Operators)