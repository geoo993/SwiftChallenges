import Foundation

public struct Payload<Data: Decodable>: Decodable, Paging {
    public let results: Data
    public let page: Int

    public init(results: Data, page: Int) {
        self.results = results
        self.page = page
    }
}
