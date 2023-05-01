import Foundation

public enum APIError: Swift.Error, Equatable {
    case unknown
    case invalidUrl
    case invalidUrlComponent
    case serverError
    case responseError(HTTPCode)

    public var localizedDescription: String {
        switch self {
        case .unknown: return "Unknown"
        case .serverError: return "Invalid request to server"
        case .invalidUrl: return "We encounted an error with the url"
        case .invalidUrlComponent: return "We encountered an error with the url component"
        case .responseError(let statusCode): return "We had an error with response with status code \(statusCode)"
        }
    }
}

extension APIError {
    public static func == (lhs: Self, rhs: Self) -> Bool {
        switch (lhs, rhs) {
        case (.unknown, .unknown),
            (.serverError, .serverError),
            (.invalidUrl, .invalidUrl),
            (.invalidUrlComponent, .invalidUrlComponent):
            return true
        case (.responseError(let left), .responseError(let right)):
            return left == right
        default:
            return false
        }
    }
}
