import Foundation

enum Loading<T: Equatable>: Equatable {
    case idle
    case error(AnyError)
    case loading(previous: T? = nil)
    case loaded(T)

    var error: AnyError? {
        guard case let .error(error) = self else { return nil }
        return error
    }

    var loaded: T? {
        guard case let .loaded(value) = self else { return nil }
        return value
    }

    var isLoading: Bool {
        guard case .loading = self else { return false }
        return true
    }

    static func == (lhs: Loading<T>, rhs: Loading<T>) -> Bool {
        switch (lhs, rhs) {
        case (.idle, .idle):
            return true
        case let (.error(lhs), .error(rhs)):
            return lhs == rhs
        case let (.loading(lhs), .loading(rhs)):
            return lhs == rhs
        case let (.loaded(lhs), .loaded(rhs)):
            return lhs == rhs
        case (.loaded, _),
             (.loading, _),
             (.error, _),
             (.idle, _):
            return false
        }
    }
}
