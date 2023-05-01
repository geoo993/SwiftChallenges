import Foundation

public typealias HTTPCode = Int
public typealias HTTPCodes = Range<HTTPCode>

extension HTTPCodes {
    static let success = 200 ..< 300
    static let serverError = 401...500
    static let badResponse = 501..<600
}
