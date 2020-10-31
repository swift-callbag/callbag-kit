#### [CallbagKit][Callbag] › [Documentation][Documentation]
# Pipes

> Pipes are a readable, understandable and nice looking way to chain `Callbags`
> together. And to interact with Callbag's [Sources][Sources], [Operators][Operators],
> and [Sinkers][Sinkers], there are three different ways to do so are listed below.

**Examples**

Without Pipes:

```swift
  _ = forEach(print)(
    filter({ $0 % 2 == 0 })(
      from(1...10)
    )
  )
```

With Pipes:

## Method 1: as a `swift function`

```swift
  _ = pipe(
    from(1...10),
    filter { $0 % 2 == 0 },
    forEach(print)
  )
```

OR

```swift
  myPipe = pipe(
    filter { $0 % 2 == 0 },
    forEach(print)
  )

  _ = myPipe(from(1...10))
  // or
  _ = pipe(
    from(1...10),
    myPipe
  )
```

## Method 2: as a `swift operator`

```swift
  _ = from(1...10)
    |> filter { $0 % 2 == 0 }
    |> forEach(print)
```

OR

```swift
  myPipe = filter { $0 % 2 == 0 }
         |> forEach(print)

  _ = from(1...10) |> myPipe
  // or
  _ = from(1...10)
    |> myPipe
```

## Method 3: as a `swift struct`

```swift
  _ = Pipe(from(1...10))
        .filter { $0 % 2 == 0 }
        .forEach(print)
```

[Callbag]: <../../README.md> (Callbag)
[Documentation]: <../README.md> (Documentation)

[Sources]: <../Sources/README.md> (Sources)
[Operators]: <../Operators/README.md> (Operators)
[Sinkers]: <../Sinkers/README.md> (Sinkers)