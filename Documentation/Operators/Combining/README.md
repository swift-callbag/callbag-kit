#### [CallbagKit][Callbag] › [Documentation][Documentation] › [Operators][Operators]
# Combining

> [Factories][Sources] / [Operators][Operators] that work with multiple sources
> to create a single source.

- [**Combine**][Combine]: when an value is emitted by either of two sources,
  combine the latest value emitted by each source and emit values.

- [**Concat**][Concat]: emit the emissions from two or more sources without
  interleaving them.

- [**Merge**][Merge]: combine multiple sources into one by merging their emissions.

- [**Race**][Race]: given two or more source sources, emit all of the values from
  only the first of these sources to emit an value.

- [**SwitchLatest**][SwitchLatest]: convert a source that emits sources into a
  single source that emits the values emitted by the most-recently-emitted of
  those sources.

- [**Zip**][Zip]: combine the emissions of multiple sources together and emit
  single values for each combination.

[Callbag]: <../../../README.md> (Callbag)
[Documentation]: <../../README.md> (Documentation)
[Operators]: <../README.md> (Operators)

[Sources]: <../../Sources/README.md> (Sources)

[Combine]: <./Combine.md> (Combine)
[Concat]: <./Concat.md> (Concat)
[Merge]: <./Merge.md> (Merge)
[Race]: <./Race.md> (Race)
[SwitchLatest]: <./SwitchLatest.md> (SwitchLatest)
[Zip]: <./Zip.md> (Zip)