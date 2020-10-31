#if canImport(Combine)
import protocol Combine.TopLevelEncoder
import protocol Combine.TopLevelDecoder
#else
public protocol TopLevelDecoder {

  associatedtype Input
  
  func decode<T: Decodable>(_ type: T.Type, from: Input) throws -> T
}

public protocol TopLevelEncoder {

  associatedtype Output
  
  func encode<T: Encodable>(_ value: T) throws -> Output
}

import class Foundation.JSONEncoder
import class Foundation.JSONDecoder

extension JSONEncoder: TopLevelEncoder {}
extension JSONDecoder: TopLevelDecoder {}

  #if swift(>=5.1)
  import class Foundation.PropertyListEncoder
  import class Foundation.PropertyListDecoder

  extension PropertyListEncoder: TopLevelEncoder {}
  extension PropertyListDecoder: TopLevelDecoder {}
  #endif
#endif