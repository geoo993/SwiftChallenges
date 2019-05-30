
extension Comparable {
    public func max(with value: Self) -> Self {
        if value > self {
            return value
        }
        return self
    }

    public func min(with value: Self) -> Self {
        if value < self {
            return value
        }
        return self
    }

    public func clamped(to range: ClosedRange<Self>) -> Self {
        return Swift.max(range.lowerBound, Swift.min(self, range.upperBound))
    }
}
