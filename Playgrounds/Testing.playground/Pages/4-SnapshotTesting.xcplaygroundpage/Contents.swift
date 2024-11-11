import Foundation
import XCTest
import SwiftUI

/* Snapshot testing -

These are an easy way to ensure that the UI doesn’t change unexpectedly when you modify your code.
 It is a powerful method of testing visual components that works by comparing a snapshot of your UI with a previously-stored reference image, if the two images are the same, the test will pass.
 If the images are different, the test will fail, and you know something has changed your UI.
 */

@MainActor
final class MoviesScreenSnapshotTests: XCTestCase {

    func test_screen() async {
        let view = sut()
        verify(view: view)
    }
    
    // Comes from Snapshot testing framework
    private func verify(view: some View) {
        // test initial screenshot vs latest screenshot of the test
    }
}

extension MoviesScreenSnapshotTests {
    private func sut() -> MoviesScreen.ContentView {
        .init(
            movies: [
                .init(id: "1", title: "Matrix", overview: "", genres: [.action, .adventure]),
                .init(id: "2", title: "Titanic", overview: "Rose Rose", genres: [.romance])
            ],
            event: { _ in }
        )
    }
}

MoviesScreenSnapshotTests.defaultTestSuite.run()
