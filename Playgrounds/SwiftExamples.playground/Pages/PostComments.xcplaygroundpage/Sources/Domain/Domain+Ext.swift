import Foundation

extension Comment {
    public init(model: APIClient.Comment) {
        self.init(
            id: model.id,
            message: model.message,
            name: model.name
        )
    }
}

extension Post {
    public init(model: APIClient.Post, comments: [Comment]) {
        self.init(
            id: model.id,
            title: model.title,
            message: model.message,
            commnets: comments
        )
    }
}
