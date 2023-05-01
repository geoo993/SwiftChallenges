import Foundation

public typealias HTTPHeaders = [String: String]

public protocol HTTPRequest {
    associatedtype ResponseObject = Any
    var provider: APIProvider { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var headers: HTTPHeaders? { get }
    var queryItems: [URLQueryItem]? { get }
    var timeoutInterval: TimeInterval { get }
}

extension HTTPRequest {
    public var baseUrl: URL? { provider.baseUrl }
    public var method: HTTPMethod { .get }
    public var queryItems: [URLQueryItem]? { nil }
    public var timeoutInterval: TimeInterval { 30.0 }
}
