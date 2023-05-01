import Foundation

public struct MovieDBPayload<Data: Decodable>: Decodable {
    public let results: Data

    public init(results: Data) {
        self.results = results
    }
}
