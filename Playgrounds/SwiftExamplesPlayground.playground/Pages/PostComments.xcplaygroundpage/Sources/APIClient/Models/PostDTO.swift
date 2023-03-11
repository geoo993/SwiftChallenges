extension APIClient {
    public struct Post: Decodable {
        public let id: Int
        public let userId: Int
        public let title: String
        public let message: String
        
        enum CodingKeys: String, CodingKey {
            case id, title
            case userId = "user_id"
            case message = "body"
        }
    }
}
