import SwiftUI

@main
struct SwiftChallengesApp: App {
    var body: some Scene {
        WindowGroup {
            GreatestFilmsView(viewModel: .init())
        }
    }
}
