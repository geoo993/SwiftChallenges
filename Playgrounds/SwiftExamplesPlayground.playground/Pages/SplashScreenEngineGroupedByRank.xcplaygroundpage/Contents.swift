import Foundation
import Combine

enum SplashScreen {
    // we want to make sure all error from each splash screen is captured
    enum Error: Swift.Error {
        case duplication
        case other
    }
    
    enum Kind: Int, Hashable {
        case appTracking = 1
        case applePay
        case welcomeFeature
        case appUpdate
        case appReview
        case netPromotorScore
        case none
        
        var ranking: Int {
            rawValue
        }
        
        static func <(lhs: Self, rhs: Self) -> Bool {
            return lhs.ranking < rhs.ranking
        }
    }
}

protocol SplashScreenEnginePrioritable {
    var kind: SplashScreen.Kind { get }
    func shouldBecomeActive() -> AnyPublisher<Bool, SplashScreen.Error>
}

// ========================================= Splash screens

struct AppUpdatePriority: SplashScreenEnginePrioritable {
    let kind: SplashScreen.Kind = .appUpdate
    func shouldBecomeActive() -> AnyPublisher<Bool, SplashScreen.Error> {
//        Fail(error: SplashScreen.Error.other).eraseToAnyPublisher()
        Just(false)
            .setFailureType(to: SplashScreen.Error.self)
            .eraseToAnyPublisher()
    }
}

struct AppReviewPriority: SplashScreenEnginePrioritable {
    let kind: SplashScreen.Kind = .appReview
    func shouldBecomeActive() -> AnyPublisher<Bool, SplashScreen.Error> {
        Just(true)
            .setFailureType(to: SplashScreen.Error.self)
            .eraseToAnyPublisher()
    }
}

struct WelcomeFeaturePriority: SplashScreenEnginePrioritable {
    let kind: SplashScreen.Kind = .welcomeFeature
    func shouldBecomeActive() -> AnyPublisher<Bool, SplashScreen.Error> {
        Just(false)
            .setFailureType(to: SplashScreen.Error.self)
            .eraseToAnyPublisher()
    }
}

struct AppTrackingTransparancyPriority: SplashScreenEnginePrioritable {
    let kind: SplashScreen.Kind = .appTracking
    func shouldBecomeActive() -> AnyPublisher<Bool, SplashScreen.Error> {
        Just(false)
            .setFailureType(to: SplashScreen.Error.self)
            .eraseToAnyPublisher()
    }
}

struct ApplePayPriority: SplashScreenEnginePrioritable {
    let kind: SplashScreen.Kind = .applePay
    func shouldBecomeActive() -> AnyPublisher<Bool, SplashScreen.Error> {
        Just(false)
            .setFailureType(to: SplashScreen.Error.self)
            .eraseToAnyPublisher()
    }
}

struct NPSPriority: SplashScreenEnginePrioritable {
    let kind: SplashScreen.Kind = .netPromotorScore
    func shouldBecomeActive() -> AnyPublisher<Bool, SplashScreen.Error> {
        Just(true)
            .setFailureType(to: SplashScreen.Error.self)
            .eraseToAnyPublisher()
    }
}


//  ===================================== Engine Algorithm

// 1) check if array has unique kinds, remove any duplicates in kind or ranking
// 2) sort the array by ranking
// - app-tracking
// - apple-pay
// - welcome feature
// - app-update
// - app-review
// - nps
// 3) conduct a one by one check of shouldbeactive of all items and exit on the first element that returns true

extension Publishers {
    struct LatestPriority: Publisher {
        typealias Output = SplashScreenEnginePrioritable
        typealias Failure = SplashScreen.Error

        private let values: [SplashScreenEnginePrioritable]

        init(values: [SplashScreenEnginePrioritable]) {
            self.values = values
        }

        func receive<S: Subscriber>(subscriber: S) where Failure == S.Failure, Output == S.Input {
            let subcription = Subscription(values: values, subscriber: subscriber)
            subscriber.receive(subscription: subcription)
        }
    }
}

extension Publishers.LatestPriority {
    final class Subscription<S: Subscriber>: Combine.Subscription where S.Input == Output, S.Failure == Failure {
        private let values: [SplashScreenEnginePrioritable]
        private var subscriber: S?
        private var index: Int?
        private var cancellable = Set<AnyCancellable>()
        
        init(values: [SplashScreenEnginePrioritable], subscriber: S) {
            self.values = values
            self.subscriber = subscriber
        }
        
        func request(_ demand: Subscribers.Demand) {
            findActiveSplashScreen()
        }
        
        func cancel() {
            cancellable.removeAll()
            subscriber = nil
            index = nil
        }
        
        private func nextIndex(for index: Int?) -> Int? {
            if let index = index, index < values.count - 1 {
                return index + 1
            } else if index == nil, !values.isEmpty {
                return 0
            }
            return nil
        }

        private func findActiveSplashScreen() {
            Swift.print()
            guard let subscriber = subscriber else { return }
            guard let index = nextIndex(for: self.index) else {
                subscriber.receive(completion: .finished)
                return
            }
            Swift.print("checking the priorities of item at index:", index)
            self.index = index
            let currentValue = values[index]
            var didFindValue = false
            currentValue.shouldBecomeActive()
                .sink(receiveCompletion: { result in
                    switch result {
                    case .finished where didFindValue:
                        Swift.print("finished in completion of", index)
                        subscriber.receive(completion: .finished)
                    case let .failure(error):
                        Swift.print("found an error in completion of", index)
                        subscriber.receive(completion: .failure(error))
                    default: break
                    }
                }, receiveValue: { [weak self] shouldBecomeActive in
                    if shouldBecomeActive {
                        Swift.print("I found the value of", index)
                        didFindValue = true
                        subscriber.receive(currentValue)
                    } else {
                        Swift.print("I did not find the value of", index)
                        self?.findActiveSplashScreen()
                    }
                })
                .store(in: &cancellable)
        }
    }
}

func hasDuplicates(
    array: [SplashScreenEnginePrioritable]
) -> AnyPublisher<[SplashScreenEnginePrioritable], SplashScreen.Error> {
    let groups = Dictionary(grouping: array, by: { $0.kind })
    if groups.contains(where: { $1.count > 1 }) {
        return Fail(error: SplashScreen.Error.duplication).eraseToAnyPublisher()
    }
    return Just(array)
        .setFailureType(to: SplashScreen.Error.self)
        .eraseToAnyPublisher()
}

func sortByHighestRanked(
    array: [SplashScreenEnginePrioritable]
) -> AnyPublisher<[SplashScreenEnginePrioritable], SplashScreen.Error> {
    let sorted = array.sorted { $0.kind < $1.kind }
    return Just(sorted)
        .setFailureType(to: SplashScreen.Error.self)
        .eraseToAnyPublisher()
}

func highestActivePriority(
    from array: [SplashScreenEnginePrioritable]
) -> AnyPublisher<SplashScreen.Kind, SplashScreen.Error> {
    array.forEach({ print($0.kind, " with ranking:", $0.kind.ranking) })
    return Publishers.LatestPriority(values: array)
        .map { $0.kind }
        .eraseToAnyPublisher()
}

// ======================================== Testing
var cancellables: Set<AnyCancellable> = []

let strategiesArray: [SplashScreenEnginePrioritable] = [
    AppTrackingTransparancyPriority(),
    ApplePayPriority(),
    AppUpdatePriority(),
    AppReviewPriority(),
//    AppReviewPriority(),
    WelcomeFeaturePriority(),
    NPSPriority()
]
print(strategiesArray.count)

let findNextSplashScreen: AnyPublisher<SplashScreen.Kind, SplashScreen.Error> = Just(strategiesArray)
    .flatMap(hasDuplicates)
    .flatMap(sortByHighestRanked)
    .flatMap(highestActivePriority)
    .eraseToAnyPublisher()

findNextSplashScreen
    .handleEvents(receiveOutput: { _ in
        print()
    })
    .sink { value in
        print("Completion:", value)
    } receiveValue: { value in
        print("SELECTED KIND:", value)
    }.store(in: &cancellables)

