
import Foundation

public struct GetStylesResponse: APICollectionResponse, AutoAPICollectionResponse {
  public typealias Model = Style
  
  public let status: String
  public let data: [Style]
  
}
