import Foundation

extension APIClient {
    public struct User: Decodable {
        public let id: Int
        public let name: String
        public let dateJoined: Date
        
        enum CodingKeys: String, CodingKey {
            case id, name
            case dateJoined = "joined_date"
        }
    }
}
