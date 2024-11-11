import Foundation
import XCTest

/* Integration Testing
 
 After unit testing, when we are sure of the functionality of the individual units/modules, it becomes necessary to check the integration as well.
 This testing is performed to find out the issues related to various integration points.
 */

final class MoviesScreenViewModelTests: XCTestCase {
    private var tracker: MockAnalyticsTracker!
    
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
        tracker = MockAnalyticsTracker()
        apiClient = IMDBClient(session: session)
    }

   func test_didAppear() async {
       await session.register(
           stub: MockIMDBSession.Stub(
                path: "/3/trending/movie/week",
                method: .get,
                statusCode: 200,
                data: response
           )
       )
       
       let movie: Movie = .init(
            id: "21",
            title: "Matrix",
            overview: "Man stuck in the matrix",
            genres: [.action, .adventure]
       )
       let viewModel = sut()
       await viewModel.handle(event: .didAppear)
       
       XCTAssertEqual(viewModel.movies, [movie])
       XCTAssertEqual(tracker.values, [MoviesAnalytics.Screen.moviesScreen.rawValue])
   }

   func test_didTap() async {
       let viewModel = sut()
       let movie: Movie = .init(id: "32", title: "Matrix", overview: "", genres: [.action])
       await viewModel.handle(event: .didTap(movie))
       
       XCTAssertEqual(viewModel.selectedMovie, movie)
       XCTAssertEqual(tracker.values, [MoviesAnalytics.Action.movieSelected.rawValue])
   }
}

extension MoviesScreenViewModelTests {
    private func sut() -> MoviesScreen.ViewModel {
        .init(
            usecase: MoviesUseCase(apiClient: apiClient),
            analytics: MoviesAnalytics(tracker: tracker)
        )
    }
}

MoviesScreenViewModelTests.defaultTestSuite.run()
