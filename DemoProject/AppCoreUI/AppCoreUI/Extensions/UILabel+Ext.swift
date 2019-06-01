
import Foundation
extension UILabel {
    //https://medium.com/@joncardasis/dynamic-text-resizing-in-swift-3da55887beb3
    /// Will auto resize the contained text to a font size which fits the frames bounds.
    /// Uses the pre-set font to dynamically determine the proper sizing
    func fitTextToBounds() {
        guard let text = text, let currentFont = font else { return }
        
        let bestFittingFont = UIFont.bestFittingFont(for: text, in: bounds, fontDescriptor: currentFont.fontDescriptor, additionalAttributes: basicStringAttributes)
        font = bestFittingFont
    }
    
    private var basicStringAttributes: [NSAttributedString.Key: Any] {
        var attribs = [NSAttributedString.Key: Any]()
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = self.textAlignment
        paragraphStyle.lineBreakMode = self.lineBreakMode
        attribs[.paragraphStyle] = paragraphStyle
        
        return attribs
    }
    
    func addOutLine(oulineColor: UIColor, foregroundColor: UIColor, outlineSize: CGFloat) {
        let strokeTextAttributes = [
            NSAttributedString.Key.strokeColor : oulineColor,
            NSAttributedString.Key.foregroundColor : foregroundColor,
            NSAttributedString.Key.strokeWidth : -outlineSize, // -4.0
            NSAttributedString.Key.font : self.font ?? UIFont.systemFont(ofSize: UIFont.systemFontSize)]
            as [NSAttributedString.Key : Any]
        self.attributedText = NSMutableAttributedString(string: self.text ?? "", attributes: strokeTextAttributes)
    }
    
    func addUnderline(foregroundColor: UIColor, style: NSUnderlineStyle) {
        if let textString = self.text {
            let underlineTextAttributes = [
                NSAttributedString.Key.foregroundColor : foregroundColor,
                NSAttributedString.Key.underlineStyle : style.rawValue,
                NSAttributedString.Key.font : font ?? UIFont.systemFont(ofSize: UIFont.systemFontSize)]
                as [NSAttributedString.Key : Any]
            self.attributedText = NSMutableAttributedString(string: textString, attributes: underlineTextAttributes)
        }
    }
}
