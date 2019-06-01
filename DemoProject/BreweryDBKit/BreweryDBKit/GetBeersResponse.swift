
import Foundation


public struct GetBeersResponse: APICollectionResponse, AutoAPICollectionResponse {
  public typealias Model = Beer
  
  public let status: String
  public let data: [Beer]
  
  // sourcery:begin: additionalParameters, optionalInResponse
  // sourcery: defaultValue = 0
  public let totalResults: Int
  // sourcery: defaultValue = 1
  public let currentPage: Int
  // sourcery:end
  
}
