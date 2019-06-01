// Generated using Sourcery 0.16.1 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT

private protocol QueryStringConvertible {
  var queryStringValue: String? { get }
}

extension String: QueryStringConvertible {
  var queryStringValue: String? {
    return self
  }
}

extension Int: QueryStringConvertible {
  var queryStringValue: String? {
    return String(self)
  }
}

extension Bool: QueryStringConvertible {
  var queryStringValue: String? {
    return self ? "Y" : "N"
  }
}


extension GetBeersRequest {

  public var queryItems: [URLQueryItem] {
    var items = [URLQueryItem]()
      if let styleId = styleId?.queryStringValue {
        items.append(URLQueryItem(name: "styleId", value: styleId))
      }
      if let isOrganic = isOrganic?.queryStringValue {
        items.append(URLQueryItem(name: "isOrganic", value: isOrganic))
      }
      if let hasLabels = hasLabels?.queryStringValue {
        items.append(URLQueryItem(name: "hasLabels", value: hasLabels))
      }
      if let year = year?.queryStringValue {
        items.append(URLQueryItem(name: "year", value: year))
      }
      if let withBreweries = withBreweries?.queryStringValue {
        items.append(URLQueryItem(name: "withBreweries", value: withBreweries))
      }
    return items
  }
}

