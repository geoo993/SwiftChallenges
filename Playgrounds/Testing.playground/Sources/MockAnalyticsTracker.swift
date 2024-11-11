import Foundation

public class MockAnalyticsTracker: AnalyticTracker {
    public var values: [String] = []
    
    public init() {}
    
    public func track(screen: AnalyticScreen) {
        values.append(screen.rawValue)
    }
    
    public func track(action: AnalyticAction) {
        values.append(action.rawValue)
    }
}
