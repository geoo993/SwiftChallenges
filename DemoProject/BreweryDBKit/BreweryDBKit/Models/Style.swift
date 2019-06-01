
import Foundation

public struct Style: AutoJSONDecodableAPIModel {
  public let id: Int
  public let categoryId: Int
  public let name: String
  public let shortName: String
  public let description: String
}

