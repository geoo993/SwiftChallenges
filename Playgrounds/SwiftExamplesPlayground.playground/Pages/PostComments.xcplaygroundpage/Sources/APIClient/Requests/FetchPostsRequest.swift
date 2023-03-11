import Foundation

public struct FetchPostsRequest: APIRequest {
    public typealias ResponseObject = [APIClient.Post]
    public var type: Resource = .posts
    
    public init() {}
}
