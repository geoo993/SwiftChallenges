import Foundation

public final class MockAPIClient: APIClient {
    var executeCalled = false
    var executeRequest: ((_ request: Any) -> Result<Any, APIError>)?
    
    public init() {}
    
    public func execute<T: HTTPRequest, V: Decodable>(
        request: T
    ) async throws -> V where T.ResponseObject == V {
        executeCalled = true
        guard let callback = executeRequest else {
            throw APIError.unknown
        }
        let result = callback(request)
        switch result {
        case let .success(value as V):
            return value
        case let .failure(error):
            throw error
        default:
            throw APIError.unknown
        }
    }
}
