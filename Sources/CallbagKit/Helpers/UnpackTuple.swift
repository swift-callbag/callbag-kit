internal func unpackTuple<A, B, C>(_ z: ((A, B), C)) -> (A, B, C) {
  return (z.0.0, z.0.1, z.1)
}

internal func unpackTuple<A, B, C, D>(_ z: (((A, B), C), D)) -> (A, B, C, D) {
  return (z.0.0.0, z.0.0.1, z.0.1, z.1)
}

internal func unpackTuple<A, B, C, D, E>(_ z: ((((A, B), C), D), E)) -> (A, B, C, D, E) {
  return (z.0.0.0.0, z.0.0.0.1, z.0.0.1, z.0.1, z.1)
}

internal func unpackTuple<A, B, C, D, E, F>(_ z: (((((A, B), C), D), E), F)) -> (A, B, C, D, E, F) {
  return (z.0.0.0.0.0, z.0.0.0.0.1, z.0.0.0.1, z.0.0.1, z.0.1, z.1)
}