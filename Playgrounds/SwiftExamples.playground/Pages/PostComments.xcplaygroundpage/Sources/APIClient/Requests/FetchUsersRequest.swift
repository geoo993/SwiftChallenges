import Foundation

public struct FetchUsersRequest: APIRequest {
    public typealias ResponseObject = [APIClient.User]
    public var type: Resource = .users
    
    public init() {}
}
