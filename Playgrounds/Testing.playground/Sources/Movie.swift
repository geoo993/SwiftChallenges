import Foundation

public enum Genre: String, Identifiable, Sendable {
    case action = "Action"
    case adventure = "Adventure"
    case animation = "Animation"
    case comedy = "Comedy"
    case crime = "Crime"
    case documentary = "Documentary"
    case drama = "Drama"
    case family = "Family"
    case fantasy = "Fantasy"
    case history = "History"
    case horror = "Horror"
    case music = "Music"
    case mystery = "Mystery"
    case romance = "Romance"
    case scifi = "Science Fiction"
    case thriller = "Thriller"
    case war = "War"
    
    public var id: String {
        rawValue
    }
}

public struct Movie: Equatable, Identifiable, Sendable {
    public var id: String
    public let title: String
    public let overview: String
    public let genres: [Genre]
    
    public init(
        id: String,
        title: String,
        overview: String,
        genres: [Genre]
    ) {
        self.id = id
        self.title = title
        self.overview = overview
        self.genres = genres
    }
}
