import SCDomain
import Dependencies
import Foundation
import SCAPIClient

protocol MoviesRepositoryProviding {
    func getTrendingMovies(page: Int) async throws -> [Movie]
}

final class MoviesRepository: MoviesRepositoryProviding {
    private let apiClient: APIClient
    
    init(apiClient: APIClient = SCAPIClient()) {
        self.apiClient = apiClient
    }
    
    func getTrendingMovies(page: Int) async throws -> [Movie] {
        return try await apiClient
            .execute(request: FetchTrendingFilmsRequest(page: page))
            .results
            .map(Movie.init)
    }
}

extension Movie {
    init(model: MovieDTO) {
        self.init(
            id: String(model.id),
            title: model.title,
            overview: model.overview,
            poster: model.posterUrl,
            releaseDate: model.releaseDate,
            genres: model.genres.map(Genre.init)
        )
    }
}

extension Genre {
    init(model: GenreDTO) {
        switch model {
        case .action: self = .action
        case .adventure: self = .adventure
        case .animation: self = .animation
        case .comedy: self = .comedy
        case .crime: self = .crime
        case .documentary: self = .documentary
        case .drama: self = .drama
        case .family: self = .family
        case .fantasy: self = .fantasy
        case .history: self = .history
        case .horror: self = .horror
        case .music: self = .music
        case .mystery: self = .mystery
        case .romance: self = .romance
        case .scifi: self = .scifi
        case .thriller: self = .thriller
        case .war: self = .war
        }
    }
}

extension Array where Element == Movie {
    static func fixture() -> Self {
        [Movie(
            id: "493529",
            title: "Dungeons & Dragons: Honor Among Thieves",
            overview: "A charming thief and a band of",
            poster: URL(string: "https://image.tmdb.org/t/p/original/v7UF7ypAqjsFZFdjksjQ7IUpXdn.jpg"),
            releaseDate: .now,
            genres: [.adventure]
        ),
         Movie(
             id: "447365",
             title: "Guardians of the Galaxy Volume 3",
             overview: "Peter Quill, still reeling from the loss of Gamor",
             poster: URL(string: "https://image.tmdb.org/t/p/original/r2J02Z2OpNTctfOSN1Ydgii51I3.jpg"),
             releaseDate: .now,
             genres: [.scifi]
         ),
         Movie(
             id: "758323",
             title: "The Pope's Exorcist",
             overview: "Father Gabriele Amorth, Chief Exorcist of the Vatican",
             poster: URL(string: "https://image.tmdb.org/t/p/original/9JBEPLTPSm0d1mbEcLxULjJq9Eh.jpg"),
             releaseDate: .now,
             genres: [.horror]
         ),
         Movie(
             id: "640146",
             title: "Ant-Man and the Wasp: Quantumania",
             overview: "Super-Hero partners Scott Lang and Hope van Dyne",
             poster: URL(string: "https://image.tmdb.org/t/p/original/ngl2FKBlU4fhbdsrtdom9LVLBXw.jpg"),
             releaseDate: .now,
             genres: [.action]
         ),
         Movie(
             id: "948713",
             title: "The Last Kingdom: Seven Kings Must Die",
             overview: "In the wake of King Edward's death",
             poster: URL(string: "https://image.tmdb.org/t/p/original/7yyFEsuaLGTPul5UkHc5BhXnQ0k.jpg"),
             releaseDate: .now,
             genres: [.action]
         ),
         Movie(
             id: "876969",
             title: "Assassin Club",
             overview: "In this world of contract killers",
             poster: URL(string: "https://image.tmdb.org/t/p/original/y2d2SBqK33mGOG2CqAYMo3YbWE4.jpg"),
             releaseDate: .now,
             genres: [.thriller]
         ),
         Movie(
             id: "385687",
             title: "Fast X",
             overview: "Over many missions and against",
             poster: URL(string: "https://image.tmdb.org/t/p/original/jwMMQR69Xz9AYtX4u2uYJgfAAev.jpg"),
             releaseDate: .now,
             genres: [.action]
         )
        ]
    }
}

extension MoviesRepository: DependencyKey {
    static var liveValue: MoviesRepository {
        .init()
    }
}

extension DependencyValues {
    var repository: MoviesRepository {
        get { self[MoviesRepository.self] }
        set { self[MoviesRepository.self] = newValue }
    }
}
