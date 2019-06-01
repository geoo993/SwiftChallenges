import Foundation
import BreweryDBKit

extension Beer {
  var breweryDisplayString: String {
    if let breweryNames = breweries?.map({ $0.name }), breweryNames.count > 0 {
      return breweryNames.joined()
    } else {
      return "Unknown Brewery"
    }
  }
}
