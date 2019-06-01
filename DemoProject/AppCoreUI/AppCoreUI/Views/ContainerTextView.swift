//
//  ContainerTextView.swift
//  StoryExercise
//
//  Created by Daniel Asher on 10/12/2017.
//  Copyright © 2017 LEXI LABS. All rights reserved.
//
// swiftlint:disable line_length
import Foundation
import UIKit
/// This subclass of UITextView allows subviews to receive gesture touches.
// http://stackoverflow.com/questions/7719412/how-to-ignore-touch-events-and-pass-them-to-another-subviews-uicontrol-objects
@IBDesignable
final public class ContainerTextView: UITextView {
    @IBInspectable
    var paddingTop: CGFloat = 0 {
        didSet {
            setTextContainerInset()
        }
    }

    @IBInspectable
    var paddingBottom: CGFloat = 0 {
        didSet {
            setTextContainerInset()
        }
    }

    @IBInspectable
    var paddingLeft: CGFloat = 0 {
        didSet {
            setTextContainerInset()
        }
    }

    @IBInspectable
    var paddingRight: CGFloat = 0 {
        didSet {
            setTextContainerInset()
        }
    }

    @IBInspectable
    var gradientColor: UIColor = .clear {
        didSet { setupGradient() }
    }

    @IBInspectable
    var gradientVerticalEndPosition: CGFloat = 1.0 {
        didSet { setupGradient() }
    }

    public let gradientLayer = CAGradientLayer()

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        setup()
    }

    fileprivate func setupGradient() {
        gradientLayer.startPoint = CGPoint(x: 0, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 0, y: gradientVerticalEndPosition)
        gradientLayer.colors = [gradientColor.withAlphaComponent(0).cgColor, gradientColor.cgColor]
        gradientLayer.locations = [0, 1]
    }

    fileprivate func setup() {
        setupGradient()
        layer.addSublayer(gradientLayer)
    }

    public override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = bounds
    }

    func setTextContainerInset() {
        textContainerInset = UIEdgeInsets(
            top: paddingTop, left: paddingLeft, bottom: paddingBottom, right: paddingRight)
        invalidateIntrinsicContentSize()
    }

    public override var intrinsicContentSize: CGSize {
        var size = super.intrinsicContentSize
        size.width += paddingLeft + paddingRight
        size.height += paddingTop + paddingBottom
        return size
    }

    public override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        for subview in subviews.reversed() {
            let convertedPoint = subview.convert(point, from: self)
            let thisHitTestView = subview.hitTest(convertedPoint, with: event)
            if thisHitTestView != nil {
                return thisHitTestView
            }
        }
        return super.hitTest(point, with: event)
    }

    public func enumerateLineFragments(upTo maximum: Int = Int.max) -> [CGRect] {
        var lineRects: [CGRect] = []
        var counter = 0
        let range = text.nsRange(fromStringIndex: text.startIndex ..< text.endIndex)
        let glyphRange = layoutManager.glyphRange(forCharacterRange: range, actualCharacterRange: nil)
        layoutManager.enumerateLineFragments(forGlyphRange: glyphRange) { boundingRect, _, _, _, stop in
            guard counter <= maximum else { stop.pointee = true; return }
            lineRects.append(boundingRect)
            counter += 1
        }
        return lineRects
    }

    public func enumerateWordFramesByLine() -> [[CGRect]] {
        var wordFramesByLine: [[CGRect]] = []
        let nsText = text! as NSString
        let range = text.nsRange(fromStringIndex: text.startIndex ..< text.endIndex)
        let glyphRange = layoutManager.glyphRange(forCharacterRange: range, actualCharacterRange: nil)
        layoutManager.enumerateLineFragments(forGlyphRange: glyphRange) { _, _, _, glyphRange, _ in
            var wordFrames: [CGRect] = []
            nsText.enumerateSubstrings(in: glyphRange, options: .byWords, using: { _, wordRange, _, _ in
                let wordFrame = self.layoutManager.boundingRect(forGlyphRange: wordRange, in: self.textContainer)
                let paddingOffsetFrame = wordFrame.offsetBy(dx: self.paddingLeft, dy: self.paddingTop)
                wordFrames.append(paddingOffsetFrame)
            })
            wordFramesByLine.append(wordFrames)
        }
        return wordFramesByLine
    }

    public func enumerateWordsByLine() -> [[(word: String, frame: CGRect)]] {
        var wordFramesByLine: [[(String, CGRect)]] = []
        let nsText = text! as NSString
        let range = text.nsRange(fromStringIndex: text.startIndex ..< text.endIndex)
        let glyphRange = layoutManager.glyphRange(forCharacterRange: range, actualCharacterRange: nil)
        layoutManager.enumerateLineFragments(forGlyphRange: glyphRange) { _, _, _, glyphRange, _ in
            var wordFrames: [(String, CGRect)] = []
            nsText.enumerateSubstrings(in: glyphRange, options: .byWords, using: { _, wordRange, _, _ in
                let word = nsText.substring(with: wordRange)
                let wordFrame = self.layoutManager.boundingRect(forGlyphRange: wordRange, in: self.textContainer)
                let paddingOffsetFrame = wordFrame.offsetBy(dx: self.paddingLeft, dy: self.paddingTop)
                wordFrames.append((word, paddingOffsetFrame))
            })
            wordFramesByLine.append(wordFrames)
        }
        return wordFramesByLine
    }

    public func getBoundingRect(for characterRange: CountableRange<Int>) -> CGRect {
        let range = characterRange.toNSRange
        let glyphRange = layoutManager.glyphRange(forCharacterRange: range, actualCharacterRange: nil)
        let wordFrame = layoutManager.boundingRect(forGlyphRange: glyphRange, in: self.textContainer)
        let paddingOffsetFrame = wordFrame.offsetBy(dx: self.paddingLeft, dy: self.paddingTop)
        return paddingOffsetFrame
    }

    public var trimmedContentHeight: CGFloat {
        let textTotalHeight = enumerateLineFragments()
            .reduce(0, { total, rect in
                total + rect.height
            })
        return textTotalHeight + paddingTop + paddingBottom
    }

    public var lineSpacing: CGFloat {
        get {
            let paragraphStyle = attributedText
                .attribute(.paragraphStyle, at: 0, effectiveRange: nil) as? NSParagraphStyle
            return paragraphStyle?.lineSpacing ?? 0
        }
        set {
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = newValue
            let newText = NSMutableAttributedString(attributedString: attributedText)
            let range = NSRange(location: 0, length: attributedText.length)
            newText.addAttribute(.paragraphStyle, value: paragraphStyle, range: range)
            attributedText = newText
        }
    }
}
