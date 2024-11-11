// Type `What is RESTful API and what are the best practices in swift` in chatgpt

import Foundation

/*
 --- A RESTful API (Representational State Transfer) is an architectural style for building web services that communicate over HTTP/Network.
 RESTful APIs are stateless and rely on standard HTTP methods like GET, POST, PUT, DELETE for operations.
 RESTful APIs allow clients (e.g., mobile apps, websites) to interact with servers by making HTTP requests to perform CRUD (Create, Read, Update, Delete) operations on resources (e.g., users, posts, products).
 */

/*
 Key Characteristics of RESTful APIs:
 - Stateless: Every request from the client to the server must contain all necessary information to understand and complete the request.
 - Resource-Oriented: The API is organized around resources (e.g., users, posts), and each resource is represented by a URL.
 - HTTP Methods:
    GET: Retrieve a resource.
    POST: Create a new resource.
    PUT / PATCH: Update an existing resource.
    DELETE: Remove a resource.
 - Standard HTTP Codes: APIs use HTTP status codes to indicate success or failure (e.g., 200 OK, 404 Not Found, 500 Internal Server Error).
 - Stateless interactions: Each request contains all information to process, without relying on server-side session data.
 */

// --- REST API Client example and best practices

typealias HTTPHeaders = [String: String]

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

//--- BEST PRACTICE 3.) Define Errors in order to Handle Errors Gracefully
// Handling errors, such as network timeouts, incorrect data formats, or server errors, is important for improving user experience.
// Check HTTP status codes (200 OK, 404 Not Found, 500 Internal Server Error).
// Handle different error conditions (no internet, data parsing errors, server errors).
typealias HTTPCode = Int
typealias HTTPCodes = Range<HTTPCode>

extension HTTPCodes {
    static let success = 200..<300
    static let serverError = 401...500
}

enum APIError: Error, Equatable {
    case invalidUrl
    case invalidUrlComponent
    case responseError(HTTPCode)
    case requestFailed

    var localizedDescription: String {
        switch self {
        case .invalidUrl: 
            return "We encounted an error with the url"
        case .invalidUrlComponent:
            return "We encountered an error with the url component"
        case .responseError(let statusCode): 
            return "We had an error with response with status code \(statusCode)"
        case .requestFailed:
            return "The request failed"
        }
    }
}

protocol HTTPRequest {
    associatedtype ResponseObject = Any
    var baseUrl: URL? { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var headers: HTTPHeaders? { get }
    var queryItems: [URLQueryItem]? { get }
    var timeoutInterval: TimeInterval { get }
}

//--- BEST PRACTICE 1.) Use URLSession for Network Requests
// URLSession is the primary API in Swift for making network requests.
// It supports data tasks, upload tasks, download tasks, and more.
// Abstracting the URL session enables us to prepare a mock URL session to test our API client
protocol HTTPSession {
    func data(of urlRequest: URLRequest) async throws -> (Data, URLResponse)
}

extension URLSession: HTTPSession {
    func data(of urlRequest: URLRequest) async throws -> (Data, URLResponse) {
        try await data(for: urlRequest)
    }
}

protocol APIClientExecutable {
//--- BEST PRACTICE 4.) Use async/await for Asynchronous Networking
// Starting from Swift 5.5, you can use async/await to write asynchronous code more elegantly, making network requests easier to manage.
    func execute<T: HTTPRequest, V: Decodable>(
        request: T
    ) async throws -> V where T.ResponseObject == V
}

struct APIClient: APIClientExecutable {
    private let session: HTTPSession

    init(session: HTTPSession = URLSession.shared) {
        self.session = session
    }
    
    func execute<T: HTTPRequest, V: Decodable>(
        request: T
    ) async throws -> V where T.ResponseObject == V {
        let urlRequest = try urlRequest(from: request)
        let (data, urlResponse) = try await session.data(of: urlRequest)
        return try process(data, urlResponse)
    }
    
    private func urlRequest<T: HTTPRequest>(from endPoint: T) throws -> URLRequest {
        let url = try urlComponent(from: endPoint)
        var request = URLRequest(url: url)
        request.httpMethod = endPoint.method.rawValue
        request.timeoutInterval = endPoint.timeoutInterval
        setHeaders(with: endPoint.headers, request: &request)
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
    
    private func setHeaders(with headers: HTTPHeaders?, request: inout URLRequest) {
        var values = ["Content-Type": "application/json"]
        if let httpHeaders = headers { values.merge(httpHeaders) { $1 } }
        for (key, value) in values {
            request.setValue(value, forHTTPHeaderField: key)
        }
    }
    
    private func process<T: Decodable>(
        _ data: Data,
        _ urlResponse: URLResponse
    ) throws -> T {
        let response = urlResponse as? HTTPURLResponse
        switch (data, response) {
        case let (data, .some(value)) where HTTPCodes.success ~= value.statusCode:
            return try JSONDecoder().decode(T.self, from: data)
        case let (_, .some(value)):
            throw error(for: value.statusCode)
        default:
            throw APIError.requestFailed
        }
    }

    private func error(
        for code: HTTPCode
    ) -> APIError {
        switch code {
        case HTTPCodes.serverError: return .requestFailed
        default: return .responseError(code)
        }
    }
}

//
// --- BEST PRACTICE 2.) Use Codable for JSON Parsing
// Instead of manually parsing JSON, Swift provides Codable for automatically encoding (i.e Encodable) and decoding (i.e Decodable) JSON to and from Swift models.
struct Country: Decodable {
    let name: Name
    let region: String
    let population: Int
    
    struct Name: Decodable {
        let common: String
    }
}

// Example with countries API
struct FetchCountriesRequest: HTTPRequest {
    
//--- BEST PRACTICE 8.) Secure Networking
//    - Use HTTPS for all network calls.
//    - Handle authentication securely (e.g., using OAuth2, tokens, etc.).
//    - Store sensitive data securely (e.g., tokens in Keychain).
    typealias ResponseObject = [Country]
    var baseUrl: URL? { URL(string: "https://restcountries.com") }
    var path: String { "/v3.1/name/france" }
    var method: HTTPMethod = .get
    var headers: HTTPHeaders?
    var queryItems: [URLQueryItem]?
    var timeoutInterval: TimeInterval = 30
}

//--- BEST PRACTICE 6.) Avoid Blocking the Main Thread
// Network requests should be handled asynchronously, so you should never block the main thread while waiting for a response. Blocking the main thread can cause the app to freeze.
// Swift concurrency allow us to call @MainActor to indicate that this task should be run back on the main thread
@MainActor
func loadCountries() async {
    let client = APIClient()
    do {

//  --- BEST PRACTICE 9.) Cache Data if Necessary
//  To avoid making unnecessary API calls, cache data using URLCache, Core Data, or UserDefaults for temporary storage.
        let countries = try await client.execute(request: FetchCountriesRequest())
        countries.forEach {
            print("name: \($0.name.common), population: \($0.population), region: \($0.region)")
        }
    } catch let error {
//  --- BEST PRACTICE 10.) Handle error gracefully or Retry when request failed
//  For transient errors like network issues, implement retry logic to retry failed requests a certain number of times before showing an error to the user.
        print("ERROR found: \(error.localizedDescription)")
    }
}

//--- BEST PRACTICE 5.) Handle Background and UI Thread Appropriately
// Network tasks should run in the background, but any UI updates should happen on the main thread.
// This is why we use Tasks to tell swiftUI that this is a background operation
Task {
    await loadCountries()
}

//  --- BEST PRACTICE 11.) Ensure the robustness of your API Client by testing
// - Testing the APIClient layer is a major part of keeping application fit and robust over time.
// - The tests should cover
//      * URL componsition of the REST protocol
//      * Data parsing
//      * All Error cases can be caught
// - A great way to Test our APIClient is to mock our URLSession and inject via dependency injection in APIClient
class MockHTTPSession: HTTPSession {
    private var stub: Stub?
    
    func register(stub: Stub) {
        self.stub = stub
    }
    
    func data(of urlRequest: URLRequest) async throws -> (Data, URLResponse) {
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

extension MockHTTPSession {
    struct Stub {
        let path: String
        let method: HTTPMethod
        let statusCode: HTTPCode
        let data: Data

        init(
            path: String,
            method: HTTPMethod,
            statusCode: HTTPCode,
            data: Data = Data()
        ) {
            self.path = path
            self.method = method
            self.statusCode = statusCode
            self.data = data
        }
    }
}

func testRequest() {
    let session = MockHTTPSession()
    let apiClient = APIClient(session: session)
    let response: Data =
        """
        [
            {
                "name": {
                    "common": "italy"
                },
                "population": 64043146,
                "region": "europe"
            }
        ]
        """
        .data(using: .utf8)!

    session.register(
        stub: MockHTTPSession.Stub(
            path: "/v3.1/name/france",
            method: .get,
            statusCode: 200,
            data: response
        )
    )
    let request = FetchCountriesRequest()
    Task {
        do {
            let movies = try await apiClient.execute(request: request)
            print("Number of countries:", movies.count)
            print("Country name:", movies.first?.name.common)
        } catch {
            print("Have an error:", error.localizedDescription)
        }
    }
}

testRequest()
