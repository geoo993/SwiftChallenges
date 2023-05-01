import SCDomain
import SCAPIClient
import Foundation

@MainActor
final class GreatestFilmsViewModel: ObservableObject {
    @Published var movies: [Movie] = []

    func movies() async {
        let apiClient = SCAPIClient()
        do {
            let value = try await apiClient.execute(request: FetchTrendingFilmsRequest())
            movies = value.results.map(Movie.init)
        } catch {
            movies = []
        }
    }
}

extension Movie {
    init(model: MovieDTO) {
        self.init(
            id: String(model.id),
            title: model.title,
            overview: model.overview,
            poster: model.posterUrl,
            releaseDate: model.releaseDate
        )
    }
}
