import Foundation

public protocol MoviesUseCaseProvider: Sendable {
    func get() async throws -> [Movie]
}

public struct MoviesUseCase: MoviesUseCaseProvider {
    private let apiClient: APIClient

    public init(apiClient: APIClient = IMDBClient()) {
        self.apiClient = apiClient
    }
    
    public func get() async throws -> [Movie] {
        let movies = try await apiClient.execute(request: FetchMoviesRequest())
        return movies.map(Movie.init)
    }
}

extension Movie {
    init(model: MovieDTO) {
        self.init(
            id: "\(model.id)",
            title: model.title,
            overview: model.overview,
            genres: model.genres.compactMap { Genre(rawValue: $0) }
        )
    }
}
