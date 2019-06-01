import UIKit

class ImageCache {
  
  private static let _shared = ImageCache()
  
  var images = [String:UIImage]()
  
  static var shared: ImageCache {
    return _shared
  }
    init() {
        NotificationCenter.default.addObserver(forName: UIApplication.didEnterBackgroundNotification,
                                               object: nil, queue: .main) { [weak self] notification in
            self?.images.removeAll(keepingCapacity: false)
        }
    }
    
    deinit {
        //NotificationCenter.default.removeObserver(self)
        NotificationCenter.default.removeObserver(self, name: UIApplication.didEnterBackgroundNotification, object: nil)
    }
  
  func loadThumbnail(for photo: FlickrPhoto, completion: @escaping FlickrAPI.FetchImageCompletion) {
    if let image = ImageCache.shared.image(forKey: photo.id) {
        completion(Result.success(image))
    }
    else {
        FlickrAPI.loadImage(for: photo, withSize: "m") { result in
            if case .success(let image) = result {
                ImageCache.shared.set(image, forKey: photo.id)
            }
            completion(result)
        }
    }
    
  }
}

// MARK: - Custom Accessors
extension ImageCache {
  
  func set(_ image: UIImage, forKey key: String) {
    images[key] = image
  }
  
  func image(forKey key: String) -> UIImage? {
    return images[key]
  }
}
