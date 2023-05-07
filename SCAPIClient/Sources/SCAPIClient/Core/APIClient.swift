import Foundation

public protocol APIClient {
    func execute<T: HTTPRequest, V: Decodable>(
        request: T
    ) async throws -> V where T.ResponseObject == V
}
