#### [CallbagKit][Callbag] › [Documentation][Documentation] › [Sources][Sources]
# Multicasting

> Specialty [Sources][Sources] that have more precisely-controlled subscription dynamics

- [**Share**][Share]: convert an ordinary source into a connectable source.

- [**PublishSubject**][PublishSubject]: A callbag listener sink which is also a
  listenable source, and maintains an internal list of listeners.

- [**AsyncSubject**][AsyncSubject]: a publish subject that will wait it receives
  a completion then emit the last value upon connection. If completion was failure
  it will emitted without emitting the previous value.

- [**BehaviorSubject**][BehaviorSubject]: a publish subject that will remember
  the last emission and emitted upon connection.

- [**ReplaySubject**][ReplaySubject]: a publish subject that will remember
  all previous emissions and emitted them upon connection.

[Callbag]: <../../../README.md> (Callbag)
[Documentation]: <../../README.md> (Documentation)
[Sources]: <../README.md> (Sources)

[Share]: <./Share.md> (Share)
[PublishSubject]: <./PublishSubject.md> (PublishSubject)
[AsyncSubject]: <./AsyncSubject.md> (AsyncSubject)
[BehaviorSubject]: <./BehaviorSubject.md> (BehaviorSubject)
[ReplaySubject]: <./ReplaySubject.md> (ReplaySubject)