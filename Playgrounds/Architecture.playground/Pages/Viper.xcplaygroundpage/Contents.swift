import SwiftUI

/*
 VIPER makes another iteration on the idea of separating responsibilities, and this time we have five layers.
 - Interactor — contains business logic related to the data (Entities) or networking, like creating new instances of entities or fetching them from the server. For those purposes you’ll use some Services and Managers which are not considered as a part of VIPER module but rather an external dependency.
 - Presenter — contains the UI related (but UIKit independent) business logic, invokes methods on the Interactor.
 - Entities — your plain data objects, not the data access layer, because that is a responsibility of the Interactor.
 - Router/Coordinator — responsible for the segues between the VIPER modules.
 */

// Entity
struct Product: Identifiable, Equatable {
    let id: String
    let name: String
    let price: String
}

// Interactor and services
protocol ProductsProvider {
    func get() async throws -> [Product]
}

struct ProductsInteractor: ProductsProvider {
    func get() async throws -> [Product] {
        []
    }
}

struct AnalyticsService {
    func trackScreen() {}
    func trackLoadedList() {}
    func trackClick(product: String) {}
}

// Router
struct ProductRouter {
    enum Path {
        case productDetail(Product)
    }

    func navigate(to path: Path) {}
}

// Presenter
enum Event: Equatable {
    case didAppear
    case fetchProducts
    case didTap(Product)
}

protocol ProductsEventHandler {
    func handle(event: Event) async
}

struct ProductsPresenter: View {
    @State private var products: LoadingState<[Product]> = .idle
    @State private var currentTask: Event?
    let router: ProductRouter
    let interactor: ProductsProvider
    let eventTracker: AnalyticsService

    var body: some View {
        LoadingStateView(state: products) {
            ContentView(products: $0) { event in
                self.currentTask = event
            }
        }
        .navigationTitle("Product List")
        .task(id: currentTask) {
            guard let event = currentTask else { return }
            await handle(event: event)
        }
    }
}

extension ProductsPresenter: ProductsEventHandler {
    func handle(event: Event) async {
        switch event {
        case .didAppear:
            products = .loading
            eventTracker.trackScreen()
        case .fetchProducts:
            do {
                let values = try await interactor.get()
                products = .loaded(values)
                eventTracker.trackLoadedList()
            } catch {
                products = .failed(error.toEquatableError())
            }
        case let .didTap(product):
            eventTracker.trackClick(product: product.name)
            router.navigate(to: .productDetail(product))
        }
    }
}

// View
extension ProductsPresenter {
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

//ProductsPresenter(
//    interactor: ProductsInteractor(),
//    eventTracker: AnalyticsService()
//)
