import Foundation

public extension MoviesScreen {

    final class ViewModel: ObservableObject {
        @Published public var movies: [Movie] = []
        @Published public var selectedMovie: Movie?
        private let usecase: MoviesUseCaseProvider
        private let analytics: MoviesAnalytics
        
        public init(
            usecase: MoviesUseCaseProvider = MoviesUseCase(),
            analytics: MoviesAnalytics = MoviesAnalytics()
        ) {
            self.usecase = usecase
            self.analytics = analytics
        }
        
        @MainActor
        public func handle(event: Event) async {
            switch event {
            case .didAppear:
                analytics.track(screen: .moviesScreen)
                if let results = try? await usecase.get() {
                    movies = results
                }
            case let .didTap(movie):
                selectedMovie = movie
                analytics.track(action: .movieSelected, movie: movie)
            }
        }
    }
}
