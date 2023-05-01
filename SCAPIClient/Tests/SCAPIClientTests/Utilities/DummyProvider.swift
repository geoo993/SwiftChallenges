import Foundation

protocol DummyProviding {
    static func dummy() -> Data
}

extension DummyProviding {
    static func dummy() -> Data {
        let url = Bundle.module.url(forResource: String(describing: self), withExtension: "json")!
        return try! Data(contentsOf: url)
    }
}
