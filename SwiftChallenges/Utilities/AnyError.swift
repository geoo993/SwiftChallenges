import Foundation

struct AnyError: Error, Equatable {
    let wrappedError: Error

    init<E: Error>(_ wrappedError: E) {
        self.wrappedError = wrappedError
    }

    static func == (lhs: Self, rhs: Self) -> Bool {
        (lhs.wrappedError as NSError) == (rhs.wrappedError as NSError)
    }
}
