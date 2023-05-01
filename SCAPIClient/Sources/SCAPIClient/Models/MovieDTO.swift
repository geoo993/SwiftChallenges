import Foundation

public struct MovieDTO {
    public let id: Int
    public let title: String
    public let overview: String
    public let posterPath: String
    public let releaseDate: Date
}

extension MovieDTO: Decodable {
    public var posterUrl: URL? {
        URL(string: "https://image.tmdb.org/t/p/original\(posterPath)")
    }

    enum CodingKeys: String, CodingKey {
        case id, title, overview
        case releaseDate = "release_date"
        case posterPath = "poster_path"
    }
}
