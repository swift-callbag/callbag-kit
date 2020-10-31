#### [CallbagKit][Callbag] › [Documentation][Documentation] › [Operators][Operators]
# Transforming

> [Operators][Operators] that transform items that are emitted by a source.

- [**Indices**][Indices]: emit items with their indices from a source.

- [**Buffer**][Buffer]: gather emitted items from a source by count or time factor,
  and emit these gathered items as an array.

- [**Collect**][Collect]: gather emitted items from a source upto a certain count,
  and emit these gathered items as an array.

- [**Codable**][Codable]: `encode` / `decode` data to a certain `Encodable` / `Decodable` type.

- [**Components**][Components]: splits the emitted characters by a separator and
  emit these splitted characters as string.

- [**Split**][Split]: splits the emitted values by a separator and
  emit these splitted values as array.

- [**Joined**][Joined]: emit a given item between emitted items from source.

- [**De-Materialize**][De-Materialize]: represent both the items emitted and the completion sent
  as emitted items, or reverse this process.

- [**Map**][Map]: applies a transformation on items passing through it.

- [**Compact**][Compact]: transform emitted items, and discard emitting `nil` items.

- [**FlatMap**][FlatMap]: transform the items emitted by a source into sources,
  then flatten the emissions from those into a single source.

- [**Pluck**][Pluck]: map to `object` / `dictionary` properties.

- [**Group**][Group]: divide a source into a set of sources that each emit a
  different subset of items from the original source.

- [**Partition**][Partition]: that splits the source into two, one with values
  that satisfy a predicate, and another with values that don't satisfy the predicate.

- [**Reduce**][Reduce]: combine consecutive values into one value from the same source.

- [**Loop**][Loop]: accumulates results using a feedback loop that emits one
  value and feeds back another to be used in the next iteration.

- [**Scan**][Scan]: combines consecutive values from the same source. It's
  essentially like array `.reduce`, but delivers a new accumulated value for
  each value from the callbag source.

- [**Repeats**][Repeats]: repeats/restarts the source stream by repeating the
  source handshake when source stream finished without error.

- [**Replace**][Replace]: replaces values with another ones in variate ways.


[Callbag]: <../../../README.md> (Callbag)
[Documentation]: <../../README.md> (Documentation)
[Operators]: <../README.md> (Operators)

[Sources]: <../../Sources/README.md> (Sources)

[Indices]: <./Indices.md> (Indices)

[Buffer]: <./Buffer.md> (Buffer)
[Collect]: <./Collect.md> (Collect)

[Codable]: <./Codable.md> (Codable)

[Components]: <./Components.md> (Components)
[Split]: <./Split.md> (Split)
[Joined]: <./Joined.md> (Joined)

[De-Materialize]: <./De-Materialize.md> (De-Materialize)

[Map]: <./Map.md> (Map)
[Compact]: <./Compact.md> (Compact)
[FlatMap]: <./FlatMap.md> (FlatMap)
[Pluck]: <./Pluck.md> (Pluck)

[Group]: <./Group.md> (Group)
[Partition]: <./Partition.md> (Partition )

[Reduce]: <./Reduce.md> (Reduce)
[Loop]: <./Loop.md> (Loop)
[Scan]: <./Scan.md> (Scan)

[Repeats]: <./Repeats.md> (Repeats)

[Replace]: <./Replace.md> (Replace)