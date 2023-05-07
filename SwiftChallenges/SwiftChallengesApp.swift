import SwiftUI

@main
struct SwiftChallengesApp: App {
    var body: some Scene {
        WindowGroup {
            MoviesView(
                store: .init(
                    initialState: .init(),
                    reducer: MoviesDB()
                )
            )
        }
    }
}
