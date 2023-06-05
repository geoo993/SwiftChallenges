import Foundation
import UIKit
import CoreGraphics

// https://github.com/louisdh/bezierpath-length/blob/master/Source/PathElement.swift

public extension CGPathElement {
    var point: CGPoint {
        switch type {
        case .moveToPoint, .addLineToPoint:
            return points[0]
        case .addQuadCurveToPoint:
            return points[1]
        case .addCurveToPoint:
            return points[2]
        case .closeSubpath:
            return CGRect.null.origin
        @unknown default:
            fatalError()
        }
    }

    func distance(to point: CGPoint, startPoint: CGPoint) -> CGFloat {
        switch type {
        case .moveToPoint:
            return 0.0
        case .closeSubpath:
            return point.distance(to: startPoint)
        case .addLineToPoint:
            return point.distance(to: points[0])
        case .addCurveToPoint:
            return UIBezierPath.bezierCurveLength(p0: point, c1: points[0], c2: points[1], p1: points[2])
        case .addQuadCurveToPoint:
            return UIBezierPath.bezierCurveLength(p0: point, c1: points[0], p1: points[1])
        @unknown default:
            fatalError()
        }
    }
}

/// Swifty version of `CGPathElement` & `CGPathElementType`
public enum PathElement {

    /// The path element that starts a new subpath. The element holds a single point for the destination.
    case move(to: CGPoint)

    /// The path element that adds a line from the current point to a new point. The element holds a single point for the destination.
    case addLine(to: CGPoint)

    /// The path element that adds a quadratic curve from the current point to the specified point. The element holds a control point and a destination point.
    case addQuadCurve(CGPoint, to: CGPoint)

    /// The path element that adds a cubic curve from the current point to the specified point. The element holds two control points and a destination point.
    case addCurve(CGPoint, CGPoint, to: CGPoint)

    /// The path element that closes and completes a subpath. The element does not contain any points.
    case closeSubpath

    init(element: CGPathElement) {
        switch element.type {
        case .moveToPoint:
            self = .move(to: element.points[0])
        case .addLineToPoint:
            self = .addLine(to: element.points[0])
        case .addQuadCurveToPoint:
            self = .addQuadCurve(element.points[0], to: element.points[1])
        case .addCurveToPoint:
            self = .addCurve(element.points[0], element.points[1], to: element.points[2])
        case .closeSubpath:
            self = .closeSubpath
        @unknown default:
            fatalError()
        }
    }
}
