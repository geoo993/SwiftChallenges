import Foundation

public struct FetchCommentsRequest: APIRequest {
    public typealias ResponseObject = [APIClient.Comment]
    public var type: Resource = .comments
    
    public init() {}
}
