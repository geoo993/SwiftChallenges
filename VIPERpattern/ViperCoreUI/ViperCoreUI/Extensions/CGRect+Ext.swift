
public protocol CGRectExt { }
extension CGRect: CGRectExt { }

public extension CGRectExt where Self == CGRect {
    func increaseRect(_ widthPercentage: CGFloat, _ heightPercentage: CGFloat) -> CGRect {
        let startWidth = self.width
        let startHeight = self.height
        let adjustmentWidth = (startWidth * (widthPercentage / 100.0)) / 2.0
        let adjustmentHeight = (startHeight * (heightPercentage / 100.0)) / 2.0
        return self.insetBy(dx: -adjustmentWidth, dy: -adjustmentHeight)
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
                  height: size.height)
    }
    // MARK: access shortcuts
    /// Alias for origin.x.
    var x: CGFloat {
        get {return self.origin.x}
        set {self.origin.x = newValue}
    }
    /// Alias for origin.y.
    var y: CGFloat {
        get {return self.origin.y}
        set {self.origin.y = newValue}
    }
    /// Accesses origin.x + 0.5 * size.width.
    var centerX: CGFloat {
        get {return x + self.width * 0.5}
        set {x = newValue - self.width * 0.5}
    }
    /// Accesses origin.y + 0.5 * size.height.
    var centerY: CGFloat {
        get {return y + self.height * 0.5}
        set {y = newValue - self.height * 0.5}
    }
    // MARK: edges
    /// Alias for origin.x.
    var left: CGFloat {
        get {return self.origin.x}
        set {self.origin.x = newValue}
    }
    /// Accesses origin.x + size.width.
    var right: CGFloat {
        get {return x + self.width}
        set {x = newValue - self.width}
    }
    #if os(iOS)
    /// Alias for origin.y.
    var top: CGFloat {
        get {return y}
        set {y = newValue}
    }
    /// Accesses origin.y + size.height.
    var bottom: CGFloat {
        get {return y + self.height}
        set {y = newValue - self.height}
    }
    #else
    /// Accesses origin.y + size.height.
    public var top: CGFloat {
        get {return y + height}
        set {y = newValue - height}
    }
    /// Alias for origin.y.
    public var bottom: CGFloat {
        get {return y}
        set {y = newValue}
    }
    #endif
    // MARK: points
    /// Accesses the point at the top left corner.
    var topLeft: CGPoint {
        get {return CGPoint(x: left, y: top)}
        set {left = newValue.x; top = newValue.y}
    }
    /// Accesses the point at the middle of the top edge.
    var topCenter: CGPoint {
        get {return CGPoint(x: centerX, y: top)}
        set {centerX = newValue.x; top = newValue.y}
    }
    /// Accesses the point at the top right corner.
    var topRight: CGPoint {
        get {return CGPoint(x: right, y: top)}
        set {right = newValue.x; top = newValue.y}
    }

    /// Accesses the point at the middle of the left edge.
    var centerLeft: CGPoint {
        get {return CGPoint(x: left, y: centerY)}
        set {left = newValue.x; centerY = newValue.y}
    }
    /// Accesses the point at the center.
    var center: CGPoint {
        get {return CGPoint(x: centerX, y: centerY)}
        set {centerX = newValue.x; centerY = newValue.y}
    }
    /// Accesses the point at the middle of the right edge.
    var centerRight: CGPoint {
        get {return CGPoint(x: right, y: centerY)}
        set {right = newValue.x; centerY = newValue.y}
    }

    /// Accesses the point at the bottom left corner.
    var bottomLeft: CGPoint {
        get {return CGPoint(x: left, y: bottom)}
        set {left = newValue.x; bottom = newValue.y}
    }
    /// Accesses the point at the middle of the bottom edge.
    var bottomCenter: CGPoint {
        get {return CGPoint(x: centerX, y: bottom)}
        set {centerX = newValue.x; bottom = newValue.y}
    }
    /// Accesses the point at the bottom right corner.
    var bottomRight: CGPoint {
        get {return CGPoint(x: right, y: bottom)}
        set {right = newValue.x; bottom = newValue.y}
    }
    // MARK: with
    func with(center: CGPoint?) -> CGRect {
        return CGRect(center: center ?? self.center, size: self.size)
    }
    func with(centerX: CGFloat?) -> CGRect {
        return CGRect(center: CGPoint(x: centerX ?? self.centerX, y: centerY), size: self.size)
    }
    func with(centerY: CGFloat?) -> CGRect {
        return CGRect(center: CGPoint(x: centerX, y: centerY ?? self.centerY), size: self.size)
    }
    func with(centerX: CGFloat?, centerY: CGFloat?) -> CGRect {
        return CGRect(center: CGPoint(x: centerX ?? self.centerX, y: centerY ?? self.centerY), size: self.size)
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

extension Collection where Iterator.Element == CGRect {
    public func intersecting(frame: CGRect) -> Bool {
        guard let rects = self as? [CGRect] else { return false }
        var isIntersecting = false
        for rect in rects {
            if frame.intersects(rect) {
                isIntersecting = true
                break
            }
        }
        return isIntersecting
    }
}
