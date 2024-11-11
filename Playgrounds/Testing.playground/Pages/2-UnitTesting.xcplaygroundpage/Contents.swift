import Foundation
import XCTest

/* Unit Testing
 
 This testing checks if a particular module of the source code is functioning as expected or not.
 - This test is when we test the smallest units or components in it.
 - We test an independent module in isolation during unit testing.
 - These are small tests where the input is provided to the small unit of the app and the output is checked against the expected values.
*/

final class FetchMoviesRequestTests: XCTestCase {
    
    @MainActor
    private let session = MockIMDBSession()
    private var apiClient: IMDBClient!
    
    let response: Data =
        """
        [
            {
                "id": 21,
                "title": "Matrix",
                "overview": "Man stuck in the matrix",
                "genres": [
                    "Action",
                    "Adventure"
                ]
            }
        ]
        """
        .data(using: .utf8)!

    override func setUp() {
        super.setUp()
        apiClient = IMDBClient(session: session)
    }
    
   func test_request_failed() async {
       await session.register(
           stub: MockIMDBSession.Stub(
                path: "/3/trending/movie/week",
                method: .get,
                statusCode: 401,
                data: Data()
           )
        )

       let request = FetchMoviesRequest()
       do {
           let movies = try await apiClient.execute(request: request)
           XCTFail()
       } catch {
           let errorValue = error as? APIError
           XCTAssertEqual(errorValue, .requestFailed)
       }
   }

   func test_request_succeeded() async throws {
       await session.register(
           stub: MockIMDBSession.Stub(
                path: "/3/trending/movie/week",
                method: .get,
                statusCode: 200,
                data: response
           )
        )

       let request = FetchMoviesRequest(page: 1)
       let movies = try await apiClient.execute(request: request)
       XCTAssertEqual(movies.count, 1)
       XCTAssertEqual(movies.first?.title, "Matrix")
       XCTAssertEqual(movies.first?.genres, ["Action", "Adventure"])
       
       print(movies.first?.id, movies.first?.title, movies.first?.genres)
   }
}

FetchMoviesRequestTests.defaultTestSuite.run()
