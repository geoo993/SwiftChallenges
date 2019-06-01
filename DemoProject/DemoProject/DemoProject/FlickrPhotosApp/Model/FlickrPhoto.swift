import UIKit

struct FlickrPhoto: Codable, Equatable {
  
  let id : String
  let title: String
  let farm : Int
  let server : String
  let secret : String
  
  static func ==(_ lhs: FlickrPhoto, _ rhs: FlickrPhoto) -> Bool {
    return lhs.id == rhs.id
  }
}

// MARK: - Computed Properties
extension FlickrPhoto {
  
  var isFavourite: Bool {
    get {
      return UserDefaults.standard.bool(forKey: id)
    }
    set {
      UserDefaults.standard.set(newValue, forKey: id)
    }
  }
}
