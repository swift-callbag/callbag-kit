public func components(
  maxSplits: Int = .max,
  omittingEmptySequence: Bool = true,
  _ predicate: @escaping (Character) throws -> (Bool)
) ->  Operator<Character, String> {
  return { source in
    return flatMap({
      reduce("", +)(map(String.init)(from($0)))
    })(split(maxSplits: maxSplits, omittingEmptySequence: omittingEmptySequence, predicate)(source))
  }
}

public func components(
  _ separators: Character ...,
  maxSplits: Int = .max,
  omittingEmptySequence: Bool = true
) ->  Operator<Character, String> {
  return { source in
    return flatMap({
      reduce("", +)(map(String.init)(from($0)))
    })(split(maxSplits: maxSplits, omittingEmptySequence: omittingEmptySequence, separators.contains)(source))
  }
}

public func components(
  _ separators: String,
  maxSplits: Int = .max,
  omittingEmptySequence: Bool = true
) ->  Operator<Character, String> {
  return { source in
    return flatMap({
      reduce("", +)(map(String.init)(from($0)))
    })(split(maxSplits: maxSplits, omittingEmptySequence: omittingEmptySequence, separators.contains)(source))
  }
}