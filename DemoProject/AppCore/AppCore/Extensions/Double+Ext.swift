
public extension Double {
    /// Use `drand48()` to generate floating-point
    static func random(min: Double = 0.0, max: Double = 1.0) -> Double {
        assert(max >= min, "argument max must be greater than argument min")
        let rnd = drand48()
        if min != 0.0 || max != 1.0 {
            return min + (max - min) * rnd
        }
        return rnd
    }
    /// Convert a Double to Int
    var i: Int { // swiftlint:disable:this identifier_name
        return Int(self)
    }
    /// Convert a Double to Int
    var toInt: Int { // swiftlint:disable:this identifier_name
        return Int(self)
    }
    var cg: CGFloat {
        return CGFloat(self)
    }
    var toCGFloat: CGFloat {
        return CGFloat(self)
    }

    func percentageValueBetween(maxValue: Double, minValue: Double = 0) -> Double {
        let difference: Double = (minValue < 0) ? maxValue : maxValue - minValue
        return (Double(100) * ((self - minValue) / difference))
    }
    /// Rounds the double to decimal places value
    func rounded(toPlaces places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }

}
