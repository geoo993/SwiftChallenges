import SwiftUI

/*
 Redux pattern
 Redux is an architecture in which all of your app’s state lives in one container. The only way to change state is to create a new state based on the current state and a requested change.
 The Store holds all of your app’s state.
 An Action is immutable data that describes a state change.
 A Reducer changes the app’s state using the current state and an action.
 */

protocol ReducerProviding <State, Action> {
    associatedtype State
    associatedtype Action
    
    func reduce(into state: inout State, action: Action) async -> Action?
}

final class Store<State, Action>: ObservableObject {
    @Published private(set) var state: State
    private let reducer: any ReducerProviding<State, Action>
    
    init<R: ReducerProviding>(
        initialState: R.State,
        reducer: R
    ) where R.State == State, R.Action == Action {
        self.state = initialState
        self.reducer = reducer
    }

    @MainActor
    func send(action: Action) async {
        guard let effect = await reducer.reduce(into: &state, action: action) else { return }
        await send(action: effect)
    }
}

// Dependencies and services
struct Dependencies {
    func getProducts() async throws -> [Product] {
        []
    }
}
struct AnalyticsService {
    func trackScreen() {}
    func trackLoadedList() {}
    func trackClick(product: String) {}
}

// Data model or entity
struct Product: Identifiable, Equatable {
    let id: String
    let name: String
    let price: String
}

// Screen creation
struct ProductScreen: ReducerProviding {
    private let dependency: Dependencies
    private let eventTracker: AnalyticsService
    
    init(dependency: Dependencies, eventTracker: AnalyticsService) {
        self.dependency = dependency
        self.eventTracker = eventTracker
    }

    struct State: Equatable {
        var products: LoadingState<[Product]>
        
        init(products: LoadingState<[Product]> = .idle) {
            self.products = products
        }
    }
    
    enum Action: Equatable {
        case didAppear
        case fetchProducts
        case didLoad(Result<[Product], EquatableError>)
        case didTap(Product)
    }
    
    func reduce(into state: inout State, action: Action) async -> Action? {
        switch action {
        case .didAppear:
            state.products = .loading
            eventTracker.trackScreen()
            return .fetchProducts
        case .fetchProducts:
            do {
                let products = try await dependency.getProducts()
                return .didLoad(.success(products))
            } catch {
                return .didLoad(.failure(error.toEquatableError()))
            }
        case let .didLoad(.success(results)):
            eventTracker.trackLoadedList()
            state.products = .loaded(results)
            return .none
        case let .didLoad(.failure(error)):
            state.products = .failed(error)
            return .none
        case let .didTap(product):
            eventTracker.trackClick(product: product.name)
            return .none
        }
    }
}

extension ProductScreen {
    struct ContentView: View {
        @StateObject private var viewStore: Store<State, Action>
        @SwiftUI.State private var currentTask: Action?
        
        init(store: Store<State, Action>) {
            self._viewStore = StateObject(wrappedValue: store)
        }
        
        var body: some View {
            LoadingStateView(state: viewStore.state.products) {
                ListView(products: $0) { action in
                    self.currentTask = action
                }
            }
            .navigationTitle("Product List")
            .task(id: currentTask) {
                guard let action = currentTask else { return }
                await viewStore.send(action: action)
            }
        }
    }
}

extension ProductScreen {
    struct ListView: View {
        let products: [Product]
        let action: (Action) -> Void

        var body: some View {
            ScrollView {
                ForEach(products) { product in
                    Button(action: {
                        action(.didTap(product))
                    }, label: {
                        HStack(spacing: 4) {
                            Text(product.name)
                                .font(.headline)
                                .fontWeight(.medium)
                            Text(product.price)
                        }
                    })
                }
            }
            .onAppear {
                action(.didAppear)
            }
        }
    }
}

// Run in SwiftUI
//ProductScreen.ContentView(
//    store: Store(
//        initialState: .init(),
//        reducer: ProductScreen(
//            dependency: Dependencies(),
//            eventTracker: AnalyticsService()
//        )
//    )
//)
