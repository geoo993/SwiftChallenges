
import Foundation

public protocol JSONDecodable {
  init?(json: [String: Any])
}

public protocol JSONEncodable {
  var json: [String: Any] { get }
}

public protocol APIModel {
}


protocol AutoJSONDecodableAPIModel {}
public protocol JSONDecodableAPIModel: APIModel, JSONDecodable {}

protocol AutoQueryItems {}
public protocol APIRequest {
  associatedtype Response: APIResponse
  var httpMethod: String { get }
  var path: String { get }
  var queryItems: [URLQueryItem] { get }
}


protocol AutoAPICollectionResponse {}
public protocol APIResponse {
  associatedtype Model: JSONDecodableAPIModel
  init?(json: [String: Any])
  var status: String { get }
}

public protocol APIEntityResponse: APIResponse {
  var data: Model { get }
}

public protocol APICollectionResponse: APIResponse {
  var data: [Model] { get }
}
