import Foundation

public extension CGPoint {

    static func point(_ x: CGFloat, _ y: CGFloat) -> CGPoint {
        return CGPoint(x: x, y: y)
    }

    func distance(from rect: CGRect) -> CGFloat {
        let dx = max(rect.minX - x, x - rect.maxX, 0)
        let dy = max(rect.minY - y, y - rect.maxY, 0)
        return dx * dy == 0 ? max(dx, dy) : hypot(dx, dy)
    }

    func distance(to point: CGPoint) -> CGFloat {
        let dx = pow(point.x - x, 2)
        let dy = pow(point.y - y, 2)
        return sqrt(dx + dy)
    }

    func rotatePointAboutOrigin(angle: CGFloat) -> CGPoint {
        // https://stackoverflow.com/questions/1595285/what-is-the-best-way-to-rotate-a-cgpoint-on-a-grid
        let s: CGFloat = CGFloat(sinf(Float(angle)))
        let c: CGFloat = CGFloat(cosf(Float(angle)))
        return CGPoint(x: c * x - s * y, y: s * x + c * y)
    }

    /// Finds the closest `t` value on path for a given point.
    ///
    /// - Parameter fromPoint: A given point
    /// - Returns: The closest point on the path within the lookup table.
    func findClosestPointOnPath(within points: [CGPoint]) -> CGPoint {
        let lookupTable = points
        let fromPoint = self
        if lookupTable.isEmpty { return fromPoint }
        let end = lookupTable.count
        var dd = fromPoint.distanceTo(lookupTable.first!)
        var d: CGFloat = 0
        var f = 0
        for i in 1 ..< end {
            d = fromPoint.distanceTo(lookupTable[i])
            if d < dd {
                f = i
                dd = d
            }
        }
        return lookupTable[f]
    }

    /// Calculates a point at given t value, where t in 0.0...1.0
    func calculateLinear(distance: CGFloat, point1: CGPoint, point2: CGPoint) -> CGPoint {
        let mt: CGFloat = 1.0 - distance
        let x = mt * point1.x + distance * point2.x
        let y = mt * point1.y + distance * point2.y
        return CGPoint(x: x, y: y)
    }

    /// Calculates a point at given t value, where t in 0.0...1.0
    func calculateCube(distance: CGFloat,
                              point1: CGPoint,
                              point2: CGPoint,
                              point3: CGPoint,
                              point4: CGPoint) -> CGPoint {
        let mt: CGFloat = 1.0 - distance
        let mt2 = mt * mt
        let t2 = distance * distance

        let a = mt2 * mt
        let b = mt2 * distance * 3
        let c = mt * t2 * 3
        let d = distance * t2

        let x = a * point1.x + b * point2.x + c * point3.x + d * point4.x
        let y = a * point1.y + b * point2.y + c * point3.y + d * point4.y
        return CGPoint(x: x, y: y)
    }

    /// Calculates a point at given t value, where t in 0.0...1.0
    func calculateQuad(distance: CGFloat,
                              point1: CGPoint,
                              point2: CGPoint,
                              point3: CGPoint) -> CGPoint {
        let mt: CGFloat = 1.0 - distance
        let mt2 = mt * mt
        let t2 = distance * distance
        let a = mt2
        let b = mt * distance * 2.0
        let c = t2
        let x = a * point1.x + b * point2.x + c * point3.x
        let y = a * point1.y + b * point2.y + c * point3.y
        return CGPoint(x: x, y: y)
    }
    /// Creates a new CGPoint given a CGVector.
    init(vector: CGVector) {
        self.init(x: vector.dx, y: vector.dy)
    }

    /**
     * Given an angle in radians, creates a vector of length 1.0 and returns the
     * result as a new CGPoint. An angle of 0 is assumed to point to the right.
     */
    init(angle: CGFloat) {
        self.init(x: cos(angle), y: sin(angle))
    }

    /**
     * Adds (dx, dy) to the point.
     */
    mutating func offset(deltaX: CGFloat, deltaY: CGFloat) -> CGPoint {
        x += deltaX
        y += deltaY
        return self
    }
    /**
     * Returns point adding (dx, dy).
     */
    func offsetBy(deltaX: CGFloat, deltaY: CGFloat) -> CGPoint {
        return CGPoint(x: x + deltaX, y: y + deltaY)
    }
    /**
     * Returns point adding (dx, dy).
     */
    func offsetX(by deltaX: CGFloat) -> CGPoint {
        return CGPoint(x: x + deltaX, y: y)
    }
    /**
     * Returns point adding (dx, dy).
     */
    func offsetY(by deltaY: CGFloat) -> CGPoint {
        return CGPoint(x: x, y: y + deltaY)
    }
    // Returns the length (magnitude) of the vector described by the CGPoint.
    func length() -> CGFloat {
        return sqrt(x * x + y * y)
    }

    /**
     * Returns the squared length of the vector described by the CGPoint.
     */
    func lengthSquared() -> CGFloat {
        return x * x + y * y
    }

    /**
     * Normalizes the vector described by the CGPoint to length 1.0 and returns
     * the result as a new CGPoint.
     */
    func normalized() -> CGPoint {
        let len = length()
        return len > 0 ? self / len : CGPoint.zero
    }

    /**
     * Normalizes the vector described by the CGPoint to length 1.0.
     */
    mutating func normalize() -> CGPoint {
        self = normalized()
        return self
    }

    /**
     * Calculates the distance between two CGPoints. Pythagoras!
     */
    func distanceTo(_ point: CGPoint) -> CGFloat {
        return (self - point).length()
    }

    /**
     * Returns the angle in radians of the vector described by the CGPoint.
     * The range of the angle is -π to π; an angle of 0 points to the right.
     */
    var angle: CGFloat {
        return atan2(y, x)
    }

    func minus(this point: CGPoint) -> CGPoint {
        return self - point
    }

    func plus(this point: CGPoint) -> CGPoint {
        return self + point
    }
}

#if !(arch(x86_64) || arch(arm64))
    func sqrt(value: CGFloat) -> CGFloat {
        return CGFloat(sqrtf(Float(value)))
    }
#endif

/**
 * Adds two CGPoint values and returns the result as a new CGPoint.
 */
public func + (left: CGPoint, right: CGPoint) -> CGPoint {
    return CGPoint(x: left.x + right.x, y: left.y + right.y)
}

/**
 * Increments a CGPoint with the value of another.
 */
public func += (left: inout CGPoint, right: CGPoint) {
    left += right
}

/**
 * Adds a CGVector to this CGPoint and returns the result as a new CGPoint.
 */
public func + (left: CGPoint, right: CGVector) -> CGPoint {
    return CGPoint(x: left.x + right.dx, y: left.y + right.dy)
}

/**
 * Increments a CGPoint with the value of a CGVector.
 */
public func += (left: inout CGPoint, right: CGVector) {
    left += right
}

/**
 * Subtracts two CGPoint values and returns the result as a new CGPoint.
 */
public func - (left: CGPoint, right: CGPoint) -> CGPoint {
    return CGPoint(x: left.x - right.x, y: left.y - right.y)
}

/**
 * Decrements a CGPoint with the value of another.
 */
public func -= (left: inout CGPoint, right: CGPoint) {
    left -= right
}

/**
 * Subtracts a CGVector from a CGPoint and returns the result as a new CGPoint.
 */
public func - (left: CGPoint, right: CGVector) -> CGPoint {
    return CGPoint(x: left.x - right.dx, y: left.y - right.dy)
}

/**
 * Decrements a CGPoint with the value of a CGVector.
 */
public func -= (left: inout CGPoint, right: CGVector) {
    left -= right
}

/**
 * Multiplies two CGPoint values and returns the result as a new CGPoint.
 */
public func * (left: CGPoint, right: CGPoint) -> CGPoint {
    return CGPoint(x: left.x * right.x, y: left.y * right.y)
}

/**
 * Multiplies a CGPoint with another.
 */
public func *= (left: inout CGPoint, right: CGPoint) {
    left *= right
}

/**
 * Multiplies the x and y fields of a CGPoint with the same scalar value and
 * returns the result as a new CGPoint.
 */
public func * (point: CGPoint, scalar: CGFloat) -> CGPoint {
    return CGPoint(x: point.x * scalar, y: point.y * scalar)
}

/**
 * Multiplies the x and y fields of a CGPoint with the same scalar value.
 */
public func *= (point: inout CGPoint, scalar: CGFloat) {
    point *= scalar
}

/**
 * Multiplies a CGPoint with a CGVector and returns the result as a new CGPoint.
 */
public func * (left: CGPoint, right: CGVector) -> CGPoint {
    return CGPoint(x: left.x * right.dx, y: left.y * right.dy)
}

/**
 * Multiplies a CGPoint with a CGVector.
 */
public func *= (left: inout CGPoint, right: CGVector) {
    left *= right
}

/**
 * Divides two CGPoint values and returns the result as a new CGPoint.
 */
public func / (left: CGPoint, right: CGPoint) -> CGPoint {
    return CGPoint(x: left.x / right.x, y: left.y / right.y)
}

/**
 * Divides a CGPoint by another.
 */
public func /= (left: inout CGPoint, right: CGPoint) {
    left /= right
}

/**
 * Divides the x and y fields of a CGPoint by the same scalar value and returns
 * the result as a new CGPoint.
 */
public func / (point: CGPoint, scalar: CGFloat) -> CGPoint {
    return CGPoint(x: point.x / scalar, y: point.y / scalar)
}

/**
 * Divides the x and y fields of a CGPoint by the same scalar value.
 */
public func /= (point: inout CGPoint, scalar: CGFloat) {
    point /= scalar
}

/**
 * Divides a CGPoint by a CGVector and returns the result as a new CGPoint.
 */
public func / (left: CGPoint, right: CGVector) -> CGPoint {
    return CGPoint(x: left.x / right.dx, y: left.y / right.dy)
}

/**
 * Divides a CGPoint by a CGVector.
 */
public func /= (left: inout CGPoint, right: CGVector) {
    left /= right
}

/**
 * Performs a linear interpolation between two CGPoint values.
 */
public func lerp(start: CGPoint, end: CGPoint, time: CGFloat) -> CGPoint {
    return start + (end - start) * time
}
