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
    
    enum PriorityLevel: Int, Equatable, CaseIterable {
        case low = 1    // meh
        case medium     // product related
        case high       // required by apple
    }
}

protocol SplashScreenEnginePrioritable {
    var kind: SplashScreen.Kind { get }
    var priorityLevel: SplashScreen.PriorityLevel { get }
    func shouldBecomeActive() -> AnyPublisher<Bool, SplashScreen.Error>
}

// ========================================= Splash screens

struct AppUpdatePriority: SplashScreenEnginePrioritable {
    let kind: SplashScreen.Kind = .appUpdate
    let priorityLevel: SplashScreen.PriorityLevel = .medium
    func shouldBecomeActive() -> AnyPublisher<Bool, SplashScreen.Error> {
//        Fail(error: SplashScreen.Error.other).eraseToAnyPublisher()
        Just(false)
            .setFailureType(to: SplashScreen.Error.self)
            .eraseToAnyPublisher()
    }
}

struct AppReviewPriority: SplashScreenEnginePrioritable {
    let kind: SplashScreen.Kind = .appReview
    let priorityLevel: SplashScreen.PriorityLevel = .low
    func shouldBecomeActive() -> AnyPublisher<Bool, SplashScreen.Error> {
        Just(true)
            .setFailureType(to: SplashScreen.Error.self)
            .eraseToAnyPublisher()
    }
}

struct WelcomeFeaturePriority: SplashScreenEnginePrioritable {
    let kind: SplashScreen.Kind = .welcomeFeature
    let priorityLevel: SplashScreen.PriorityLevel = .medium
    func shouldBecomeActive() -> AnyPublisher<Bool, SplashScreen.Error> {
        Just(true)
            .setFailureType(to: SplashScreen.Error.self)
            .eraseToAnyPublisher()
    }
}

struct AppTrackingTransparancyPriority: SplashScreenEnginePrioritable {
    let kind: SplashScreen.Kind = .appTracking
    let priorityLevel: SplashScreen.PriorityLevel = .high
    func shouldBecomeActive() -> AnyPublisher<Bool, SplashScreen.Error> {
        Just(false)
            .setFailureType(to: SplashScreen.Error.self)
            .eraseToAnyPublisher()
    }
}

struct ApplePayPriority: SplashScreenEnginePrioritable {
    let kind: SplashScreen.Kind = .applePay
    let priorityLevel: SplashScreen.PriorityLevel = .high
    func shouldBecomeActive() -> AnyPublisher<Bool, SplashScreen.Error> {
        Just(false)
            .setFailureType(to: SplashScreen.Error.self)
            .eraseToAnyPublisher()
    }
}

struct NPSPriority: SplashScreenEnginePrioritable {
    let kind: SplashScreen.Kind = .netPromotorScore
    let priorityLevel: SplashScreen.PriorityLevel = .low
    func shouldBecomeActive() -> AnyPublisher<Bool, SplashScreen.Error> {
        Just(true)
            .setFailureType(to: SplashScreen.Error.self)
            .eraseToAnyPublisher()
    }
}

//  ===================================== Engine Algorithm

// 1) check if array has unique kinds, remove any duplicates in kind or ranking
// 2) filter shouldbeactive is true per priority level
// - check if should become active which includes logic checks and/or feature flag checks
// - for example [shouldbeactive, shouldnotbeactive, shouldbeactive], only take the active ones
// 3) check if list of current priority level is isEmpty, if empty go to next priority level
// - continue to check until all priority levels is checked
// 4) sort by ranking
// - high [app-tracking, apple-pay]
// - medium [welcome feature, app-update]
// - low [app-review, nps]
// 5) check if there is more than 2 items, can they be presented during the current app launch

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

func priorityFilter(
    array: [SplashScreenEnginePrioritable],
    filterBy priority: SplashScreen.PriorityLevel
) -> AnyPublisher<[SplashScreenEnginePrioritable], SplashScreen.Error> {
    return Just(array.filter { $0.priorityLevel == priority })
        .setFailureType(to: SplashScreen.Error.self)
        .eraseToAnyPublisher()
}

func highestRanked(
    array: [SplashScreenEnginePrioritable]
) -> AnyPublisher<SplashScreen.Kind, SplashScreen.Error> {
    let sorted = array.sorted { $0.kind < $1.kind }
    let value = sorted.first?.kind ?? .none
    return Just(value)
        .setFailureType(to: SplashScreen.Error.self)
        .eraseToAnyPublisher()
}

typealias ActivePrioritiesCollection = Publishers.Collect<Publishers.MergeMany<AnyPublisher<Bool, SplashScreen.Error>>>
func activePriority(
    from array: [SplashScreenEnginePrioritable],
    filterBy priority: SplashScreen.PriorityLevel
) -> AnyPublisher<[SplashScreenEnginePrioritable], SplashScreen.Error> {
    guard array.contains(where: { $0.priorityLevel == priority }) else {
        return Just(array)
            .setFailureType(to: SplashScreen.Error.self)
            .eraseToAnyPublisher()
    }
    let priorityFilter = priorityFilter(array: array, filterBy: priority)
    return priorityFilter
        .flatMap { value -> ActivePrioritiesCollection in
            let collection = value.map{ $0.shouldBecomeActive() }
            return Publishers.MergeMany(collection).collect()
        }
        .zip(priorityFilter)
        .flatMap { (collection, list) -> Future<[SplashScreenEnginePrioritable], SplashScreen.Error> in
            return Future { promise in
                let result = zip(collection, list)
                    .filter { $0.0 }
                    .map { $0.1 }
                if result.isEmpty {
                    let ignoreCurrentPriority = array
                        .filter { $0.priorityLevel != priority }
                    promise(.success(ignoreCurrentPriority))
                } else {
                    promise(.success(result))
                }
            }
        }.eraseToAnyPublisher()
}


func checkHighestPriority(
    array: [SplashScreenEnginePrioritable]
) -> AnyPublisher<[SplashScreenEnginePrioritable], SplashScreen.Error> {
    array.forEach({ print("In High Territory", $0.kind)})
    return activePriority(from: array, filterBy: .high)
}

func checkMediumPriority(
    array: [SplashScreenEnginePrioritable]
) -> AnyPublisher<[SplashScreenEnginePrioritable], SplashScreen.Error> {
    array.forEach({ print("In Medium Territory", $0.kind)})
    return activePriority(from: array, filterBy: .medium)
}

func checkLowestPriority(
    array: [SplashScreenEnginePrioritable]
) -> AnyPublisher<[SplashScreenEnginePrioritable], SplashScreen.Error> {
    array.forEach({ print("In Low Territory", $0.kind)})
    return activePriority(from: array, filterBy: .low)
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
    .flatMap(checkHighestPriority)
    .flatMap(checkMediumPriority)
    .flatMap(checkLowestPriority)
    .flatMap(highestRanked)
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

