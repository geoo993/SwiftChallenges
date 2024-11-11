import Foundation

public enum HTTPMethod: String, Sendable {
    case get = "GET"
}

public enum APIError: Error, Equatable {
    case invalidUrl
    case invalidUrlComponent
    case requestFailed

    var localizedDescription: String {
        switch self {
        case .invalidUrl:
            return "We encounted an error with the url"
        case .invalidUrlComponent:
            return "We encountered an error with the url component"
        case .requestFailed:
            return "The request failed"
        }
    }
}

public protocol HTTPRequest {
    associatedtype ResponseObject = Any
    var baseUrl: URL? { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var queryItems: [URLQueryItem]? { get }
    var timeoutInterval: TimeInterval { get }
}

public protocol HTTPSession: Sendable {
    func data(of urlRequest: URLRequest) async throws -> (Data, URLResponse)
}

extension URLSession: HTTPSession {
    public func data(of urlRequest: URLRequest) async throws -> (Data, URLResponse) {
        try await data(for: urlRequest)
    }
}

public protocol APIClient: Sendable {
    func execute<T: HTTPRequest, V: Decodable>(
        request: T
    ) async throws -> V where T.ResponseObject == V
}

public struct IMDBClient: APIClient {
    private let session: HTTPSession

    public init(session: HTTPSession = URLSession.shared) {
        self.session = session
    }
    
    public func execute<T: HTTPRequest, V: Decodable>(
        request: T
    ) async throws -> V where T.ResponseObject == V {
        let urlRequest = try urlRequest(from: request)
        let (data, urlResponse) = try await session.data(of: urlRequest)
        
        guard
            let response = urlResponse as? HTTPURLResponse, 200..<300 ~= response.statusCode
        else { throw APIError.requestFailed }
        return try JSONDecoder().decode(V.self, from: data)
    }
    
    private func urlRequest<T: HTTPRequest>(from endPoint: T) throws -> URLRequest {
        let url = try urlComponent(from: endPoint)
        var request = URLRequest(url: url)
        request.httpMethod = endPoint.method.rawValue
        request.timeoutInterval = endPoint.timeoutInterval
        return request
    }
    
    private func urlComponent<T: HTTPRequest>(from endPoint: T) throws -> URL {
        guard
            let url = endPoint.baseUrl,
            var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false)
        else { throw APIError.invalidUrl }
        urlComponents.path = endPoint.path
        urlComponents.queryItems = endPoint.queryItems
        guard let url = urlComponents.url else { throw APIError.invalidUrlComponent }
        return url
    }
}
