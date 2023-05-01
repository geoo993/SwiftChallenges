import Foundation

public struct FetchTrendingFilmsRequest: HTTPRequest {
    public typealias ResponseObject = MovieDBPayload<[MovieDTO]>
    public let provider: APIProvider
    public var path: String { "/3/trending/movie/week" }
    public var headers: HTTPHeaders?
    public var queryItems: [URLQueryItem]?
    
    public init(provider: APIProvider = .tmdb) {
        self.provider = provider
        self.queryItems = [.init(name: "api_key", value: provider.apiKey)]
    }
}
