import Foundation

public enum APIProvider {
    case tmdb
}

extension APIProvider {
    var baseUrl: URL? {
        switch self {
        case .tmdb: return URL(string: "https://api.themoviedb.org")
        }
    }
    
    var apiKey: String {
        switch self {
        case .tmdb: return "b3114ca25838f95dfdefa87a089ae813"
        }
    }
}
