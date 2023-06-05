import Foundation
import UIKit
import CoreGraphics

public extension FloatingPoint {
    var toRadians: Self { return self * .pi / 180 }
    var toDegrees: Self { return self * 180 / .pi }
}

public extension CGFloat {
    func value(with percentage : CGFloat, minValue : CGFloat = 0) -> CGFloat {
        let max = (self > minValue) ? self : minValue
        let min = (self > minValue) ? minValue : self
        
        return ( ((max - min) * percentage) / CGFloat(100) ) + min
    }

    var toDouble: Double {
        return Double(self)
    }
    
    static func random(min: CGFloat, max: CGFloat) -> CGFloat {
        let rand = CGFloat(arc4random()) / CGFloat(UINT32_MAX)
        let minimum = min < max ? min : max
        return rand * Swift.abs(CGFloat(min - max)) + minimum
    }
}


public extension CGPath {

    typealias PathApplier = @convention(block) (UnsafePointer<CGPathElement>) -> Void

    func apply(with applier: @escaping PathApplier) {

        let callback: @convention(c) (UnsafeMutableRawPointer, UnsafePointer<CGPathElement>) -> Void = { (info, element) in

            let block = unsafeBitCast(info, to: PathApplier.self)
            block(element)

        }

        self.apply(info: unsafeBitCast(applier, to: UnsafeMutableRawPointer.self), function: unsafeBitCast(callback, to: CGPathApplierFunction.self))
    }

    var elements: [PathElement] {
        var pathElements = [PathElement]()

        apply { (element) in

            let pathElement = PathElement(element: element.pointee)
            pathElements.append(pathElement)
        }

        return pathElements
    }
    
    func forEach(
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
        apply(info: unsafeBody, function: unsafeBitCast(callback, to: CGPathApplierFunction.self))
    }

    func getPathElementsPoints() -> [CGPoint] {
        var arrayPoints: [CGPoint]! = [CGPoint]()
        forEach { element in
            switch element.type {
            case CGPathElementType.moveToPoint:
                arrayPoints.append(element.points[0])
            case .addLineToPoint:
                arrayPoints.append(element.points[0])
            case .addQuadCurveToPoint:
                arrayPoints.append(element.points[0])
                arrayPoints.append(element.points[1])
            case .addCurveToPoint:
                arrayPoints.append(element.points[0])
                arrayPoints.append(element.points[1])
                arrayPoints.append(element.points[2])
            default: break
            }
        }
        return arrayPoints
    }

    func getPathElementsPointsAndTypes() -> ([CGPoint], [CGPathElementType]) {
        var arrayPoints: [CGPoint]! = [CGPoint]()
        var arrayTypes: [CGPathElementType]! = [CGPathElementType]()
        forEach { element in
            switch element.type {
            case CGPathElementType.moveToPoint:
                arrayPoints.append(element.points[0])
                arrayTypes.append(element.type)
            case .addLineToPoint:
                arrayPoints.append(element.points[0])
                arrayTypes.append(element.type)
            case .addQuadCurveToPoint:
                arrayPoints.append(element.points[0])
                arrayPoints.append(element.points[1])
                arrayTypes.append(element.type)
                arrayTypes.append(element.type)
            case .addCurveToPoint:
                arrayPoints.append(element.points[0])
                arrayPoints.append(element.points[1])
                arrayPoints.append(element.points[2])
                arrayTypes.append(element.type)
                arrayTypes.append(element.type)
                arrayTypes.append(element.type)
            default: break
            }
        }
        return (arrayPoints, arrayTypes)
    }

    func subpath(toPercentOfLength toPercent: CGFloat) -> UIBezierPath {

        let length: CGFloat = CGFloat(self.elements.count)
        let subpathlenth: Int = Int(length.value(with: toPercent))
        var currentLength: Int = 0
        let bezierPath = UIBezierPath()

        for type in self.elements {
            if currentLength >= subpathlenth {
                break
            }

            switch type {
            case .move(to: let point):
                bezierPath.move(to: point)
            case .addLine(to: let point):
                bezierPath.addLine(to: point)
            case .addQuadCurve(let point, to: let controlPoint):
                bezierPath.addQuadCurve(to: controlPoint, controlPoint: point)
            case .addCurve(let controlPoint1, let controlPoint2, to: let point):
                bezierPath.addCurve(to: point, controlPoint1: controlPoint1, controlPoint2: controlPoint2)
            case .closeSubpath:
                bezierPath.close()

            }
            currentLength += 1

        }
        return bezierPath
    }

}
