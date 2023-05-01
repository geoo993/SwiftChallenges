import Foundation

public struct Movie: Identifiable {
    public var id: String
    public let title: String
    public let overview: String
    public let poster: URL?
    public let releaseDate: Date
    
    public init(
        id: String,
        title: String,
        overview: String,
        poster: URL?,
        releaseDate: Date
    ) {
        self.id = id
        self.title = title
        self.overview = overview
        self.poster = poster
        self.releaseDate = releaseDate
    }
}
