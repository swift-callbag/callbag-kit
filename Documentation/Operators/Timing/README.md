#### [CallbagKit][Callbag] › [Documentation][Documentation] › [Operators][Operators]
# Timing

> [Operators][Operators] that helps to control sources with time-aspect.

- [**Debounce**][Debounce]: only emit an item from a source if a particular timespan has passed without it emitting another item.

- [**Throttle**][Throttle]: only emit either the first or last item from a source each timespan.

- [**Durations**][Durations]: convert a source that emits items into one that emits indications of the amount of time elapsed between those emissions.

- [**Timestamps**][Timestamps]: attach a timestamp to each item emitted by a source.

- [**Timeout**][Timeout]: mirror the source, but issue an error notification if a particular period of time elapses without any emitted items.

- [**Delay**][Delay]: shift the start of emissions from a source forward in time by a particular amount.

- [**Wait**][Wait]: shift each emission from a source forward in time by a particular amount.

[Callbag]: <../../../README.md> (Callbag)
[Documentation]: <../../README.md> (Documentation)
[Operators]: <../README.md> (Operators)

[Sources]: <../../Sources/README.md> (Sources)

[Debounce]: <./Debounce.md> (Debounce)
[Throttle]: <./Throttle.md> (Throttle)
[Durations]: <./Durations.md> (Durations)
[Timestamps]: <./Timestamps.md> (Timestamps)
[Timeout]: <./Timeout.md> (Timeout)
[Delay]: <./Delay.md> (Delay)
[Wait]: <./Wait.md> (Wait)