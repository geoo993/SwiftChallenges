func * (lhs: Character, rhs: Int) -> String {
    return String(repeating: String(lhs), count: rhs)
}

public extension String {

    func tokenizeToWord() -> [String] {
        return self.tokenize(option: kCFStringTokenizerUnitWord)
    }

    func tokenizeToWordRemovingHyphenation() -> [String] {
        return self.filter { $0 != "-" }
            .tokenize(option: kCFStringTokenizerUnitWord)
    }

    func tokenizeToWordRanges() -> [CountableRange<Int>] {
        return self.tokenizeRanges(option: kCFStringTokenizerUnitWord)
    }

    func tokenizeToWordIndexRanges() -> [Range<String.Index>] {
        return self.tokenizeIndexRanges(option: kCFStringTokenizerUnitWord)
    }

    func tokenizeToSentences() -> [String] {
        return self.tokenize(option: kCFStringTokenizerUnitSentence)
    }

    func tokenizeToParagraphs() -> [String] {
        return self.tokenize(option: kCFStringTokenizerUnitParagraph)
    }

    func tokenizeToLineBreaks() -> [String] {
        return self.tokenize(option: kCFStringTokenizerUnitLineBreak)
    }

    private func tokenize(option: CFOptionFlags) -> [String] {
        return self.tokenizeRanges(option: option).map { self.substring(with: $0) }
    }

    private func tokenizeRanges(option: CFOptionFlags) -> [CountableRange<Int>] {
        let inputRange = CFRangeMake(0, self.utf16.count)
        let flag = UInt(option)
        let locale = CFLocaleCopyCurrent()
        let cfString: CFString = self as CFString
        let tokenizer = CFStringTokenizerCreate( kCFAllocatorDefault, cfString, inputRange, flag, locale)
        var tokenType = CFStringTokenizerAdvanceToNextToken(tokenizer)
        var tokenRanges: [CountableRange<Int>] = []
        let tokenTypeOptionSet: CFStringTokenizerTokenType = []
        while tokenType != tokenTypeOptionSet {
            let currentTokenRange = CFStringTokenizerGetCurrentTokenRange(tokenizer)
            let lower = Int(currentTokenRange.location)
            let upper = Int(currentTokenRange.location + currentTokenRange.length)
            let range = lower ..< upper
            tokenRanges.append(range)
            tokenType = CFStringTokenizerAdvanceToNextToken(tokenizer)
        }
        return tokenRanges
    }

    private func tokenizeIndexRanges(option: CFOptionFlags) -> [Range<String.Index>] {
        return tokenizeRanges(option: option).compactMap { self.range(fromCountableRange: $0) }
    }
    
    // Use linguistic tags to generate sentences from String
    func toLinguisticTagRanges() -> (tags: [String], ranges: [Range<String.Index>]) {
        var r = [Range<String.Index>]()
        let i = self.indices
        let t = self.linguisticTags(
            in: i.startIndex ..< i.endIndex,
            scheme: NSLinguisticTagScheme.lexicalClass.rawValue,
            options: .joinNames,
            orthography: nil,
            tokenRanges: &r)
        
        return (t, r)
    }
    // Use linguistic tags to generate sentences from String
    func toLinguisticWordRanges() -> (tags: [String], ranges: [Range<String.Index>]) {
        var r = [Range<String.Index>]()
        let i = self.indices
        let t = self.linguisticTags(
            in: i.startIndex ..< i.endIndex,
            scheme: NSLinguisticTagScheme.tokenType.rawValue,
            options: [.omitPunctuation, .omitWhitespace, .omitOther, .joinNames],
            orthography: nil,
            tokenRanges: &r)
        
        return (t, r)
    }

    private var regexSpecialCharactersBounderies: String {
        // https://regex101.com/
        return "[-'’%$#&/]\\b|\\b[‑'’%$#&/]|\\b[‐'’%$#&/]|\\d*\\.?\\d+|[A-Za-z0-9]|\\([A-Za-z0-9]"
    }

    private var regexWithSpecialCharactersWithinWords: String {
        // http://rubular.com/r/egE3v951RH
        return "(?<=\\s|^|\\b)(?:\(regexSpecialCharactersBounderies)+\\))+(?=\\s|$|\\b)"
    }

    private var regexWithCharactersAndPunctuations: String {
        // https://regex101.com/r/IpOqXy/17
        // https://stackoverflow.com/questions/42019240/regex-to-match-words-with-punctuation-but-not-punctuation-alone
        return "(?<=\\s|^|\\b)(?:\(regexSpecialCharactersBounderies)+\\))+(?=\\s|$|\\b)"
                + "|[^A-Za-z0-9\\s]"
    }

    func toWordsFromRegexIncludingSpecialCharactersWithinWords() -> [String] {
        return self[regexWithSpecialCharactersWithinWords]
                .matches()
    }

    func toRangesFromRegexIncludingSpecialCharactersWithinWords() -> [Range<Int>] {
        return self[regexWithSpecialCharactersWithinWords]
            .ranges()
            .map { $0.location ..< ($0.location + $0.length) }
    }

    func toWordsFromRegexIncludingSpecialCharactersWithinWordsAndPunctuations() -> [String] {
        return self[regexWithCharactersAndPunctuations]
            .matches()
    }

    func toNSRangesFromRegexIncludingSpecialCharactersWithinWordsAndPunctuations() -> [NSRange] {
        return self[regexWithCharactersAndPunctuations]
            .ranges()
    }

    func toRangesFromRegexIncludingSpecialCharactersWithinWordsAndPunctuations() -> [Range<Int>] {
        return self[regexWithCharactersAndPunctuations]
            .ranges()
            .map { $0.location ..< ($0.location + $0.length) }
    }

    func toWordsFromRegex() -> [String] {
        return self["(\\b[^\\s]+\\b)"].matches()
    }

    func toWordNSRangesFromRegex() -> [NSRange] {
        return self["(\\b[^\\s]+\\b)"].ranges()
    }

    func toWordRangesFromRegex() -> [Range<Int>] {
        return self["(\\b[^\\s]+\\b)"]
            .ranges()
            .map { $0.location ..< ($0.location + $0.length) }
    }

    func toWords() -> [String] {
        guard self.isEmpty == false else { return [] }
        let range = self.range(of: self)!
        var words = [String]()
        enumerateSubstrings(in: range, options: .byWords) { (substring, _, _, _) -> Void in
            words.append(substring!)
        }
        return words
    }

    func toWordRanges() -> [Range<String.Index>] {
        let wordRange = self.range(of: self)!
        var ranges = [Range<String.Index>]()

        enumerateSubstrings(in: wordRange, options: .byWords) { (_, range, _, _) -> Void in
            ranges.append(range)
        }
        return ranges
    }

    func indexAt(from: Int) -> String.Index {
        return self.index(startIndex, offsetBy: from)
    }

    private func substring(with range: CFRange) -> String {
        let nsrange = NSRange.init(location: range.location, length: range.length)
        let substring = (self as NSString).substring(with: nsrange)
        return substring
    }

    private func substring(with range: CountableRange<Int>) -> String {
        let nsrange = NSRange.init(location: range.lowerBound, length: range.count)
        let substring = (self as NSString).substring(with: nsrange)
        return substring
    }

    subscript(value: PartialRangeUpTo<Int>) -> Substring {
        get {
            return self[..<index(startIndex, offsetBy: value.upperBound)]
        }
    }

    subscript(value: PartialRangeThrough<Int>) -> Substring {
        get {
            return self[...index(startIndex, offsetBy: value.upperBound)]
        }
    }

    subscript(value: PartialRangeFrom<Int>) -> Substring {
        get {
            return self[index(startIndex, offsetBy: value.lowerBound)...]
        }
    }

    subscript(_ range: NSRange) -> String {
        let start = self.index(self.startIndex, offsetBy: range.lowerBound)
        let end = self.index(self.startIndex, offsetBy: range.upperBound)
        let subString = self[start..<end]
        return String(subString)
    }

    subscript (range: Range<Int>) -> String {
        let startIndex = self.index(self.startIndex, offsetBy: range.lowerBound)
        let endIndex = self.index(self.startIndex, offsetBy: range.count)
        return String(self[startIndex..<endIndex])
    }

    subscript (index: Int) -> Character {
        let charIndex = self.index(self.startIndex, offsetBy: index)
        return self[charIndex]
    }

    func substring(from: Int) -> String {
        let fromIndex = self.indexAt(from: from)
        return String(self[fromIndex...])
    }

    func substring(to toIndex: Int) -> String {
        let index = self.indexAt(from: toIndex)
        return String(self[..<index])
    }

    func substring(from fromIndex: Int, to toIndex: Int) -> String {
        let start = index(startIndex, offsetBy: fromIndex)
        let end = index(start, offsetBy: toIndex - fromIndex)
        return String(self[start ..< end])
    }

    func substring(withRange range: Range<Int>) -> String {
        let range = self.range(fromRangeInt: range)
        return String(self[range])
    }
    func substring(withCountableRange range: CountableRange<Int>) -> String {
        let range = self.range(fromRangeInt: range.toRangeInt)
        return String(self[range])
    }

    func substring(withNSRange range: NSRange) -> String {
        return substring(from: range.lowerBound, to: range.upperBound)
    }

    func contains(find: String) -> Bool {
        return self.range(of: find) != nil
    }

    func containsIgnoringCase(find: String) -> Bool{
        return self.range(of: find, options: .caseInsensitive) != nil
    }

    var nsRange: NSRange {
        return NSRange(location: 0, length: self.utf16.count)
    }

    func nsRange(fromStringIndex range: Range<String.Index>) -> NSRange {
        return NSRange(range, in: self)
    }

    func range(fromNSRange nsRange: NSRange) -> Range<String.Index>? {
        guard
            let from16 = utf16.index(utf16.startIndex, offsetBy: nsRange.location, limitedBy: utf16.endIndex),
            let to16 = utf16.index(from16, offsetBy: nsRange.length, limitedBy: utf16.endIndex),
            let from = String.Index(from16, within: self),
            let to = String.Index(to16, within: self)
            else { return nil }
        return from ..< to
    }

    func range(fromRangeInt rangeInt: Range<Int>) -> Range<String.Index> {
        let startIndex = self.indexAt(from: rangeInt.lowerBound)
        let endIndex = self.indexAt(from: rangeInt.upperBound)
        return startIndex..<endIndex
    }

    func range(from nsRange: NSRange) -> Range<String.Index> {
        let startIndex = indexAt(from: nsRange.location)
        let endIndex = indexAt(from: nsRange.location + nsRange.length)
        return startIndex..<endIndex
    }

    func range(fromRange range: Range<Int>) -> Range<String.Index> {
        let from = self.index(self.startIndex, offsetBy: range.lowerBound)
        let to = self.index(self.startIndex, offsetBy: range.upperBound)
        return from..<to
    }

    func range(fromCountableRange countableRange: CountableRange<Int>) -> Range<String.Index>? {
        guard
            let from16 = utf16.index(
                utf16.startIndex,
                offsetBy: countableRange.lowerBound,
                limitedBy: utf16.endIndex),
            let to16 = utf16.index(from16, offsetBy: countableRange.count, limitedBy: utf16.endIndex),
            let from = String.Index(from16, within: self),
            let to = String.Index(to16, within: self)
            else { return nil }
        return from ..< to
    }

    func ranges(from string: String) -> [NSRange] {
        let wordRangesInt = self.toWordRangesFromRegex()
        var ranges: [NSRange] = []
        for range in wordRangesInt {
            let wordToHighlight = self.substring(withRange: range)
            if string == wordToHighlight {
                let stringIndexRange = self.range(fromRangeInt: range)
                let nsRange = self.nsRange(fromStringIndex: stringIndexRange)
                ranges.append(nsRange)
            }
        }
        return ranges
    }

    func range(ofUniqueWord word: String) -> NSRange? {
        let words = self
            .toWordsFromRegexIncludingSpecialCharactersWithinWords()
            .elementFrequencyCounter()
        let ranges = self
            .toRangesFromRegexIncludingSpecialCharactersWithinWords()
        if let count = words[word],
            count < 2,
            let range = ranges.first(where: { self.substring(withRange: $0) == word }) {
            return range.toNSRange
        }
        return nil
    }

    func ranges(ofWord word: String) -> [NSRange] {
        let words = self
            .toWordsFromRegexIncludingSpecialCharactersWithinWords()
            .elementFrequencyCounter()
        let ranges = self
            .toRangesFromRegexIncludingSpecialCharactersWithinWords()
        if let count = words[word], count > 0 {
            return ranges
                .filter({ self.substring(withRange: $0) == word })
                .map({ $0.toNSRange })
        }
        return []
    }
    
    func ranges(ofLinguisticTag type: [String]) -> [Range<String.Index>] {
        let (tags, ranges) = toLinguisticTagRanges()
        return zip(tags, ranges)
            .filter({ type.contains($0.0) })
            .map({ $0.1 })
    }

    func replaceSpecialCharacters() -> String {
        return self
            .replacingOccurrences(of: "“", with: "\"")
            .replacingOccurrences(of: "”", with: "\"")
            .replacingOccurrences(of: "’", with: "'")
            .replacingOccurrences(of: "–", with: "-")
            .replacingOccurrences(of: "…", with: ".")
    }
    
    func replaceHypthensWithNonBreakingHyphens() -> String {
        let nonBreakingHyphen = "\u{2011}"
        let hyphen = "\u{2010}"
        let hyphenMinus = "\u{002D}"
        let otherHyphens = [hyphen, hyphenMinus]
        return otherHyphens.reduce(self) { string, hyphen  in
            return string.replacingOccurrences(of: hyphen, with: nonBreakingHyphen)
        }
    }

    static func replaceAt(str: String, index: Int, newCharac: String) -> String {
        return str.substring(to: index - 1)  + newCharac + str.substring(from: index)
    }

    func trimTrailingLeadingSpaces() -> String {
        return self["^\\s+|\\s+$|\\s+(?=\\s)"].replaceWith(template: "") as String
    }

    func highlight(words ranges: [NSRange], toColor color: UIColor) -> NSMutableAttributedString {
        let attributedString = NSMutableAttributedString(string: self)
        for range in ranges {
            attributedString.addAttributes([.foregroundColor: color], range: range)
        }
        return attributedString
    }

    func underLine(word range: NSRange, toColor color: UIColor,
                          style: NSUnderlineStyle) -> NSMutableAttributedString {
        let attributedString = NSMutableAttributedString(string: self)
            attributedString.addAttributes([.underlineStyle: style.rawValue,
                                            .foregroundColor: color], range: range)
        return attributedString
    }

    func underLine(words ranges: [NSRange], toColor color: UIColor,
                          style: NSUnderlineStyle) -> NSMutableAttributedString {
        let attributedString = NSMutableAttributedString(string: self)
        for range in ranges {
            attributedString.addAttributes([.underlineStyle: style.rawValue,
                                            .foregroundColor: color], range: range)
        }
        return attributedString
    }

    func getUniqueWords() -> [String] {
        let words = self.toWordsFromRegexIncludingSpecialCharactersWithinWords()
        return words.uniqueElements()
    }

    func toWordsWhileRemovingRepeatedWords() -> [String] {
        return self
            .toWordsFromRegexIncludingSpecialCharactersWithinWords()
            .removeRepeatedWords()
    }

    func getRepeatedWords() -> [String] {
        let words = self.toWordsFromRegexIncludingSpecialCharactersWithinWords()
        let wordsFrequency = words.elementFrequencyCounter()
        return wordsFrequency
            .filter({ $0.value > 1 })
            .map({$0.key })
    }

    func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constrainedSize = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(
            with: constrainedSize,
            options: .usesLineFragmentOrigin,
            attributes: [NSAttributedString.Key.font: font],
            context: nil)
        return ceil(boundingBox.height)
    }

    func width(withConstraintedHeight height: CGFloat, font: UIFont) -> CGFloat {
        let constrainedSize = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(
            with: constrainedSize,
            options: .usesLineFragmentOrigin,
            attributes: [NSAttributedString.Key.font: font],
            context: nil)
        return ceil(boundingBox.width)
    }

    func widthOfString(usingFont font: UIFont = UIFont.systemFont(ofSize: 17)) -> CGFloat {
        let text: String = self
        let fontAttributes = [NSAttributedString.Key.font: font]
        let size = (text as NSString).size(withAttributes: fontAttributes)
        return size.width
    }

    func heightOfString(usingFont font: UIFont = UIFont.systemFont(ofSize: 17)) -> CGFloat {
        let text: String = self
        let fontAttributes = [NSAttributedString.Key.font: font]
        let size = (text as NSString).size(withAttributes: fontAttributes)
        return size.height
    }

    func removeUnwantedCharacters(desiredSet: CharacterSet? = nil) -> String {
        let characterSet = desiredSet ?? CharacterSet.punctuationCharacters
        return self.components(separatedBy: characterSet).joined()
    }

    func removeSpecialCharacters() -> String {
        return self[regexSpecialCharactersBounderies]
                .matches().joined()
    }

    func toUIImage(with size: CGSize) -> UIImage {

        let baseSize = self.boundingRect(with: CGSize(width: 2048, height: 2048),
                                         options: .usesLineFragmentOrigin,
                                         attributes: [.font: UIFont.systemFont(ofSize: size.width / 2)],
                                         context: nil).size
        let fontSize = size.width / max(baseSize.width, baseSize.height) * (size.width / 2)
        let font = UIFont.systemFont(ofSize: fontSize)
        let textSize = self.boundingRect(with: CGSize(width: size.width, height: size.height),
                                         options: .usesLineFragmentOrigin,
                                         attributes: [.font: font],
                                         context: nil).size

        let style = NSMutableParagraphStyle()
        style.alignment = NSTextAlignment.center
        style.lineBreakMode = NSLineBreakMode.byClipping

        let attr : [NSAttributedString.Key : Any] = [NSAttributedString.Key.font : font,
                                                    NSAttributedString.Key.paragraphStyle: style,
                                                    NSAttributedString.Key.backgroundColor: UIColor.clear]

        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        (self as NSString).draw(in: CGRect(x: (size.width - textSize.width) / 2,
                                           y: (size.height - textSize.height) / 2,
                                           width: textSize.width,
                                           height: textSize.height),
                                withAttributes: attr)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        guard let img = image else { return UIImage() }
        return img
    }

    func pad(_ width: Int) -> String {
        return padding(toLength: width, withPad: " ", startingAt: 0)
    }

    static func timeString(time:TimeInterval) -> String {
        //let hours = Int(time) / 3600
        let minutes = Int(time) / 60 % 60
        let seconds = Int(time) % 60
        //return String(format: "%02i:%02i:%02i", hours, minutes, seconds)
        return String(format:"%02i:%02i", minutes, seconds)
    }

    // A simpler way to test all elements in a sequence is to use allSatisfy.
    var isBlank: Bool {
        return allSatisfy({ $0.isWhitespace })
    }
}

public extension Optional where Wrapped == String {
    var isBlank: Bool {
        return self?.isBlank ?? true
    }
}
