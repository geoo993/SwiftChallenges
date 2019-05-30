
public protocol ViewCopyable {
    func copyView<Self: UIView>() throws -> Self
}

extension ViewCopyable where Self: UIView {
    /// Copy a subclass of UIView using NSKeyedArchiver.
    public func copyView<T: UIView>() throws -> T {
        let view = (self as? T)!
        do {
            let archived = try NSKeyedArchiver.archivedData(withRootObject: view, requiringSecureCoding: false)
            if let copy = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(archived) as? T {
                return copy
            }
            return view
        } catch {
            fatalError("Couldn't copy view")
        }
    }
}

extension UIView: ViewCopyable {}

public extension UIView {
    /// Removes all constrains for this view
    func removeConstraints() {
        var topView: UIView? = self
        repeat {
            var list = [NSLayoutConstraint]()
            for c in topView?.constraints ?? [] {
                if c.firstItem as? UIView == self || c.secondItem as? UIView == self {
                    list.append(c)
                }
            }
            topView?.removeConstraints(list)
            topView = topView?.superview

        } while topView != nil

        translatesAutoresizingMaskIntoConstraints = true
    }

    // Recursive remove subviews and constraints
    func removeSubviewsAndConstraints() {
        self.subviews.forEach({
            $0.removeSubviewsAndConstraints()
            $0.removeConstraints($0.constraints)
            $0.removeFromSuperview()
        })
    }

    func removeNestedSubviewsAndConstraints() {
        while(self.subviews.count > 0) {
            self.removeSubviewsAndConstraints()
        }
    }

    func shakeView(repeatCount: Float) {
        let view = self
        CATransaction.begin()
        CATransaction.setCompletionBlock({
            // view.isHidden = true
        })
        let shake = CABasicAnimation(keyPath: "position")
        shake.duration = 0.1
        shake.repeatCount = repeatCount
        shake.autoreverses = true

        let from_point = CGPoint(x: view.center.x - 5, y: view.center.y)
        let from_value: NSValue = NSValue(cgPoint: from_point)

        let to_point = CGPoint(x: view.center.x + 5, y: view.center.y)
        let to_value: NSValue = NSValue(cgPoint: to_point)

        shake.fromValue = from_value
        shake.toValue = to_value
        view.layer.add(shake, forKey: "position")

        // shake.delegate = self

        CATransaction.commit()
    }

    func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(
            roundedRect: bounds,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }

    func addDropShadowWithGlowLayer(
        backgroungColor: UIColor = UIColor.clear,
        shadowColor: CGColor = UIColor.yellow.cgColor,
        shadowOffset: CGSize = CGSize.zero,
        shadowOpacity: Float = 0.8,
        shadowRadius: CGFloat = 15.0) {
        let sublayer = CALayer()
        sublayer.backgroundColor = backgroungColor.cgColor
        sublayer.shadowColor = shadowColor
        sublayer.shadowOffset = shadowOffset
        sublayer.shadowOpacity = shadowOpacity
        sublayer.shadowRadius = shadowRadius
        sublayer.frame = frame
        sublayer.borderColor = shadowColor
        sublayer.borderWidth = 2.0
        // sublayer.cornerRadius = 10.0

        layer.insertSublayer(sublayer, at: 0)
    }

    func addBorder(borderColor: UIColor, borderWidth: CGFloat, cornerRadius: CGFloat, masksToBounds: Bool = false) {
        layer.borderColor = borderColor.cgColor
        layer.borderWidth = borderWidth
        layer.cornerRadius = cornerRadius
        layer.masksToBounds = masksToBounds
    }

    func addShadow(with color: UIColor = UIColor.black,
                          width: CGFloat = 0.2,
                          height: CGFloat = 0.2,
                          opacity: Float = 0.7,
                          radius: CGFloat = 0.5,
                          masksToBounds: Bool = false
    ) {
        layer.shadowColor = color.cgColor
        layer.shadowOffset = CGSize(width: width, height: height)
        layer.shadowRadius = radius
        layer.shadowOpacity = opacity
        layer.masksToBounds = masksToBounds
    }

    static func animateLayer(duration: Double, animations: () -> Void,
                                    completion: (() -> Void)? = nil) {
        CATransaction.begin()
        CATransaction.setAnimationDuration(duration)
        if let completion = completion {
            CATransaction.setCompletionBlock(completion)
        }
        animations()
        CATransaction.commit()
    }
}

public extension UIView {
    /// The top coordinate of the UIView.
    var top: CGFloat {
        get {
            return frame.top
        }
        set(value) {
            var frame = self.frame
            frame.top = value
            self.frame = frame
        }
    }
    /// The left coordinate of the UIView.
    var left: CGFloat {
        get {
            return frame.left
        }
        set(value) {
            var frame = self.frame
            frame.left = value
            self.frame = frame
        }
    }
    /// The bottom coordinate of the UIView.
    var bottom: CGFloat {
        get {
            return frame.bottom
        }
        set(value) {
            var frame = self.frame
            frame.bottom = value
            self.frame = frame
        }
    }
    /// The right coordinate of the UIView.
    var right: CGFloat {
        get {
            return frame.right
        }
        set(value) {
            var frame = self.frame
            frame.right = value
            self.frame = frame
        }
    }
    // The width of the UIView.
    var width: CGFloat {
        get {
            return frame.width
        }
        set(value) {
            var frame = self.frame
            frame.size.width = value
            self.frame = frame
        }
    }
    // The height of the UIView.
    var height: CGFloat {
        get {
            return frame.height
        }
        set(value) {
            var frame = self.frame
            frame.size.height = value
            self.frame = frame
        }
    }
    /// The horizontal center coordinate of the UIView.
    var centerX: CGFloat {
        get {
            return frame.centerX
        }
        set(value) {
            var frame = self.frame
            frame.centerX = value
            self.frame = frame
        }
    }
    /// The vertical center coordinate of the UIView.
    var centerY: CGFloat {
        get {
            return frame.centerY
        }
        set(value) {
            var frame = self.frame
            frame.centerY = value
            self.frame = frame
        }
    }
}

public extension CALayer {

    // Recursive remove sublayers
    func removeNestedSublayers<T>(with type : T.Type) {
        if let sublayers = self.sublayers {
            for sublayer in sublayers where sublayer is T {
                sublayer.removeNestedSublayers(with: type)
                sublayer.removeFromSuperlayer()
            }
        }
    }

}
