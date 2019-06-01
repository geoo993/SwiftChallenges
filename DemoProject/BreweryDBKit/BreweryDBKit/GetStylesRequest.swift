
import Foundation

public struct GetStylesRequest: APIRequest {
  public typealias Response = GetStylesResponse
  
  public let httpMethod = "GET"
  public let path = "styles"
  public let queryItems: [URLQueryItem] = []
  
  public init() {
  }
}
