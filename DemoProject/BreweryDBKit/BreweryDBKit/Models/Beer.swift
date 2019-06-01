
import Foundation

public struct Beer: AutoJSONDecodableAPIModel {
  
  public let id: String
  public let name: String
  public let description: String
  public let abv: String?
  public let ibu: String?
  
  public let style: Style?
  public let labels: Labels?
  public let breweries: [Brewery]?
  
  public struct Labels: AutoJSONDecodableAPIModel {
    public let icon: String
    public let medium: String
    public let large: String
    
    // sourcery:begin: ignore
    public var iconUrl: URL?   { return URL(string: icon) }
    public var mediumUrl: URL? { return URL(string: medium) }
    public var largeUrl: URL?  { return URL(string: large) }
    // sourcery:end
  }
}
