
// https://stackoverflow.com/questions/24231680/loading-downloading-image-from-url-on-swift?utm_medium=organic&utm_source=google_rich_qa&utm_campaign=google_rich_qa
extension UIImageView {

    public func downloadedFrom(url: URL, contentMode mode: UIView.ContentMode = .scaleAspectFit) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() {
                self.image = image
            }
            }.resume()
    }

    public func downloadedFrom(link: String, contentMode mode: UIView.ContentMode = .scaleAspectFit) {
        guard let url = URL(string: link) else { return }
        downloadedFrom(url: url, contentMode: mode)
    }

    public func getImageFromWeb(_ string: String, closure: @escaping (UIImage?) -> Void) {
        guard let url = URL(string: string) else {
            return closure(nil)
        }
        getImageFromWeb(with: url, closure: closure)
    }

    public func getImageFromWeb(with url: URL, closure: @escaping (UIImage?) -> Void) {

        let task = URLSession(configuration: .default).dataTask(with: url) { (data, response, error) in
            DispatchQueue.main.async {
                guard error == nil else {
                    print("error: \(String(describing: error))")
                    return closure(nil)
                }
                guard response != nil, let mimeType = response?.mimeType, mimeType.hasPrefix("image") else {
                    print("no response")
                    return closure(nil)
                }
                guard data != nil else {
                    print("no data")
                    return closure(nil)
                }
                closure(UIImage(data: data!))
            }
        }
        task.resume()
    }

}

public class ImageLoader {

    private let cache = NSCache<NSString, NSData>()

    func image(for url: URL, completionHandler: @escaping(_ image: UIImage?) -> Void) {

        DispatchQueue.global(qos: DispatchQoS.QoSClass.background).async {
            if let data = self.cache.object(forKey: url.absoluteString as NSString) {
                DispatchQueue.main.async { completionHandler(UIImage(data: data as Data)) }
                return
            }
            guard let data = NSData(contentsOf: url) else {
                DispatchQueue.main.async { completionHandler(nil) }
                return
            }
            self.cache.setObject(data, forKey: url.absoluteString as NSString)
            DispatchQueue.main.async { completionHandler(UIImage(data: data as Data)) }
        }
    }
}
