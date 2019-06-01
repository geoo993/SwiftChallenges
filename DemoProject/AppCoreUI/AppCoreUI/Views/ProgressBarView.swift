//
//  ProgressBarView.swift
//  StoryView
//
//  Created by GEORGE QUENTIN on 12/06/2018.
//  Copyright © 2018 LEXI LABS. All rights reserved.
//
import AppCore

@IBDesignable
final public class ProgressBarView: UIView {

    @IBInspectable var vertical: Bool = false {
        didSet {
            progressBar()
        }
    }

    @IBInspectable public var progress: CGFloat  = 0 {
        didSet {
            progressBar()
        }
    }

    @IBInspectable public var minValue: CGFloat  = 0 {
        didSet {
            progressBar()
        }
    }

    @IBInspectable public var maxValue: CGFloat  = 100 {
        didSet {
            progressBar()
        }
    }

    @IBInspectable var progressColor: UIColor = UIColor.darkSkyBlue {
        didSet {
            progressBar()
        }
    }

    @IBInspectable var progressBackgroundColor: UIColor = UIColor.skyBlue {
        didSet {
            progressBar()
        }
    }

    // MARK: - View Life Cycle
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)
    }

    public override func draw(_ rect: CGRect) {
        super.draw(rect)
        progressBar()
    }

    public override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        progressBar()
    }

    // MARK: - Progress Bar

    fileprivate func progressBar() {
        let value: CGFloat = progress.percentageValueBetween(maxValue: maxValue, minValue: minValue)
        let percentage: CGFloat = value.clamped(to: CGFloat(0.0)...CGFloat(100.0))
        let point: CGFloat = (percentage / 100.0).clamped(to: CGFloat(0.0)...CGFloat(0.99999))
        let location: NSNumber = NSNumber(value: point.toFloat)
        let gradientLayer = CAGradientLayer().then {
            $0.frame = bounds
            $0.colors = [progressColor.cgColor,
                         progressBackgroundColor.cgColor]
            $0.locations = [location, location]
        }

        gradientLayer.startPoint = vertical ? CGPoint(x: 0.5, y: 0.0) : CGPoint(x: 0.0, y: 0.5)
        gradientLayer.endPoint = vertical ? CGPoint(x: 0.5, y: 1.0) : CGPoint(x: 1.0, y: 0.5)

        layer.sublayers = [gradientLayer]
    }
}
