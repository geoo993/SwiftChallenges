extension Collection where Iterator.Element == String {
    public func getWords(withMinimumCharacterCount min: Int,
                         withMaximumCharacterCount max: Int) -> [String] {
        guard let words = self as? [String] else { return [] }
        return words.filter { ($0.count > min && $0.count < max) }
    }

    public func takeRandom(_ amount: Int, with minCharacterCount: Int) -> [String] {
        let words = filter({ $0.count >= minCharacterCount })
        return words.takeRandom(amount)
    }

    public var longestString: String? {
        return self.max(by: { ($1.count >= $0.count && $1.widthOfString() > $0.widthOfString()) })
    }

    public func removeRepeatedWords() -> [String] {
        guard let words = self as? [String] else { return [] }
        let wordsFrequency = words.elementFrequencyCounter()
        return wordsFrequency
            .filter({ $0.value == 1 })
            .map({ $0.key })
    }
}
