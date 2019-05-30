//
//  BadgeView.swift
//  StoryView
//
//  Created by Daniel Asher on 17/12/2017.
//  Copyright © 2017 LEXI LABS. All rights reserved.
//
@IBDesignable public final class BadgeLabel: UILabel {
    /// Background color of the badge
    @IBInspectable public var badgeColor: UIColor = UIColor.red {
        didSet {
            setNeedsDisplay()
        }
    }
    /// Width of the badge border
    @IBInspectable public var borderWidth: CGFloat = 0 {
        didSet {
            invalidateIntrinsicContentSize()
        }
    }
    /// Color of the badge border
    @IBInspectable public var borderColor: UIColor = UIColor.white {
        didSet {
            invalidateIntrinsicContentSize()
        }
    }
    /// Badge insets that describe the margin between text and the edge of the badge.
    @IBInspectable public var insets: CGSize = CGSize(width: 5, height: 2) {
        didSet {
            invalidateIntrinsicContentSize()
        }
    }
    // MARK: Badge shadow
    /// Opacity of the badge shadow
    @IBInspectable public var shadowOpacityBadge: CGFloat = 0.5 {
        didSet {
            layer.shadowOpacity = Float(shadowOpacityBadge)
            setNeedsDisplay()
        }
    }
    /// Size of the badge shadow
    @IBInspectable public var shadowRadiusBadge: CGFloat = 0.5 {
        didSet {
            layer.shadowRadius = shadowRadiusBadge
            setNeedsDisplay()
        }
    }
    /// Color of the badge shadow
    @IBInspectable public var shadowColorBadge: UIColor = UIColor.black {
        didSet {
            layer.shadowColor = shadowColorBadge.cgColor
            setNeedsDisplay()
        }
    }
    /// Offset of the badge shadow
    @IBInspectable public var shadowOffsetBadge: CGSize = CGSize(width: 0, height: 0) {
        didSet {
            layer.shadowOffset = shadowOffsetBadge
            setNeedsDisplay()
        }
    }
    /// Corner radius of the badge. -1 if unspecified. When unspecified, the corner is fully rounded. Default: -1.
    @IBInspectable public var cornerRadius: CGFloat = -1 {
        didSet {
            setNeedsDisplay()
        }
    }
//    /// Initialize the badge view
//    public convenience init() {
//        self.init(frame: CGRect())
//    }
    /// Initialize the badge view
    public override init(frame: CGRect) {
        super.init(frame: frame)

        setup()
    }
    /// Initialize the badge view
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        setup()
    }
    /// Add custom insets around the text
    public override func textRect(forBounds bounds: CGRect, limitedToNumberOfLines numberOfLines: Int) -> CGRect {
        let rect = super.textRect(forBounds: bounds, limitedToNumberOfLines: numberOfLines)

        var insetsWithBorder = actualInsetsWithBorder()
        let rectWithDefaultInsets = rect.insetBy(dx: -insetsWithBorder.width, dy: -insetsWithBorder.height)

        // If width is less than height
        // Adjust the width insets to make it look round
        if rectWithDefaultInsets.width < rectWithDefaultInsets.height {
            insetsWithBorder.width = (rectWithDefaultInsets.height - rect.width) / 2
        }
        let result = rect.insetBy(dx: -insetsWithBorder.width, dy: -insetsWithBorder.height)

        return result
    }
    /// Draws the label with insets
    public override func drawText(in rect: CGRect) {
        if cornerRadius >= 0 {
            layer.cornerRadius = cornerRadius
        } else {
            // Use fully rounded corner if radius is not specified
            layer.cornerRadius = rect.height / 2
        }

        let insetsWithBorder = actualInsetsWithBorder()
        let insets = UIEdgeInsets(
            top: insetsWithBorder.height,
            left: insetsWithBorder.width,
            bottom: insetsWithBorder.height,
            right: insetsWithBorder.width)

        let rectWithoutInsets = rect.inset(by: insets)

        super.drawText(in: rectWithoutInsets)
    }
    /// Draw the background of the badge
    public override func draw(_ rect: CGRect) {
        let rectInset = rect.insetBy(dx: borderWidth / 2, dy: borderWidth / 2)

        let actualCornerRadius = cornerRadius >= 0 ? cornerRadius : rect.height / 2

        var path: UIBezierPath?

        if actualCornerRadius == 0 {
            // Use rectangular path when corner radius is zero as a workaround
            // a glith in the left top corner with UIBezierPath(roundedRect).
            path = UIBezierPath(rect: rectInset)
        } else {
            path = UIBezierPath(roundedRect: rectInset, cornerRadius: actualCornerRadius)
        }

        badgeColor.setFill()
        path?.fill()

        if borderWidth > 0 {
            borderColor.setStroke()
            path?.lineWidth = borderWidth
            path?.stroke()
        }

        super.draw(rect)
    }
    private func setup() {
        textAlignment = NSTextAlignment.center
        clipsToBounds = false // Allows shadow to spread beyond the bounds of the badge
    }
    /// Size of the insets plus the border
    private func actualInsetsWithBorder() -> CGSize {
        return CGSize(
            width: insets.width + borderWidth,
            height: insets.height + borderWidth
        )
    }
    /// Draw the stars in interface builder
    public override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()

        setup()
        setNeedsDisplay()
    }
}
