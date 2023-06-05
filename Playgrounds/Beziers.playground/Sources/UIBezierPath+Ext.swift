// based on https://github.com/ImJCabus/UIBezierPath-Length
// https://stackoverflow.com/questions/3051760/how-to-get-a-list-of-points-from-a-uibezierpath
// https://stackoverflow.com/questions/12992462/how-to-get-the-cgpoints-of-a-cgpath
// http://www.swiftexample.info/search/bezier-curve-linear-interpolation/3
// https://andreygordeev.com/2017/03/13/uibezierpath-closest-point/
// https://digitalleaves.com/wp-content/uploads/2015/07/B%C3%A9zier_4_big.gif
// https://github.com/louisdh/bezierpath-length/blob/master/Source/BezierPath%2BLength.swift
// swiftlint:disable identifier_name large_tuple file_length

import UIKit
import MapKit

/// General ordinal key
let NumberFormatterOrdinalKey = "ordinal"
/// General spell out key
let NumberFormatterSpellOutKey = "spellout"
/// General distance key
let NumberFormatterDistanceKey = "distance"

// MARK: Mass number formatter keys

/// Mass generic key
let MassFormatterGenericKey = "mass_generic"
/// Mass person key
let MassFormatterPersonKey = "mass_person"

/**
 *  Decimals formatting enum
 */
public enum Decimals: Int, NumberFormatter, NumberFormatterCustomLocaleAvailable {
    /// No decimal numbers.
    case none = 0
    /// 1 decimal numbers.
    case one = 1
    /// 2 decimal numbers.
    case two = 2
    /// 3 decimal numbers.
    case three = 3
    /// 4 decimal numbers.
    case four = 4
    /// 5 decimal numbers.
    case five = 5
    /// 6 decimal numbers.
    case six = 6
    /// 7 decimal numbers.
    case seven = 7
    /// 8 decimal numbers.
    case eight = 8
    /// 9 decimal numbers.
    case nine = 9

    /// Modifier
    public var modifier: String {
        return String(rawValue)
    }

    /// Type enum
    public var type: NumberFormatterType {
        return .decimal
    }

    /// NSNumberFormatter style
    public var style: Foundation.NumberFormatter.Style? {
        return .decimal
    }
}

/**
 Number formatter types

 - Currency: Currency formatter.
 - Decimal:  Number of decimal places formatter.
 - General: Type containing ordinal, spell out and distance formatters (meters to local).
 */
public enum NumberFormatterType {
    case currency
    case decimal
    case general
    case mass
}

/**
 *  Number formatter protocol. Consists of a string modifier and a type enum.
 */
public protocol NumberFormatter {
    var modifier: String { get }
    var type: NumberFormatterType { get }
    var style: Foundation.NumberFormatter.Style? { get }
}

public protocol NumberFormatterCustomLocaleAvailable: NumberFormatter {}

/// Number format class
open class NumberFormat {
    static let sharedInstance = NumberFormat()

    var nsFormatter = Foundation.NumberFormatter()

    let distanceFormatter = MKDistanceFormatter()

    let massFormatter = MassFormatter()

    open func format(_ number: NSNumber, formatter: NumberFormatter) -> String {
        if let customLocaleFormatter = formatter as? NumberFormatterCustomLocaleAvailable {
            return format(number, formatter: customLocaleFormatter, locale: Locale.current)
        } else {
            return defaultLocaleOnlyFormat(number, formatter: formatter)
        }
    }

    /**
     Number formatting function for formatters that accept custom locales. Inits the NSFormatter again if style changes.

     - parameter number:    number to format as an NSNumber.
     - parameter formatter: the formatter to be applied, conforms to NumberFormatter protocol.
     - parameter locale:    locale to use.

     - returns: formatted string.
     */
    open func format(_ number: NSNumber, formatter: NumberFormatterCustomLocaleAvailable, locale: Locale) -> String {
        if let style = formatter.style, nsFormatter.numberStyle != style {
            nsFormatter = Foundation.NumberFormatter()
            nsFormatter.numberStyle = style
        }
        nsFormatter.locale = locale
        distanceFormatter.locale = locale

        var formattedString: String?
        if formatter.type == .decimal {
            if let modifierAsInt = Int(formatter.modifier) {
                nsFormatter.maximumFractionDigits = modifierAsInt
                nsFormatter.minimumFractionDigits = modifierAsInt
            }
            formattedString = nsFormatter.string(from: number)
        }
        if formatter.type == .currency {
            nsFormatter.currencyCode = formatter.modifier
            formattedString = nsFormatter.string(from: number)
        }
        if formatter.type == .general {
            if formatter.modifier == NumberFormatterOrdinalKey {
                formattedString = nsFormatter.string(from: NSNumber(value: floor(number.doubleValue)))
            } else if formatter.modifier == NumberFormatterSpellOutKey {
                formattedString = nsFormatter.string(from: number)
            } else if formatter.modifier == NumberFormatterDistanceKey {
                let distance = number as! CLLocationDistance
                formattedString = distanceFormatter.string(fromDistance: distance)
            }
        }
        guard let finalString = formattedString else {
            return ""
        }
        return finalString
    }

    internal func defaultLocaleOnlyFormat(_ number: NSNumber, formatter: NumberFormatter) -> String {
        var formattedString: String?
        if formatter.type == .mass {
            massFormatter.isForPersonMassUse = (formatter.modifier == MassFormatterPersonKey)
            formattedString = massFormatter.string(fromKilograms: number.doubleValue)
        }
        guard let finalString = formattedString else {
            return ""
        }
        return finalString
    }
}

extension CGPathElementType: CustomStringConvertible {
    public var description: String {
        switch self {
        case .moveToPoint: return "moveToPoint"
        case .addLineToPoint: return "addLineToPoint"
        case .addQuadCurveToPoint: return "addQuadCurveToPoint"
        case .addCurveToPoint: return "addCurveToPoint"
        case .closeSubpath: return "closeSubpath"
        @unknown default:
            fatalError()
        }
    }
}

public struct BezierSubpath: CustomStringConvertible {
    public var startPoint: CGPoint = CGPoint.zero
    public var controlPoint1: CGPoint = CGPoint.zero
    public var controlPoint2: CGPoint = CGPoint.zero
    public var endPoint: CGPoint = CGPoint.zero
    public var length: CGFloat = 0.0
    public var type: CGPathElementType = CGPathElementType(rawValue: 0)!

    public var description: String {
        switch type {
        case .moveToPoint:
            return "MoveTo(\(endPoint.format(Decimals.one))"
        case .addLineToPoint:
            return "AddLine(from: \(startPoint.format(Decimals.one)), to: \(endPoint.format(Decimals.one)))"
        case .addQuadCurveToPoint:
            return """
            AddQuadCurve(from: \(startPoint.format(Decimals.one)),
            control: \(controlPoint1.format(Decimals.one)),
            to: \(endPoint.format(Decimals.one)))
            """
        case .addCurveToPoint:
            return """
            AddCubicCurve(from: \(startPoint.format(Decimals.one)), \
            control1: \(controlPoint1.format(Decimals.one)), \
            control2: \(controlPoint2.format(Decimals.one)), \
            to: \(endPoint.format(Decimals.one)))
            """
        case .closeSubpath:
            return "ClosePath(from: \(startPoint.format(Decimals.one)), to: \(endPoint.format(Decimals.one))"
        @unknown default:
            fatalError()
        }
    }
}

public extension UIBezierPath {

    // MARK: - Math helpers

    static func linearLineLength(fromPoint: CGPoint, toPoint: CGPoint) -> CGFloat {
        return CGFloat(sqrtf(powf(Float(toPoint.x - fromPoint.x), 2) + powf(Float(toPoint.y - fromPoint.y), 2)))
    }

    static func linearBezierPoint(t: Float, start: CGPoint, end: CGPoint) -> CGPoint {
        let dx: CGFloat = end.x - start.x
        let dy: CGFloat = end.y - start.y
        let px: CGFloat = start.x + (CGFloat(t) * dx)
        let py: CGFloat = start.y + (CGFloat(t) * dy)
        return CGPoint(x: px, y: py)
    }

    static func cubicBezierCurveFactors(t: CGFloat) -> (CGFloat, CGFloat, CGFloat, CGFloat) {
        let t1 = pow(1.0 - t, 3.0)
        let t2 = 3.0 * pow(1.0 - t, 2.0) * t
        let t3 = 3.0 * (1.0 - t) * pow(t, 2.0)
        let t4 = pow(t, 3.0)

        return (t1, t2, t3, t4)
    }

    static func quadBezierCurveFactors(t: CGFloat) -> (CGFloat, CGFloat, CGFloat) {
        let t1 = pow(1.0 - t, 2.0)
        let t2 = 2.0 * (1 - t) * t
        let t3 = pow(t, 2.0)

        return (t1, t2, t3)
    }

    // Quadratic Bezier Curve
    static func bezierCurvef(with t: CGFloat, p0: CGFloat, c1: CGFloat, p1: CGFloat) -> CGFloat {
        let factors = UIBezierPath.quadBezierCurveFactors(t: t)
        return (factors.0 * p0) + (factors.1 * c1) + (factors.2 * p1)
    }

    // Quadratic Bezier Curve
    static func bezierCurve(with t: CGFloat, p0: CGPoint, c1: CGPoint, p1: CGPoint) -> CGPoint {
        let x = UIBezierPath.bezierCurvef(with: t, p0: p0.x, c1: c1.x, p1: p1.x)
        let y = UIBezierPath.bezierCurvef(with: t, p0: p0.y, c1: c1.y, p1: p1.y)
        return CGPoint(x: x, y: y)
    }

    // Cubic Bezier Curve
    static func bezierCurvef(with t: CGFloat, p0: CGFloat, c1: CGFloat, c2: CGFloat, p1: CGFloat) -> CGFloat {
        let factors = UIBezierPath.cubicBezierCurveFactors(t: t)
        return (factors.0 * p0) + (factors.1 * c1) + (factors.2 * c2) + (factors.3 * p1)
    }

    // Cubic Bezier Curve
    static func bezierCurve(with t: CGFloat, p0: CGPoint, c1: CGPoint, c2: CGPoint, p1: CGPoint) -> CGPoint {
        let x = UIBezierPath.bezierCurvef(with: t, p0: p0.x, c1: c1.x, c2: c2.x, p1: p1.x)
        let y = UIBezierPath.bezierCurvef(with: t, p0: p0.y, c1: c1.y, c2: c2.y, p1: p1.y)
        return CGPoint(x: x, y: y)
    }

    // Cubic Bezier Curve Length
    static func bezierCurveLength(p0: CGPoint, c1: CGPoint, c2: CGPoint, p1: CGPoint) -> CGFloat {
        let steps = 12 // on greater samples, more presicion

        var current = p0
        var previous = p0
        var length: CGFloat = 0.0

        for i in 1 ... steps {
            let t = CGFloat(i) / CGFloat(steps)
            current = UIBezierPath.bezierCurve(with: t, p0: p0, c1: c1, c2: c2, p1: p1)
            length += previous.distance(to: current)
            previous = current
        }

        return length
    }

    // Quadratic Bezier Curve Length
    static func bezierCurveLength(p0: CGPoint, c1: CGPoint, p1: CGPoint) -> CGFloat {
        let steps = 12 // on greater samples, more presicion

        var current = p0
        var previous = p0
        var length: CGFloat = 0.0

        for i in 1 ... steps {
            let t = CGFloat(i) / CGFloat(steps)
            current = UIBezierPath.bezierCurve(with: t, p0: p0, c1: c1, p1: p1)
            length += previous.distance(to: current)
            previous = current
        }
        return length
    }

    /*  Cubic Bezier Curve
     *  http://ericasadun.com/2013/03/25/calculating-bezier-points/
     */
    static func cubicBezier(t: Float, start: Float, c1: Float, c2: Float, end: Float) -> Float {
        let t_ = CGFloat((1.0 - t))
        let tt_: CGFloat = t_ * t_
        let ttt_: CGFloat = t_ * t_ * t_
        let tt = CGFloat(t * t)
        let ttt = CGFloat(t * t * t)
        let offset: CGFloat = 3.0
        let t1 = CGFloat(start) * ttt_
        let t2 = offset * CGFloat(c1) * tt_ * CGFloat(t)
        let t3 = offset * CGFloat(c2) * t_ * tt
        let t4 = CGFloat(end) * ttt

        return Float(t1 + t2 + t3 + t4)
    }

    static func cubicBezierPoint(t: Float, start: CGPoint, c1: CGPoint, c2: CGPoint, end: CGPoint) -> CGPoint {
        let x: Float = UIBezierPath.cubicBezier(t: t, start: Float(start.x),
                                                c1: Float(c1.x), c2: Float(c2.x), end: Float(end.x))
        let y: Float = UIBezierPath.cubicBezier(t: t, start: Float(start.y),
                                                c1: Float(c1.y), c2: Float(c2.y), end: Float(end.y))
        return CGPoint(x: CGFloat(x), y: CGFloat(y))
    }

    // Cubic Bezier Curve Length
    static func cubicCurveLength(fromPoint: CGPoint, toPoint: CGPoint, controlPoint1: CGPoint, controlPoint2: CGPoint)
        -> CGFloat {
        let iterations: Int = 100
        var length: CGFloat = 0
        for idx in 0 ..< iterations {
            let t = Float(idx) * Float(1.0 / Float(iterations))
            let tt: Float = t + Float(1.0 / Float(iterations))
            let p: CGPoint = UIBezierPath.cubicBezierPoint(t: t, start: fromPoint,
                                                           c1: controlPoint1, c2: controlPoint2, end: toPoint)
            let pp: CGPoint = UIBezierPath.cubicBezierPoint(t: tt, start: fromPoint,
                                                            c1: controlPoint1, c2: controlPoint2, end: toPoint)
            length += UIBezierPath.linearLineLength(fromPoint: p, toPoint: pp)
        }
        return length
    }

    /*  Quadratic Bezier Curve
     *  http://ericasadun.com/2013/03/25/calculating-bezier-points/
     */
    static func quadBezier(t: Float, start: Float, c1: Float, end: Float) -> Float {
        let t_ = CGFloat((1.0 - t))
        let tt_: CGFloat = t_ * t_
        let tt = CGFloat(t * t)
        let offset: CGFloat = 2.0
        return Float(CGFloat(start) * tt_ + offset * CGFloat(c1) * t_ * CGFloat(t) + CGFloat(end) * tt)
    }

    static func quadBezierPoint(t: Float, start: CGPoint, c1: CGPoint, end: CGPoint) -> CGPoint {
        let x: Float = UIBezierPath.quadBezier(t: t, start: Float(start.x), c1: Float(c1.x), end: Float(end.x))
        let y: Float = UIBezierPath.quadBezier(t: t, start: Float(start.y), c1: Float(c1.y), end: Float(end.y))
        return CGPoint(x: CGFloat(x), y: CGFloat(y))
    }

    // Quadratic Bezier Curve Length
    static func quadCurveLength(fromPoint: CGPoint, toPoint: CGPoint, controlPoint: CGPoint) -> CGFloat {
        let iterations: Int = 100
        var length: CGFloat = 0
        for idx in 0 ..< iterations {
            let t: Float = Float(idx) * Float(1.0 / Float(iterations))
            let tt: Float = t + Float(1.0 / Float(iterations))
            let p: CGPoint = UIBezierPath.quadBezierPoint(t: t, start: fromPoint, c1: controlPoint, end: toPoint)
            let pp: CGPoint = UIBezierPath.quadBezierPoint(t: tt, start: fromPoint, c1: controlPoint, end: toPoint)
            length += UIBezierPath.linearLineLength(fromPoint: p, toPoint: pp)
        }
        return length
    }

    var length: CGFloat {
        var pathLength: CGFloat = 0.0
        var current = CGPoint.zero
        var first = CGPoint.zero

        cgPath.forEach { element in
            pathLength += element.distance(to: current, startPoint: first)

            if element.type == .moveToPoint {
                first = element.point
            }
            if element.type != .closeSubpath {
                current = element.point
            }
        }
        return pathLength
    }

    func magnitude() -> CGFloat {
        let subpathCount: Int = countSubpaths()
        var subpaths = [BezierSubpath](repeating: BezierSubpath(), count: subpathCount)
        subpaths = extractSubpaths(subpaths)
        var length: CGFloat = 0.0
        for i in 0 ..< subpathCount {
            length += subpaths[i].length
        }
        return length
    }
    /// Calculated the point along a bezier given a ratio of the length (a number between 0 and 1)/
    func point(atPercentOfLength percent: CGFloat) -> CGPoint {
        var percentage = percent

        if percentage < 0.0 {
            percentage = 0.0
        } else if percentage > 1.0 {
            percentage = 1.0
        }

        let subpathCount: Int = countSubpaths()
        var subpaths = [BezierSubpath](repeating: BezierSubpath(), count: subpathCount)
        subpaths = extractSubpaths(subpaths)
        var length: CGFloat = 0.0
        for i in 0 ..< subpathCount {
            length += subpaths[i].length
        }
        let pointLocationInPath: CGFloat = length * percentage
        var currentLength: CGFloat = 0
        var subpathContainingPoint = BezierSubpath()
        for i in 0 ..< subpathCount {
            if currentLength + subpaths[i].length >= pointLocationInPath {
                subpathContainingPoint = subpaths[i]
                break
            } else {
                currentLength += subpaths[i].length
            }
        }
        let lengthInSubpath: CGFloat = pointLocationInPath - currentLength
        if subpathContainingPoint.length == 0 {
            return subpathContainingPoint.endPoint
        } else {
            let t: CGFloat = lengthInSubpath / subpathContainingPoint.length
            return point(atPercent: t, of: subpathContainingPoint)
        }
    }

    func forEachPathElement(
        body: @escaping @convention(block) (CGPathElement) -> Void
    ) {
        typealias Body = @convention(block) (CGPathElement) -> Void
        let callback: @convention(c) (UnsafeMutableRawPointer, UnsafePointer<CGPathElement>)
            -> Void = { info, element in
                let body = unsafeBitCast(info, to: Body.self)
                body(element.pointee)
            }
        // print("path element memory: ", MemoryLayout.size(ofValue: body))
        let unsafeBody = unsafeBitCast(body, to: UnsafeMutableRawPointer.self)
        cgPath.apply(info: unsafeBody, function: unsafeBitCast(callback, to: CGPathApplierFunction.self))
    }

    func countSubpaths() -> Int {
        var count: Int = 0

        forEachPathElement { element in
            if element.type != CGPathElementType.moveToPoint {
                count += 1
            }
        }
        if count == 0 {
            return 1
        }
        return count
    }

    func extractSubpaths(_ subpathArray: [BezierSubpath]) -> [BezierSubpath] {
        var subpaths = subpathArray, currentPoint = CGPoint.zero, i: Int = 0

        forEachPathElement { element in
            let type: CGPathElementType = element.type, points = element.points
            var subLength: CGFloat = 0.0, endPoint = CGPoint.zero, subpath = BezierSubpath()
            subpath.type = type
            subpath.startPoint = currentPoint
            /*
             *  All paths, no matter how complex, are created through a combination of these path elements.
             */
            switch type {
            case .moveToPoint:
                endPoint = points[0]
            case .addLineToPoint:
                endPoint = points[0]
                subLength = UIBezierPath.linearLineLength(fromPoint: currentPoint, toPoint: endPoint)
            case .addQuadCurveToPoint:
                endPoint = points[1]
                let controlPoint = points[0]
                subLength = UIBezierPath.quadCurveLength(fromPoint: currentPoint, toPoint: endPoint,
                                                         controlPoint: controlPoint)
                subpath.controlPoint1 = controlPoint
            case .addCurveToPoint:
                endPoint = points[2]
                let controlPoint1 = points[0]
                let controlPoint2 = points[1]
                subLength = UIBezierPath.cubicCurveLength(fromPoint: currentPoint, toPoint: endPoint,
                                                          controlPoint1: controlPoint1, controlPoint2: controlPoint2)
                subpath.controlPoint1 = controlPoint1
                subpath.controlPoint2 = controlPoint2
            default:
                break
            }
            subpath.length = subLength
            subpath.endPoint = endPoint
            if type != .moveToPoint {
                subpaths[i] = subpath
                i += 1
            }
            currentPoint = endPoint
        }
        // })
        if i == 0 {
            subpaths[0].length = 0.0
            subpaths[0].endPoint = currentPoint
        }

        return subpaths
    }

    func extractSubpaths() -> [BezierSubpath] {
        let subpathCount: Int = countSubpaths()
        let subpaths = [BezierSubpath](repeating: BezierSubpath(), count: subpathCount)
        return extractSubpaths(subpaths)
    }

    func point(atPercent t: CGFloat, of subpath: BezierSubpath) -> CGPoint {
        var p = CGPoint.zero
        switch subpath.type {
        case .addLineToPoint:
            p = UIBezierPath.linearBezierPoint(t: Float(t), start: subpath.startPoint, end: subpath.endPoint)
        case .addQuadCurveToPoint:
            p = UIBezierPath.quadBezierPoint(t: Float(t), start: subpath.startPoint,
                                             c1: subpath.controlPoint1, end: subpath.endPoint)
        case .addCurveToPoint:
            p = UIBezierPath.cubicBezierPoint(t: Float(t), start: subpath.startPoint,
                                              c1: subpath.controlPoint1, c2: subpath.controlPoint2, end: subpath.endPoint)
        default:
            break
        }
        return p
    }

    /// Rotate path anticlockwise around an anchor point defaulting to the center
    func rotate(inRadians radians: CGFloat, aroundAnchor anchor: CGPoint = CGPoint(x: 0.5, y: 0.5)) {
        let tX = bounds.minX + bounds.width * anchor.x
        let tY = bounds.minY + bounds.height * anchor.y
        // Move anchor point to origin
        apply(CGAffineTransform(translationX: -tX, y: -tY))
        // Rotate
        apply(CGAffineTransform(rotationAngle: radians))
        // Move origin back to anchor point
        apply(CGAffineTransform(translationX: tX, y: tY))
    }

    func translate(x: CGFloat, y: CGFloat) {
        apply(CGAffineTransform(translationX: x, y: y))
    }

    func scale(x: CGFloat, y: CGFloat) {
        apply(CGAffineTransform(scaleX: x, y: y))
    }
}
