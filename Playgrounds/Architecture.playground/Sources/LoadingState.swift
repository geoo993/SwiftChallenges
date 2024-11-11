import SwiftUI

public struct EquatableError: Error, Equatable, CustomStringConvertible {
    private let base: Error
    private let equals: (Error) -> Bool

    public init<Base: Error>(_ base: Base) {
        self.base = base
        self.equals = { String(reflecting: $0) == String(reflecting: base) }
    }

    public init<Base: Error & Equatable>(_ base: Base) {
        self.base = base
        self.equals = { ($0 as? Base) == base }
    }

    public static func ==(lhs: EquatableError, rhs: EquatableError) -> Bool {
        lhs.equals(rhs.base)
    }

    public var description: String {
        "\(self.base)"
    }

    public func asError<Base: Error>(type: Base.Type) -> Base? {
        self.base as? Base
    }

    public var localizedDescription: String {
        self.base.localizedDescription
    }
}

public extension Error {
    func toEquatableError() -> EquatableError {
        EquatableError(self)
    }
}

public enum LoadingState<Value: Equatable>: Equatable {
    case idle
    case loading
    case loaded(Value)
    case failed(EquatableError)
}

public struct LoadingStateView<Value: Equatable, Content: View>: View {

    private var state: LoadingState<Value>
    @ViewBuilder private var contentView: (Value) -> Content
    
    public init(state: LoadingState<Value>, contentView: @escaping (Value) -> Content) {
        self.state = state
        self.contentView = contentView
    }

    public var body: some View {
        switch state {
        case .idle:
            Color.clear
        case .loading:
            ProgressView().progressViewStyle(.circular)
        case .loaded(let entity):
            contentView(entity)
        case .failed(let error):
            Text(error.localizedDescription)
        }
    }
}
