// https://stackoverflow.com/questions/27040924/nsrange-from-swift-range

public extension UITextView {
    func textRangeToIntRange(range textRange: UITextRange) -> CountableRange<Int> {
        return range(from: textRange)
    }

    func range(from textRange: UITextRange) -> CountableRange<Int> {
        let start = offset(from: beginningOfDocument, to: textRange.start)
        let end = offset(from: beginningOfDocument, to: textRange.end)
        return start ..< end
    }

    func clearTextView(with color: UIColor) {
        guard let attribute = self.attributedText.mutableCopy() as? NSMutableAttributedString else { return }
        let fullrange = fullNSRange()
        attribute.addAttributes([NSAttributedString.Key.foregroundColor: color], range: fullrange)
        attributedText = attribute
    }

    func allNSRanges() -> [NSRange] {
        let textRange = text.startIndex ..< text.endIndex
        var ranges = [NSRange]()
        text
            .enumerateSubstrings(
                in: textRange,
                options: NSString.EnumerationOptions.byWords, { _, substringRange, _, _ in
                    let range = NSRange(substringRange, in: self.text)
                    ranges.append(range)
            })
        return ranges
    }

    func fullNSRange() -> NSRange {
        let textRange = text.startIndex ..< text.endIndex
        return NSRange(textRange, in: text)
    }

    func nsRange(from range: Range<Int>) -> NSRange {
        return NSRange(location: range.lowerBound, length: range.upperBound)
    }

    func rangeToIndex(from range: Range<Int>) -> Range<String.Index> {
        let startIndex = text.index(text.startIndex, offsetBy: range.lowerBound)
        let endIndex = text.index(startIndex, offsetBy: range.upperBound - range.lowerBound)
        return startIndex ..< endIndex
    }

    func rectForRange(range: Range<Int>) -> CGRect? {
        return rect(fromRange: range)
    }

    func rect(fromRange range: CountableRange<Int>) -> CGRect? {
        guard let start = self.position(from: self.beginningOfDocument, offset: range.lowerBound),
            let end = self.position(from: start, offset: range.count),
            let textRange = self.textRange(from: start, to: end)
        else {
            return nil }
        let rect = firstRect(for: textRange)

        // let offset = self.contentOffset
        return rect // .offsetBy(dx: -offset.x, dy: -offset.y)
    }
    // TODO: SWIFT4-2 Verify commenting the following `Invalid redeclaration of 'rect(fromRange:)'` is correct.
//    public func rect(fromRange range: Range<Int>) -> CGRect? {
//        guard
//            let start = self.position(from: self.beginningOfDocument, offset: range.lowerBound),
//            let end = self.position(from: self.beginningOfDocument, offset: range.upperBound),
//            let textRange = self.textRange(from: start, to: end)
//        else {
//            return nil }
//        let rect = firstRect(for: textRange)
//
//        // let offset = self.contentOffset
//        return rect // .offsetBy(dx: -offset.x, dy: -offset.y)
//    }

    func numberOfLines() -> Int {
        let layoutManager = self.layoutManager
        let numberOfGlyphs = layoutManager.numberOfGlyphs
        var lineRange: NSRange = NSRange(location: 0, length: 1)
        var index = 0
        var numberOfLines = 0

        while index < numberOfGlyphs {
            layoutManager.lineFragmentRect(forGlyphAt: index, effectiveRange: &lineRange)
            index = NSMaxRange(lineRange)
            numberOfLines += 1
        }
        return numberOfLines
    }
}
