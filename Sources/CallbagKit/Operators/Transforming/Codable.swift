import struct Foundation.Data

public func encode<T: Encodable, Coder: TopLevelEncoder, Encoded>(
  encoder: Coder
) -> Operator<T, Encoded> where Coder.Output == Encoded {
  return map(encoder.encode)
}

public func decode<Coder: TopLevelDecoder, Decoded: Decodable>(
  type: Decoded.Type,
  decoder: Coder
) -> Operator<Data, Decoded> where Coder.Input == Data {
  return map { try decoder.decode(type, from: $0)  }
}