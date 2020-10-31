#### [CallbagKit][Callbag] › [Documentation][Documentation] › [Sinkers][Sinkers]
# Assign
> A Callbag sinker that will assign the latest next event value to a `Class` or
> `Struct`. And it returns a `Cancellable`.

**Examples**

assign to variable in class:

```swift
class MyClass {
  var element: Int = 0
}

var myClass = MyClass()

_ = just(1)
  |> assign(to: \.element, on: myClass)

print(myClass.element) // 1
```

assign to variable in struct:

```swift
struct MyStruct {
  var element: Int = 0
}

var myStruct = MyStruct()

_ = just(1)
  |> assign(to: \.element, on: &myStruct)

print(myStruct.element)
```

assign to struct/class:

```swift
var element: Int = 0

_ = just(1)
  |> assign(to: &element)

print(element)
```

[Callbag]: <../../README.md> (Callbag)
[Documentation]: <../README.md> (Documentation)
[Sinkers]: <./README.md> (Sinkers)