import Foundation

public struct MovieDTO: Decodable {
    public let id: Int
    public let title: String
    public let overview: String
    public let genres: [String]
}

public struct FetchMoviesRequest: HTTPRequest {
    public typealias ResponseObject = [MovieDTO]
    public var baseUrl: URL? { URL(string: "https://api.themoviedb.org") }
    public var path: String { "/3/trending/movie/week" }
    public var method: HTTPMethod = .get
    public var queryItems: [URLQueryItem]?
    public var timeoutInterval: TimeInterval = 30
    
    public init(page: Int = 1) {
        self.queryItems = [
            .init(name: "page", value: "\(page)")
        ]
    }
}
