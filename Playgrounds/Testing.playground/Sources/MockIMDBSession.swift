import Foundation

@MainActor
public final class MockIMDBSession: HTTPSession {
    private var stub: Stub?
    
    public init() {}
    
    public func register(stub: Stub) {
        self.stub = stub
    }
    
    public func data(of urlRequest: URLRequest) async throws -> (Data, URLResponse) {
        let stub = try self.registeredStub(for: urlRequest)
        guard let url = urlRequest.url else { throw APIError.invalidUrl }
        guard let response = HTTPURLResponse(
            url: url,
            statusCode: stub.statusCode,
            httpVersion: "HTTP/1.1",
            headerFields: nil
        ) else { throw APIError.requestFailed }
        return (stub.data, response)
    }

    private func registeredStub(for request: URLRequest) throws -> Stub {
        guard
            let stub = self.stub,
            let path = request.url?.path,
            request.httpMethod == stub.method.rawValue,
            path == stub.path
        else { throw URLError(.dataNotAllowed) }
        return stub
    }
}

extension MockIMDBSession {
    public struct Stub {
        let path: String
        let method: HTTPMethod
        let statusCode: Int
        let data: Data

        public init(
            path: String,
            method: HTTPMethod,
            statusCode: Int,
            data: Data = Data()
        ) {
            self.path = path
            self.method = method
            self.statusCode = statusCode
            self.data = data
        }
    }
}
