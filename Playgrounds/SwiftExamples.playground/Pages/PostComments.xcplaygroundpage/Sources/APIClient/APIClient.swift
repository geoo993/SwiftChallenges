import Foundation

public enum APIError: Error {
    case dataNotAvailable
}

public protocol APIRequest {
    associatedtype ResponseObject = Any
    var type: Resource { get }
}

public protocol APIRequestable {
    func execute<T: APIRequest, V: Decodable>(request: T) throws -> V where V == T.ResponseObject
}

public struct APIClient: APIRequestable {
    public init() {}
    
    public func execute<T: APIRequest, V: Decodable>(request: T) throws -> V where V == T.ResponseObject {
        guard let data = request.type.data() else {
            throw APIError.dataNotAvailable
        }
        return try JSONDecoder.withDateFormatter().decode(T.ResponseObject.self, from: data)
    }
}
