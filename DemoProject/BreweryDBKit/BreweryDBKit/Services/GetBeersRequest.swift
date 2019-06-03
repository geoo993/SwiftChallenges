
import Foundation

public struct GetBeersRequest: APIRequest, AutoQueryItems {
  public typealias Response = GetBeersResponse
  public let httpMethod = "GET"
  public let path = "beers"
  
  // sourcery:begin: queryItem
  public var styleId: Int?
  public var isOrganic: Bool?
  public var hasLabels: Bool?
  public var year: String?
  public var withBreweries: Bool?
  // sourcery:end
  
  public init() {
  }
}


