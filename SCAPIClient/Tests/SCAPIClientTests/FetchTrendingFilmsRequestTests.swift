import XCTest
@testable import SCAPIClient

final class FetchTrendingFilmsRequestTests: XCTestCase {
    var apiClient: APIClient!
    var session: MockHTTPSession!
        
    override func setUp() {
        super.setUp()
        session = MockHTTPSession()
        apiClient = SCAPIClient(session: session)
    }

    override func tearDown() {
        session = nil
        apiClient = nil
        super.tearDown()
    }
    
    func testRequest() async throws {
        session.register(
            stub: MockHTTPSession.Stub(
                path: "/3/trending/movie/week",
                method: .get,
                statusCode: 201,
                data: FetchTrendingFilmsRequest.dummy()
            )
        )
        let request = FetchTrendingFilmsRequest()
        let movies = try await apiClient.execute(request: request)
        XCTAssertEqual(movies.results.count, 20)
        XCTAssertEqual(movies.results.first?.title, "Ant-Man and the Wasp: Quantumania")
    }
}

extension FetchTrendingFilmsRequest: DummyProviding {}
