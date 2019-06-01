//
//  ProgressWaveView.swift
//  StoryView
//
//  Created by GEORGE QUENTIN on 11/06/2018.
//  Copyright © 2018 LEXI LABS. All rights reserved.
//
// https://gist.github.com/soggybag/722640423cbc412bfc05

import UIKit
import RxCocoa
import RxSwift
import AppCore

@IBDesignable
final public class ProgressWaveView: UIView {
    // MARK: IBInspectable properties
    @IBInspectable var steps: Int = 140 {
        didSet {
            progressBar()
        }
    }
    @IBInspectable var stepsRatio: CGFloat = 0.5 {
        didSet {
            progressBar()
        }
    }
    @IBInspectable var amplitude: CGFloat = 2 {
        didSet {
            progressBar()
        }
    }
    @IBInspectable var leftPadding: CGFloat = 10 {
        didSet {
            progressBar()
        }
    }
    @IBInspectable var rightPadding: CGFloat = 10 {
        didSet {
            progressBar()
        }
    }
    @IBInspectable public var progress: Double  = 0 {
        didSet {
            progressBar()
        }
    }
    @IBInspectable public var progressMax: Double  = 1 {
        didSet {
            progressBar()
        }
    }
    @IBInspectable var progressWidth: CGFloat = 5 {
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
    @IBInspectable var progressIndicatorColor: UIColor  = UIColor.weirdGreen {
        didSet {
            progressBar()
        }
    }
    @IBInspectable var progressIndicatorSize: CGFloat  = 14 {
        didSet {
            progressBar()
        }
    }
    private var progressPercentage: Double {
        let progressMax = max(self.progressMax, 0)
        return progress / progressMax
    }
    // MARK: - View Life Cycle
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
        progressBar()
    }
    public override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        setup()
        progressBar()
    }

    private func setup() {
        layer.sublayers = [waveBackground ,waveLayer, dotLayer]
    }

    public func animateProgress(toPercentage newProgress: Double, duration: Double = 1.0) {
        dotLayer.removeAllAnimations()
        dotLayer.speed = 1

        waveLayer.removeAllAnimations()
        waveLayer.speed = 1

        let animationPath = UIBezierPath()

        let subPoints = sineWavePoints
            .filter { progressPercentage < $0.percentage && $0.percentage < newProgress }

        guard let firstPoint = subPoints.first?.point else {
            self.progress = newProgress * progressMax
            return
        }
        animationPath.move(to: firstPoint)
        subPoints.forEach {
            animationPath.addLine(to: $0.point)
        }

        CATransaction.begin()
        CATransaction.setAnimationDuration(duration)
        CATransaction.setCompletionBlock({
            CATransaction.begin()
            CATransaction.setDisableActions(true)
            self.progress = newProgress * self.progressMax
            CATransaction.setDisableActions(false)
            CATransaction.commit()
        })

        let dotAnimation = CAKeyframeAnimation().then {
            $0.path = animationPath.cgPath
            $0.keyPath = "position"
            $0.duration = duration
            $0.fillMode = CAMediaTimingFillMode.forwards
            $0.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
            $0.isRemovedOnCompletion = false
        }
        dotLayer.add(dotAnimation, forKey: "position")
        let waveAnimation = CABasicAnimation().then {
            $0.keyPath = "strokeEnd"
            $0.duration = duration
            $0.fromValue = progressPercentage//
            $0.toValue = newProgress
            $0.isRemovedOnCompletion = false
        }
        waveLayer.add(waveAnimation, forKey: "strokeEnd")
        CATransaction.commit()
    }
    // MARK: - Setup Progress Bar
    lazy var waveBackground = CAShapeLayer().then {
        $0.fillColor = UIColor.clear.cgColor
        $0.lineCap = CAShapeLayerLineCap.round
    }
    lazy var waveLayer = CAShapeLayer().then {
        $0.fillColor = UIColor.clear.cgColor
        $0.strokeColor = progressColor.cgColor
        $0.lineCap = CAShapeLayerLineCap.round
    }
    lazy var dotLayer = CAShapeLayer().then {
        $0.bounds = CGRect(origin: .zero, size: CGSize(width: progressIndicatorSize, height: progressIndicatorSize))
    }

    private func progressBar() {
        waveBackground.then {
            $0.path = sineWavePath.cgPath
            $0.lineWidth = progressWidth
            $0.strokeColor = progressBackgroundColor.cgColor
        }
        waveLayer.then {
            $0.path = sineWavePath.cgPath

            $0.lineWidth = progressWidth
            $0.strokeEnd = progressPercentage.toCGFloat
        }
        dotLayer.then {
            $0.backgroundColor = progressIndicatorColor.cgColor
            $0.cornerRadius = progressIndicatorSize * 0.5
            $0.position = sineWavePath.point(atPercentOfLength: progressPercentage.toCGFloat)
        }
    }
    // MARK: - Bezier Path
    private var sineWavePoints: [(percentage: Double, point: CGPoint)] = []
    private var sineWavePath: UIBezierPath {
        // Draw a sine curve with a fill
        sineWavePoints.removeAll()
        sineWavePoints.reserveCapacity(steps)

        let midY = self.frame.height / 2          // find the vertical center
        let stepX = (self.frame.width - leftPadding - rightPadding ) / CGFloat(steps) // find the horizontal step distance
        let startPoint: CGPoint = CGPoint(x: leftPadding, y: midY)
        // Make a path
        let path = UIBezierPath()
        // Start in the mid y
        path.move(to: startPoint)
        sineWavePoints.append((0, startPoint))
        let perStep = 1.0 / steps.toDouble
        // steps divides the curve into steps, Loop and draw steps in straingt line segments
        for idx in 0...steps {
            let x = (idx.cg * stepX)
            let y = (sin(idx.toDouble * stepsRatio.toDouble) * amplitude.toDouble) + midY.toDouble
            let point = CGPoint(x: leftPadding + x, y: y.cg)
            sineWavePoints.append((percentage: idx.toDouble * perStep, point: point))
            path.addLine(to: point)
        }
        return path
    }
}

extension Reactive where Base : ProgressWaveView {

    /// Bindable sink for `progress` property.
    public var progress: Binder<Double> {
        return Binder(self.base) { view, progress in
            view.progress = progress
        }
    }

    /// Bindable sink for `progressMax` property.
    public var progressMax: Binder<Double> {
        return Binder(self.base) { view, max in
            view.progressMax = max
        }
    }

}
