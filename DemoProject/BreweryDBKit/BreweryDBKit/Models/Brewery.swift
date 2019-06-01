
import Foundation

public struct Brewery: AutoJSONDecodableAPIModel {
  public let id: String
  public let name: String
  public let description: String
  public let website: String
  public let established: String
}
