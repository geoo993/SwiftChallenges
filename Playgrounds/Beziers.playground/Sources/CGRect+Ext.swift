import Foundation

public protocol CGRectExt { }
extension CGRect: CGRectExt { }

public extension CGRectExt where Self == CGRect {
    // MARK: access shortcuts
    /// Alias for origin.x.
    var x: CGFloat {
        get { return self.origin.x }
        set { self.origin.x = newValue }
    }
    /// Alias for origin.y.
    var y: CGFloat {
        get { return self.origin.y }
        set { self.origin.y = newValue }
    }
    /// Accesses origin.x + 0.5 * size.width.
    var centerX: CGFloat {
        get { return x + self.width * 0.5 }
        set { x = newValue - self.width * 0.5 }
    }
    /// Accesses origin.y + 0.5 * size.height.
    var centerY: CGFloat {
        get { return y + self.height * 0.5 }
        set { y = newValue - self.height * 0.5 }
    }

    var center: CGPoint {
        get { return CGPoint(x: centerX, y: centerY) }
        set { centerX = newValue.x; centerY = newValue.y }
    }
    
    func distance(from point: CGPoint) -> CGFloat {
        let dx = max(self.minX - point.x, point.x - self.maxX, 0)
        let dy = max(self.minY - point.y, point.y - self.maxY, 0)
        return dx * dy == 0 ? max(dx, dy) : hypot(dx, dy)
    }
    init(center: CGPoint, size: CGSize) {
        self.init(x: center.x - size.width / 2,
                  y: center.y - size.height / 2,
                  width: size.width,
                  height: size.height
        )
    }
    
    init(width: CGFloat, height: CGFloat) {
        self.init()
        self.origin = CGPoint.zero
        self.size = CGSize(width: width, height: height)
    }

    static func freeSpaces(in rect: CGRect, minSize: CGFloat, maxSize: CGFloat,
                                  spacing: CGFloat, attempts: Int) -> [CGRect] {
        var frames = [CGRect]()

        // Run this loop until new view frame is found
        for _ in 0..<attempts {

            // get a random point
            let randX = CGFloat.random(min: 0, max: rect.width)
            let randY = CGFloat.random(min: 0, max: rect.height)
            let newPoint = CGPoint(x:randX, y:randY)

            // get a random size
            let randSize = CGFloat.random(min: minSize, max: maxSize)
            let newSize = CGSize(width: randSize, height: randSize)

            // create frame
            let newFrame = CGRect(center: newPoint, size: newSize)
            if frames.isEmpty {
                frames.append(newFrame)
                continue
            }
            //print(point)

            // get the closest point
            let distances = frames.map { $0.distance(from: newPoint) }

            // added new frame if there is space
            if let closestDistance = distances.min() {
                if (randSize + spacing) < closestDistance {
                    frames.append(newFrame)
                }
            }
        }

        return frames
    }
}
