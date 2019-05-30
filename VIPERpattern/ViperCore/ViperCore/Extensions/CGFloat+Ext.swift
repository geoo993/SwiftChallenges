public extension FloatingPoint {
    var toRadians: Self { return self * .pi / 180 }
    var toDegrees: Self { return self * 180 / .pi }
}

public extension CGFloat {
    var toInt: Int {
        return Int(self)
    }
    var toFloat: Float {
        return Float(self)
    }
    var toDouble: Double {
        return Double(self)
    }
    func round(to places: Int) -> CGFloat {
        let divisor = pow(10.0, CGFloat(places))
        return Darwin.round(self * divisor) / divisor
    }

    static func rand() -> CGFloat {
        return CGFloat(arc4random()) / CGFloat(UInt32.max)
    }

    static func random(min: CGFloat, max: CGFloat) -> CGFloat {
        let rand = CGFloat(arc4random()) / CGFloat(UINT32_MAX)
        let minimum = min < max ? min : max
        return rand * Swift.abs(CGFloat(min - max)) + minimum
    }

    static func clamp(value: CGFloat, minimum: CGFloat, maximum: CGFloat) -> CGFloat {
        if value < minimum { return minimum }
        if value > maximum { return maximum }
        return value
    }

    func percentageValueBetween(maxValue: CGFloat, minValue: CGFloat = 0) -> CGFloat {
        let difference: CGFloat = (minValue < 0) ? maxValue : maxValue - minValue
        return (CGFloat(100) * ((self - minValue) / difference))
    }

    func value(with percentage : CGFloat, minValue : CGFloat = 0) -> CGFloat {
        let max = (self > minValue) ? self : minValue
        let min = (self > minValue) ? minValue : self

        return ( ((max - min) * percentage) / CGFloat(100) ) + min
    }

}
