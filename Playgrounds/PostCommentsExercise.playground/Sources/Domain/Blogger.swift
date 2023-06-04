import Foundation

public struct Comment {
    public let id: Int
    public let message: String
    public let name: String
    
    public init(
        id: Int,
        message: String,
        name: String
    ) {
        self.id = id
        self.message = message
        self.name = name
    }
}

public struct Post {
    public let id: Int
    public let title: String
    public let message: String
    public let commnets: [Comment]
    
    public init(
        id: Int,
        title: String,
        message: String,
        commnets: [Comment]
    ) {
        self.id = id
        self.title = title
        self.message = message
        self.commnets = commnets
    }
}

public struct User {
    public let id: Int
    public let name: String
    public let dateJoined: Date
    public let posts: [Post]
    
    public init(
        id: Int,
        name: String,
        dateJoined: Date,
        posts: [Post]
    ) {
        self.id = id
        self.name = name
        self.dateJoined = dateJoined
        self.posts = posts
    }
}

extension User {
    public var dateJoinedFormatted: String {
        DateFormatter.short().string(from: dateJoined)
    }
}

public struct Blogger {
    public let user: User
    
    public init(user: User) {
        self.user = user
    }
}

extension Blogger {
    public var totalCommentsInPosts: Int {
        user.posts.reduce(0) { $0 + $1.commnets.count }
    }

    public var averageNumberOfCommentsPerPost: Double {
        let totalComments = totalCommentsInPosts
        if totalComments <= 0 { return 0 }
        return Double(totalComments) / Double(user.posts.count)
    }
}
