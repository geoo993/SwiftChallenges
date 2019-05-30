
extension NSUnderlineStyle {
    public static var none: NSUnderlineStyle {
        return NSUnderlineStyle.init(rawValue: 0)
    }
}

extension NSAttributedString {
    public func with(string: String) -> NSAttributedString? {
        let mutableAttributedText = self.mutableCopy()
        (mutableAttributedText as AnyObject).mutableString.setString(string)
        return mutableAttributedText as? NSAttributedString
    }

    public func color(words: [(NSRange, UIColor)], with style: NSUnderlineStyle?) -> NSMutableAttributedString {
        let stringStyle = style ?? []
        let attributedString: NSMutableAttributedString = NSMutableAttributedString(attributedString: self)
        for (range, color) in words {
            attributedString.addAttributes([.foregroundColor: color, .underlineStyle: stringStyle.rawValue], range: range)
        }
        return attributedString
    }
    
    public func color(words: [(NSRange, UIColor)], with font: UIFont, style: NSUnderlineStyle?) -> NSMutableAttributedString {
        let stringStyle = style ?? []
        let attributedString: NSMutableAttributedString = NSMutableAttributedString(attributedString: self)
        for (range, color) in words {
            attributedString.addAttributes([.foregroundColor: color,
                                            .font: font,
                                            .underlineStyle: stringStyle.rawValue],
                                           range: range)
        }
        return attributedString
    }
    
    public func clear(with color: UIColor, using clearFont: UIFont, thenColor words: [(NSRange, UIColor)],
                      with font: UIFont, style: NSUnderlineStyle?) -> NSMutableAttributedString {
        
        let attributedString = NSMutableAttributedString(attributedString: self)
        attributedString.addAttributes([
            .foregroundColor: color,
            .font: clearFont,
            .underlineStyle: NSUnderlineStyle.none.rawValue
            ], range: NSRange(location: 0, length: self.length))

        let stringStyle = style ?? []
        for (range, color) in words {
            attributedString.addAttributes([.foregroundColor: color,
                                            .font: font,
                                            .underlineStyle: stringStyle.rawValue],
                                           range: range)
        }
        return attributedString
    }
    
    public func highlight(toColor color: UIColor) -> NSMutableAttributedString {
        let range = NSRange(location: 0, length: length)
        let attributedString = NSMutableAttributedString(attributedString: self)
        attributedString.addAttributes([
            .foregroundColor: color,
            .underlineStyle: NSUnderlineStyle.none.rawValue
        ], range: range)
        return attributedString
    }

    public func highlight(word range: NSRange, toColor color: UIColor) -> NSMutableAttributedString {
        let attributedString = NSMutableAttributedString(attributedString: self)
        attributedString.addAttributes([
            .foregroundColor: color,
            .underlineStyle: NSUnderlineStyle.none.rawValue
        ], range: range)
        return attributedString
    }

    public func highlight(words ranges: [NSRange], toColor color: UIColor) -> NSMutableAttributedString {
        let attributedString = NSMutableAttributedString(attributedString: self)
        for range in ranges {
            attributedString.addAttributes([
                .foregroundColor: color,
                .underlineStyle: NSUnderlineStyle.none.rawValue
            ], range: range)
        }
        return attributedString
    }

    public func underLine(toColor color: UIColor, style: NSUnderlineStyle) -> NSMutableAttributedString {
        let range = NSRange(location: 0, length: length)
        let attributedString = NSMutableAttributedString(attributedString: self)
        attributedString.addAttributes([
            .foregroundColor: color,
            .underlineStyle: style.rawValue
            ], range: range)
        return attributedString
    }
    
    public func underLine(word range: NSRange, toColor color: UIColor,
                          style: NSUnderlineStyle) -> NSMutableAttributedString {
        let attributedString = NSMutableAttributedString(attributedString: self)
        attributedString.addAttributes([
            .foregroundColor: color,
            .underlineStyle: style.rawValue
        ], range: range)
        return attributedString
    }

    public func underLine(words ranges: [NSRange], toColor color: UIColor,
                          style: NSUnderlineStyle) -> NSMutableAttributedString {
        let attributedString = NSMutableAttributedString(attributedString: self)
        for range in ranges {
            attributedString.addAttributes([
                .foregroundColor: color,
                .underlineStyle: style.rawValue
            ], range: range)
        }
        return attributedString
    }

    public func strikeThroughLines(words ranges: [NSRange],
                                   toColor color: UIColor,
                                   style: NSUnderlineStyle) -> NSMutableAttributedString {
        let attributedString = NSMutableAttributedString(attributedString: self)
        for range in ranges {
            attributedString.addAttributes([
                .foregroundColor: color,
                .strikethroughStyle: style.rawValue
            ], range: range)
        }
        return attributedString
    }

    public var attributes: [NSAttributedString.Key: Any] {
        guard length > 0 else { return [:] }
        return attributes(at: 0,
                          longestEffectiveRange: nil,
                          in: NSRange(location: 0, length: length))
    }

    public var font: UIFont {
        guard attributes.keys.contains(.font) else { return UIFont.systemFont(ofSize: 17) }
        return attributes[NSAttributedString.Key.font] as! UIFont
    }

    public var paragraphStyle: NSParagraphStyle? {
        guard attributes.keys.contains(.paragraphStyle) else { return nil }
        return attributes[NSAttributedString.Key.paragraphStyle] as? NSParagraphStyle
    }

    public var lineHeight: CGFloat {
        guard let paragraphStyle = self.paragraphStyle else { return 0 }
        let lineHeight = font.lineHeight
        let lineHeightMultiple = paragraphStyle.lineHeightMultiple
        return lineHeight * ((lineHeightMultiple.isZero) ? 1 : lineHeightMultiple)
    }

    public var lineSpacing: CGFloat {
        return paragraphStyle?.lineSpacing ?? 0
    }

    public var lineBreakMode: NSLineBreakMode {
        return paragraphStyle?.lineBreakMode ?? .byWordWrapping
    }

    public var textAlignment: NSTextAlignment {
        return paragraphStyle?.alignment ?? NSTextAlignment.natural
    }

    public var backgroundColor: UIColor? {
        guard attributes.keys.contains(.backgroundColor) else { return nil }
        return attributes[NSAttributedString.Key.backgroundColor] as? UIColor
    }

    public var textColor: UIColor? {
        guard attributes.keys.contains(.foregroundColor) else { return nil }
        return attributes[NSAttributedString.Key.foregroundColor] as? UIColor
    }

    public func font(at location: Int) -> UIFont? {
        if let font =
            self.attributes(at: location, effectiveRange: nil)[NSAttributedString.Key.font]
            as? UIFont {
            return font
        }
        return nil
    }

    public func lineHeight(at location: Int) -> CGFloat? {
        guard
            let paragraphStyle =
            self.attributes(at: location, effectiveRange: nil)[NSAttributedString.Key.paragraphStyle]
            as? NSParagraphStyle, let font = self.font(at: location) else {
            return self.font.lineHeight
        }
        let lineHeightMultiple = paragraphStyle.lineHeightMultiple
        return font.lineHeight * ((lineHeightMultiple.isZero) ? 1 : lineHeightMultiple)
    }

    public func textAlignment(at location: Int) -> NSTextAlignment? {
        guard let paragraphStyle =
            self.attributes(at: location, effectiveRange: nil)[NSAttributedString.Key.paragraphStyle]
            as? NSParagraphStyle else {
            return nil
        }
        return paragraphStyle.alignment
    }

    public func mutableAttributedString(from range: NSRange) -> NSMutableAttributedString {
        return NSMutableAttributedString(attributedString: attributedSubstring(from: range))
    }

    public func boundingWidth(options: NSStringDrawingOptions, context: NSStringDrawingContext?) -> CGFloat {
        return boundingRect(options: options, context: context).size.width
    }

    public func boundingRect(options: NSStringDrawingOptions, context: NSStringDrawingContext?) -> CGRect {
        return boundingRect(with: CGSize(width: CGFloat.greatestFiniteMagnitude,
                                         height: CGFloat.greatestFiniteMagnitude),
                            options: options,
                            context: context)
    }

    public func boundingRectWithSize(with size: CGSize,
                                     options: NSStringDrawingOptions,
                                     numberOfLines: Int,
                                     context: NSStringDrawingContext?) -> CGRect {
        return boundingRect(with: CGSize(width: size.width,
                                         height: lineHeight * CGFloat(numberOfLines)),
                            options: options,
                            context: context)
    }
}
