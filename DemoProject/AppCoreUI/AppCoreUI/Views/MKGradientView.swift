// swiftlint:disable force_cast
import UIKit

// MARK: - Gradient View

public final class MKGradientView: UIView {
    var colors: [UIColor] = [.clear, .clear, .clear] {
        didSet {
            (layer as! MKGradientLayer).colors = colors.map { $0.cgColor }
        }
    }

    var colors2: [UIColor] = [.clear, .clear] {
        didSet {
            (layer as! MKGradientLayer).colors2 = colors2.map { $0.cgColor }
        }
    }

    var locations: [Float]? {
        didSet {
            (layer as! MKGradientLayer).locations = locations
        }
    }

    @IBInspectable var startPoint: CGPoint = CGPoint(x: 0, y: 0) {
        didSet {
            (layer as! MKGradientLayer).startPoint = startPoint
        }
    }

    @IBInspectable var endPoint: CGPoint = CGPoint(x: 1, y: 1) {
        didSet {
            (layer as! MKGradientLayer).endPoint = endPoint
        }
    }

    var startPoint2: CGPoint = CGPoint(x: 0, y: 0) {
        didSet {
            (layer as! MKGradientLayer).startPoint2 = startPoint2
        }
    }

    var endPoint2: CGPoint = CGPoint(x: 1, y: 1) {
        didSet {
            (layer as! MKGradientLayer).endPoint2 = endPoint2
        }
    }

    var type: GradientType = .linear {
        didSet {
            (layer as! MKGradientLayer).type = type
        }
    }

    public override class var layerClass: AnyClass {
        return MKGradientLayer.self
    }
    public func configure(forGame: Bool) {
        let gradientColor: UIColor = forGame ? .sunflowerYellow : .weirdGreen
        self.startColor = gradientColor
        self.midColor = gradientColor
        
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    fileprivate func setup() {
        // layer.contentsScale = UIScreen.mainScreen().scale
        layer.needsDisplayOnBoundsChange = true
        layer.setNeedsDisplay()
    }
}

// MARK: Interface Builder Additions

@IBDesignable @available(*, unavailable, message: "This is reserved for Interface Builder")
extension MKGradientView {
    @IBInspectable var gradientType: String {
        set {
            if let type = GradientType(rawValue: newValue.lowercased()) {
                self.type = type
            }
        }
        get {
            return type.rawValue
        }
    }

    @IBInspectable var startColor: UIColor {
        set {
            if colors.isEmpty {
                colors.append(newValue)
                colors.append(UIColor.clear)
                colors.append(UIColor.clear)
            } else {
                colors[0] = newValue
            }
        }
        get {
            return (colors.count >= 1) ? colors[0] : UIColor.clear
        }
    }

    @IBInspectable var midColor: UIColor {
        set {
            if colors.isEmpty {
                colors.append(UIColor.clear)
                colors.append(newValue)
                colors.append(UIColor.clear)
            } else {
                colors[1] = newValue
            }
        }
        get {
            return (colors.count >= 2) ? colors[1] : UIColor.clear
        }
    }

    @IBInspectable var endColor: UIColor {
        set {
            if colors.isEmpty {
                colors.append(UIColor.clear)
                colors.append(UIColor.clear)
                colors.append(newValue)
            } else {
                colors[2] = newValue
            }
        }
        get {
            return (colors.count >= 3) ? colors[2] : UIColor.clear
        }
    }

    @IBInspectable var locationArray: String {
        set {
            let newLocations = newValue.split(separator: ",").compactMap { Float($0) }
            let allAreInUnitInterval = newLocations.reduce(true) { (acc, location) -> Bool in
                return acc && (0 <= location && location <= 1)
            }
            if newLocations.count == 3 && allAreInUnitInterval {
                locations = newLocations
            } else {
                log.error("Improperly formatted locationArray: \(newValue)")
            }
        }
        get {
            return (locations ?? []).map { "\($0)" }.joined(separator: ",")
        }
    }

    @IBInspectable var contentsScale: CGFloat {
        set {
            guard 0.0 <= newValue && newValue <= 3.0 else { return }
            layer.contentsScale = newValue
        } get {
            return layer.contentsScale
        }
    }

    public override func prepareForInterfaceBuilder() {
        // To improve IB performance, reduce generated image size
        layer.contentsScale = 0.25
    }
}

// MARK: - Gradient Layer

class MKGradientLayer: CALayer {
    /// The array of CGColorRef objects defining the color of each gradient stop.
    /// For `.bilinear` gradient type defines X-direction gradient stops.
    var colors: [CGColor] = [UIColor.clear.cgColor, UIColor.clear.cgColor, UIColor.clear.cgColor] {
        didSet {
            setNeedsDisplay()
        }
    }

    /// The array of Y-direction gradient stops for `.bilinear` gradient type.
    /// Ignored for other gradient types.
    var colors2: [CGColor] = [UIColor.clear.cgColor, UIColor.clear.cgColor] {
        didSet {
            setNeedsDisplay()
        }
    }

    /// An optional array of Floats defining the location of each gradient stop as a value in
    /// the range [0.0, 1.0]. The values must be monotonically increasing. If a nil array is given,
    /// the stops are assumed to spread uniformly across the [0.0, 1.0] range. The number of elements must
    /// be equal to `colors` array count.
    /// Defines X-direction color locations for `.bilinear` gradient type.
    var locations: [Float]? {
        didSet {
            setNeedsDisplay()
        }
    }

    /// An optional array of Y-direction color locations for `.bilinear` gradient type.
    /// The number of elements must be equal to `colors2` array count.
    /// Ignored for other gradient types.
    var locations2: [Float]? {
        didSet {
            setNeedsDisplay()
        }
    }

    /// The start point of the gradient when drawn into the layer's coordinate space.
    /// The start point corresponds to the first gradient stop. The points are defined in a
    /// unit coordinate space that is then mapped to the layer's bounds rectangle when drawn.
    /// (I.e. [0.0, 0.0] is the bottom-left corner of the layer, [1.0, 1.0] is the top-right corner.).
    ///
    /// The default values for gradient types are:
    ///
    /// - `.linear`:  [0.5, 0.0] -> [0.5, 1.0]
    /// - `.radial`:  [0.5, 0.5] -> [1.0, 0.5]
    /// - `.conical`: [0.5, 0.5] -> [1.0, 0.5]
    /// - `.bilinear` (X-direction): [0.0, 0.5] -> [1.0, 0.5]
    var startPoint: CGPoint? {
        didSet {
            setNeedsDisplay()
        }
    }

    /// The end point of the gradient when drawn into the layer's coordinate space.
    /// The end point corresponds to the last gradient stop. The points are defined in
    // a unit coordinate space that is then mapped to the layer's bounds rectangle when drawn.
    /// (I.e. [0.0, 0.0] is the bottom-left corner of the layer, [1.0, 1.0] is the top-right corner.).
    var endPoint: CGPoint? {
        didSet {
            setNeedsDisplay()
        }
    }

    /// The start point of the `.bilinear` gradient's Y-direction, defaults to [0.5, 0.0] -> [0.5, 1.0].
    /// Ignored for other gradient types.
    var startPoint2: CGPoint? {
        didSet {
            setNeedsDisplay()
        }
    }

    /// The end point of the `.bilinear` gradient's Y-direction, defaults to [0.5, 0.0] -> [0.5, 1.0].
    /// Ignored for other gradient types.
    var endPoint2: CGPoint? {
        didSet {
            setNeedsDisplay()
        }
    }

    /// The kind of gradient that will be drawn.
    var type: GradientType = .linear {
        didSet {
            setNeedsDisplay()
        }
    }

    // MARK: Content drawing

    override func draw(in ctx: CGContext) {
        ctx.setFillColor(backgroundColor ?? UIColor.clear.cgColor)
        ctx.fill(bounds)

        let img = MKGradientGenerator.gradientImage(
            type: type, size: bounds.size, colors: colors, colors2: colors2,
            locations: locations, locations2: locations2,
            startPoint: startPoint, endPoint: endPoint,
            startPoint2: startPoint2, endPoint2: endPoint2, scale: contentsScale)
        ctx.draw(img, in: bounds)
    }
}
