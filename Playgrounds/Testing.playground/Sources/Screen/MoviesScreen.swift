import SwiftUI

public struct MoviesScreen: View {
    public enum Event: Equatable {
        case didAppear
        case didTap(Movie)
    }

    @StateObject private var viewModel: ViewModel
    @State private var currentTask: Event?

    public init(viewModel: ViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }

    public var body: some View {
        ContentView(movies: viewModel.movies) { event in
            self.currentTask = event
        }
        .navigationTitle("Movie List")
        .task(id: currentTask) {
            guard let event = currentTask else { return }
            await viewModel.handle(event: event)
        }
    }
}
