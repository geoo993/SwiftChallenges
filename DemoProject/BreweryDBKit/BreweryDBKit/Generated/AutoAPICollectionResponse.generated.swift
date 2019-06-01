// Generated using Sourcery 0.16.1 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT


extension GetBeersResponse {

  public init?(json: [String: Any]) {
    guard let status = json["status"] as? String else { return nil }
    self.status = status

    if let dataArray = json["data"] as? [[String: Any]] {
        self.data = dataArray.flatMap { return Beer(json: $0) }
    } else {
        self.data = []
    }

          self.totalResults = json["totalResults"] as? Int ?? 0
          self.currentPage = json["currentPage"] as? Int ?? 1
  }
}

extension GetStylesResponse {

  public init?(json: [String: Any]) {
    guard let status = json["status"] as? String else { return nil }
    self.status = status

    if let dataArray = json["data"] as? [[String: Any]] {
        self.data = dataArray.flatMap { return Style(json: $0) }
    } else {
        self.data = []
    }

  }
}

