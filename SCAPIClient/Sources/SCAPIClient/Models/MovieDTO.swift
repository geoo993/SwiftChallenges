import Foundation

public struct MovieDTO {
    public let id: Int
    public let title: String
    public let overview: String
    public let posterPath: String
    public let genres: [GenreDTO]
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
        case genres = "genre_ids"
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        title = try container.decode(String.self, forKey: .title)
        overview = try container.decode(String.self, forKey: .overview)
        posterPath = try container.decode(String.self, forKey: .posterPath)
        releaseDate = try container.decode(Date.self, forKey: .releaseDate)
        genres = try container.decode([Int].self, forKey: .genres).compactMap(GenreDTO.init)
    }
}
