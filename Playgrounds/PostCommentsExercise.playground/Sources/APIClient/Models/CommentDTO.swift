extension APIClient {
    public struct Comment: Decodable {
        public let id: Int
        public let postId: Int
        public let message: String
        public let name: String
        
        enum CodingKeys: String, CodingKey {
            case id, name
            case message = "body"
            case postId = "post_id"
        }
    }
}
