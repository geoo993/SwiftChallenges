//: [Previous](@previous)

import SwiftUI

/*
MVVM - separates objects into 3 types, Models, Views and View Models. Controllers still do exist in MVVM, but they aren't the main focus of the pattern, instead, View Models are. So instead of a controller owning models directly, it now owns View Models and the View Models will run the Models. This allows View Models to act as an intermediary to the Models and perform a critical role such as, transforming Model data into a View representation.
MVVM-C - is the Model View ViewModel design pattern, combined with C which is the coordinator pattern.
Coordinator pattern - is a pattern that help manage app navigation, it provides an encapsulation of navigation logic and enables reusability. Essentially it’s a pattern for organising flow logic between view controllers. We use this pattern to decouple view controllers from one another. The only component that knows about view controllers directly is the coordinator. Consequently, view controllers are much more reusable. If you want to create a new flow within your app, you simply create a new coordinator!
*/

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

// Model (also entity)
struct Product: Identifiable, Equatable {
    let id: String
    let name: String
    let price: String
}

// Screen creation
struct ProductScreen {
    enum Event: Equatable {
        case didAppear
        case fetchProducts
        case didTap(Product)
    }

    @StateObject private var viewModel: ViewModel
    @State private var currentTask: Event?
    
    init(viewModel: ViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        LoadingStateView(state: viewModel.state) {
            ContentView(products: $0) { action in
                self.currentTask = action
            }
        }
        .navigationTitle("Product List")
        .task(id: currentTask) {
            guard let event = currentTask else { return }
            await viewModel.handle(event)
        }
    }
}

extension ProductScreen {
    final class ViewModel: ObservableObject {
        @Published private(set) var state: LoadingState<[Product]> = .idle
        private let dependency: Dependencies
        private let eventTracker: AnalyticsService
        
        init(
            dependency: Dependencies,
            eventTracker: AnalyticsService
        ) {
            self.dependency = dependency
            self.eventTracker = eventTracker
        }

        func handle(_ event: Event) async {
            switch event {
            case .didAppear:
                state = .loading
                eventTracker.trackScreen()
            case .fetchProducts:
                do {
                    let products = try await dependency.getProducts()
                    state = .loaded(products)
                    eventTracker.trackLoadedList()
                } catch {
                    state = .failed(error.toEquatableError())
                }
            case let .didTap(product):
                eventTracker.trackClick(product: product.name)
            }
        }
    }
}

extension ProductScreen {
    struct ContentView: View {
        let products: [Product]
        let action: (Event) -> Void

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
// ProductScreen(viewModel: .init(dependency: .init(), eventTracker: .init()))
