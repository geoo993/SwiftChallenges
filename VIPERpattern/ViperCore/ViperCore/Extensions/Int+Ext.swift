
public extension Int {
    /// Returns a random integer between min and max
    static func random(min: Int, max: Int) -> Int {
        guard min < max else { return min }
        return Int(arc4random_uniform(UInt32(1 + max - min))) + min
    }
    /// Returns a Double
    var d: Double {
        return Double(self)
    }
    /// Returns a Double
    var toDouble: Double {
        return Double(self)
    }
    /// Returns a Float
    var f: Float {
        return Float(self)
    }
    /// Returns a Float
    var toFloat: Float {
        return Float(self)
    }
    /// Returns a CGFloat {
    var toCGFloat: CGFloat {
        return CGFloat(self)
    }
    /// Returns a CGFloat {
    var cg: CGFloat {
        return CGFloat(self)
    }
}
