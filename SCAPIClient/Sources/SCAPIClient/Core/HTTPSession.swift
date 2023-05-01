import Foundation

public protocol HTTPSession {
    typealias DataOutput = (data: Data, response: URLResponse)
    func data(of urlRequest: URLRequest) async throws -> DataOutput
}

extension URLSession: HTTPSession {
    public func data(of urlRequest: URLRequest) async throws -> DataOutput {
        try await data(for: urlRequest)
    }
}
