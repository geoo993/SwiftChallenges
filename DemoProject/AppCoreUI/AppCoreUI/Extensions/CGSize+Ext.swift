
public extension CGSize {
    init(point: CGPoint) {
        self.init(width: point.x, height: point.y)
    }

    init(value: CGFloat) {
        self.init(width: value, height: value)
    }

    var half: CGSize {
        return CGSize(width: width * 0.5, height: height * 0.5)
    }

    var toPoint: CGPoint {
        return CGPoint(x: width, y: height)
    }
}

/**
 * Adds two CGSize values and returns the result as a new CGSize.
 */
public func + (left: CGSize, right: CGSize) -> CGSize {
    return CGSize(width: left.width + right.width, height: left.height + right.height)
}

/**
 * Increments a CGSize with the value of another.
 */
public func += (left: inout CGSize, right: CGSize) {
    left.width += right.width
    left.height += right.height

}

/**
 * Subtracts two CGSize values and returns the result as a new CGSize.
 */
public func - (left: CGSize, right: CGSize) -> CGSize {
    return CGSize(width: left.width - right.width, height: left.height - right.height)
}

/**
 * Decrements a CGSize with the value of another.
 */
public func -= (left: inout CGSize, right: CGSize) {
    left.width -= right.width
    left.height -= right.height
}

/**
 * Multiplies two CGSize values and returns the result as a new CGSize.
 */
public func * (left: CGSize, right: CGSize) -> CGSize {
    return CGSize(width: left.width * right.width, height: left.height * right.height)
}

/**
 * Multiplies a CGSize with another.
 */
public func *= (left: inout CGSize, right: CGSize) {
    left.width *= right.width
    left.height *= right.height
}

/**
 * Multiplies the with and height fields of a CGSize with the same scalar value and
 * returns the result as a new CGSize.
 */
public func * (size: CGSize, scalar: CGFloat) -> CGSize {
    return CGSize(width: size.width * scalar, height: size.height * scalar)
}

/**
 * Multiplies the with and height fields of a CGSize with the same scalar value.
 */
public func *= (point: inout CGSize, scalar: CGFloat) {
    point.width *= scalar
    point.height *= scalar
}

/**
 * Divides two CGSize values and returns the result as a new CGSize.
 */
public func / (left: CGSize, right: CGSize) -> CGSize {
    return CGSize(width: left.width / right.width, height: left.height / right.height)
}

/**
 * Divides a CGSize by another.
 */
public func /= (left: inout CGSize, right: CGSize) {
    left.width /= right.width
    left.height /= right.height
}

/**
 * Divides the width and height fields of a CGSize by the same scalar value and returns
 * the result as a new CGSize.
 */
public func / (size: CGSize, scalar: CGFloat) -> CGSize {
    return CGSize(width: size.width / scalar, height: size.height / scalar)
}

/**
 * Divides the width and height fields of a CGSize by the same scalar value.
 */
public func /= (size: inout CGSize, scalar: CGFloat) {
    size.width /= scalar
    size.height /= scalar
}

/**
 * Performs a linear interpolation between two CGSize values.
 */
public func lerp(start: CGSize, end: CGSize, time: CGFloat) -> CGSize {
    return start + (end - start) * time
}
