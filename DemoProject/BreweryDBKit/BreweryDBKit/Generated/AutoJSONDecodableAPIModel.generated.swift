// Generated using Sourcery 0.16.1 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT



    extension Beer: JSONDecodableAPIModel {
        public init?(json: [String: Any]) {
                    guard let id = json["id"] as? String else { return nil }
                    self.id = id
                    guard let name = json["name"] as? String else { return nil }
                    self.name = name
                    guard let description = json["description"] as? String else { return nil }
                    self.description = description
                    self.abv = json["abv"] as? String
                    self.ibu = json["ibu"] as? String
                    if let styleJson = json["style"] as? [String: Any] {
                      self.style = Style(json: styleJson)
                    } else {
                      self.style = nil
                    }
                    if let labelsJson = json["labels"] as? [String: Any] {
                      self.labels = Labels(json: labelsJson)
                    } else {
                      self.labels = nil
                    }
                    if let breweriesJson = json["breweries"] as? [[String: Any]] {
                      self.breweries = breweriesJson.flatMap { Brewery(json: $0) }
                    } else {
                      self.breweries = nil
                    }
        }
    }


    extension Beer.Labels: JSONDecodableAPIModel {
        public init?(json: [String: Any]) {
                    guard let icon = json["icon"] as? String else { return nil }
                    self.icon = icon
                    guard let medium = json["medium"] as? String else { return nil }
                    self.medium = medium
                    guard let large = json["large"] as? String else { return nil }
                    self.large = large
        }
    }


    extension Brewery: JSONDecodableAPIModel {
        public init?(json: [String: Any]) {
                    guard let id = json["id"] as? String else { return nil }
                    self.id = id
                    guard let name = json["name"] as? String else { return nil }
                    self.name = name
                    guard let description = json["description"] as? String else { return nil }
                    self.description = description
                    guard let website = json["website"] as? String else { return nil }
                    self.website = website
                    guard let established = json["established"] as? String else { return nil }
                    self.established = established
        }
    }


    extension Style: JSONDecodableAPIModel {
        public init?(json: [String: Any]) {
                    guard let id = json["id"] as? Int else { return nil }
                    self.id = id
                    guard let categoryId = json["categoryId"] as? Int else { return nil }
                    self.categoryId = categoryId
                    guard let name = json["name"] as? String else { return nil }
                    self.name = name
                    guard let shortName = json["shortName"] as? String else { return nil }
                    self.shortName = shortName
                    guard let description = json["description"] as? String else { return nil }
                    self.description = description
        }
    }

