public protocol AnalyticScreen {
    var rawValue: String { get }
}

public protocol AnalyticAction {
    var rawValue: String { get }
}

public protocol AnalyticCategory {
    var rawValue: String { get }
}

public protocol AnalyticTracker {
    func track(screen: AnalyticScreen)
    func track(action: AnalyticAction)
}

public class Tacker: AnalyticTracker {
    public var screen: AnalyticScreen?
    public var action: AnalyticAction?
    
    public init(screen: AnalyticScreen? = nil, action: AnalyticAction? = nil) {
        self.screen = screen
        self.action = action
    }
    
    public func track(screen: AnalyticScreen) {
        self.screen = screen
    }
    
    public func track(action: AnalyticAction) {
        self.action = action
    }
}

public struct MoviesAnalytics {
    public enum Screen: String, AnalyticScreen {
        case moviesScreen
    }
    
    public enum Action: String, AnalyticAction {
        case movieSelected
    }
    
    private let tracker: AnalyticTracker

    public init(tracker: AnalyticTracker = Tacker()) {
        self.tracker = tracker
    }
    
    public func track(screen: Screen) {
        tracker.track(screen: screen)
    }
    
    public func track(action: Action, movie: Movie) {
        tracker.track(action: action)
    }
}
