import Foundation
import PlaygroundSupport
import UIKit

func p(_ x: CGFloat, _ y: CGFloat) -> CGPoint { return CGPoint(x: x, y: y) }
let pi = CGFloat.pi
let path = UIBezierPath()
path.move(to: p(0, 0))
path.addLine(to: p(0, 50))
path.addArc(withCenter: p(-50, 50), radius: 50, startAngle: 0, endAngle: pi / 2, clockwise: true)
path.addArc(withCenter: p(-50, 150), radius: 50, startAngle: 3 / 2 * pi, endAngle: pi, clockwise: false)
// path.move(to: p(-50, -50))
// path.addLine(to: p(-100, -50))
// path.close()
path.point(atPercentOfLength: 1)
path.apply(CGAffineTransform(scaleX: 1, y: -1))
// path.

let subpaths = path.extractSubpaths()
subpaths.forEach { sp in
    sp.length
    print(sp, sp.length.format(Decimals.one))
}
path

class BezierTestView: UIView {
    let pad = (left: CGFloat(0), top: CGFloat(10))
    var incrementalImage: UIImage?
    var points: [CGPoint] = Array(repeating: .zero, count: 5)
    var counter = 0
    override init(frame: CGRect) {
        super.init(frame: frame)
        isMultipleTouchEnabled = false
        backgroundColor = .white
    }

    func p(_ x: CGFloat, _ y: CGFloat) -> CGPoint {
        return CGPoint(x: x + bounds.midX, y: y + pad.top)
    }

    required init?(coder aDecoder: NSCoder) { super.init(coder: aDecoder) }

    var staticPath: UIBezierPath {
        let strokeColor = UIColor.black
        let path = UIBezierPath()
        path.move(to: p(0, 0))
        path.addLine(to: p(0, 50))
        path.addArc(withCenter: p(-50, 50), radius: 50, startAngle: 0, endAngle: pi / 2, clockwise: true)
        path.addArc(withCenter: p(-50, 150), radius: 50, startAngle: 3 / 2 * pi, endAngle: pi, clockwise: false)

        path.lineWidth = 2
        strokeColor.setStroke()
        return path
    }

    var paths: [UIBezierPath] = []
    override func touchesBegan(_ touches: Set<UITouch>, with _: UIEvent?) {
        guard let touch = touches.first else { return }
        let path = UIBezierPath()
        path.lineWidth = 2
        UIColor.black.setStroke()
        let start = touch.location(in: self)
//        path.move(to: start)
        paths.append(path)
        counter = 0
        points[0] = start
    }
    override func touchesMoved(_ touches: Set<UITouch>, with _: UIEvent?) {
        guard let touch = touches.first, let path = paths.last else { return }
        let current = touch.location(in: self)
        counter += 1
        points[counter] = current
        if counter == 4 {
            points[3] = CGPoint(x: (points[2].x + points[4].x) / 2.0, y: (points[2].y + points[4].y) / 2.0) // move the endpoint to the middle of the line joining the second control point of the first Bezier segment and the first control point of the second Bezier segment

            path.move(to: points[0])
            path.addCurve(to: points[3], controlPoint1: points[1], controlPoint2: points[2])
            setNeedsDisplay()
            points[0] = points[3]
            points[1] = points[4]
            counter = 1
        }
//        path.addLine(to: current)
    }
    override func touchesEnded(_: Set<UITouch>, with _: UIEvent?) {
//        guard let touch = touches.first, let path = paths.last else { return }
//        let current = touch.location(in: self)
//        path.addLine(to: current)
        drawBitmap()
        setNeedsDisplay()
        counter = 0
    }
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        touchesEnded(touches, with: event)
    }
    override func draw(_ rect: CGRect) {
        incrementalImage?.draw(in: rect)
        staticPath.stroke()
        paths.last?.stroke()
        //        paths.forEach { $0.stroke() }
    }
    func drawBitmap() {
        UIGraphicsBeginImageContextWithOptions(bounds.size, true, 0)
        UIColor.black.setStroke()
        if incrementalImage == nil {
            let rectPath = UIBezierPath(rect: bounds)
            UIColor.white.setFill()
            rectPath.fill()
        }
        incrementalImage?.draw(at: .zero)
        paths.last?.stroke()
        incrementalImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
    }
}

let size = CGSize(width: 500, height: 500)
let bv = BezierTestView(frame: CGRect(origin: .zero, size: size))

PlaygroundPage.current.liveView = bv
