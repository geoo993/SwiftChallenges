import Foundation

public struct Movie: Equatable, Identifiable {
    public var id: String
    public let title: String
    public let overview: String
    public let poster: URL?
    public let releaseDate: Date
    public let genres: [Genre]
    
    public init(
        id: String,
        title: String,
        overview: String,
        poster: URL?,
        releaseDate: Date,
        genres: [Genre]
    ) {
        self.id = id
        self.title = title
        self.overview = overview
        self.poster = poster
        self.releaseDate = releaseDate
        self.genres = genres
    }
}
