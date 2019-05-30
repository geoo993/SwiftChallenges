public extension Array where Element: Comparable {
    func containsSameElements(as other: [Element]) -> Bool {
        return count == other.count && sorted() == other.sorted()
    }
}

public extension Array where Element: Equatable {
    func containsSubsetElements(subset: [Element]) -> Bool {
        return subset.reduce(true) { (result, item) in
            return result && contains(item)
        }
    }

    func allEqual() -> Bool {
        if let firstElem = first {
            return !dropFirst().contains { $0 != firstElem }
        }
        return true
    }

    func next(item: Element) -> Element? {
        if let index = self.firstIndex(of: item), index + 1 <= self.count {
            return index + 1 == self.count ? self[0] : self[index + 1]
        }
        return nil
    }

    func prev(item: Element) -> Element? {
        if let index = self.firstIndex(of: item), index >= 0 {
            return index == 0 ? self.last : self[index - 1]
        }
        return nil
    }

    mutating func move(_ item: Element, to newIndex: Index) {
        if let index = firstIndex(of: item) {
            _ = move(at: index, to: newIndex)
        }
    }
    
    mutating func bringToFront(item: Element) {
        move(item, to: 0)
    }
    
    mutating func sendToBack(item: Element) {
        move(item, to: endIndex-1)
    }
}

public extension Array {
    mutating func move(at index: Index, to newIndex: Index) -> Array<Element> {
        var result = self
        result.insert(remove(at: index), at: newIndex)
        return result
    }
    
    subscript(safe index: Int) -> Element? {
        return indices ~= index ? self[index] : nil
    }

    /// Takes one element randomly from the array
    func chooseOneRandomly() -> Element? {
        let list: [Element] = self
        guard list.count > 1 else { return nil }

        let len = UInt32(list.count)
        let random = Int(arc4random_uniform(len))
        return list[random]
    }

    /// Take a certain amount of from the array, provided that the amount elements in the array
    // is less than the amount needed. This retrun a random amount of element from the array
    func takeRandom(_ amount: Int) -> [Element] {
        var list = self
        guard list.count > 1, amount <= list.count else { return self }

        var temp: [Array.Iterator.Element] = []
        var count = amount

        while count > 0 {
            let index = Int(arc4random_uniform(UInt32(list.count - 1)))
            temp.append(list[index])
            list.remove(at: index)
            count -= 1
        }
        return temp
    }

    /// Shuffles the elements within the array
    func shuffle() -> [Element] {
        var list = self
        guard list.isEmpty == false else { return self }

        var results: [Array.Iterator.Element] = []
        var indexes = (0 ..< count).map { $0 }
        while indexes.isEmpty == false {
            let indexOfIndexes = Int(arc4random_uniform(UInt32(indexes.count)))
            let index = indexes[indexOfIndexes]
            results.append(list[index])
            indexes.remove(at: indexOfIndexes)
        }
        return results
    }

    /// Randomises the elements within the array
    func randomise() -> [Element] {
        var list = self
        guard list.isEmpty == false else { return self }

        var temp: [Array.Iterator.Element] = []

        while list.isEmpty == false {
            let index = Int(arc4random_uniform(UInt32(list.count - 1)))
            temp.append(list[index])
            list.remove(at: index)
        }
        return temp
    }

    func splitBy(_ subSize: Int) -> [[Element]] {
        return stride(from: 0, to: self.count, by: subSize).map {
            Array(self[$0..<Swift.min($0 + subSize, self.count)])
        }
    }
}

public extension Array where Element: Hashable {
    typealias Element = Array.Iterator.Element

    /// Converts the array into a unique set of elements
    func uniqueElements() -> [Element] {
        let list = self
        if list.isEmpty { return self }

        // Convert array into a set to get unique values.
        let uniques = Set<Element>(list)
        // Convert set back into an Array of Ints.
        let result = Array(uniques)
        return result
    }

    /// Swaps first and last element in array
    func swap(first: Element, last: Element) -> [Element] {
        var list: [Element] = self
        if let index1 = list.firstIndex(of: first),
            let index2 = list.firstIndex(of: last) {
            list.swapAt(index1, index2)
        }
        return list
    }

    /// Returns the number of times an element appears in an array
    func elementFrequencyCounter() -> [Element: Int] {
        return reduce(into: [:]) { (acc: inout [Element: Int], element) in
            acc[element] = acc[element]?.advanced(by: 1) ?? 1
        }
    }
}

extension Sequence {
    public func toDictionary<K: Hashable, V>(_ selector: (Iterator.Element) throws -> (K, V)?)
        rethrows -> [K: V] {
        var dict = [K: V]()
        for element in self {
            if let (key, value) = try selector(element) {
                dict[key] = value
            }
        }

        return dict
    }
}

extension Array where Element == Int {
    func sum() -> Element {
        return self.reduce(0) { acc, int in
            return acc + int
        }
    }
}

extension Array  {
    /// Chooses a element randomly then removes it from the array.
    ///
    /// - Returns: a randomly chosen element from the array or nil if the array is empty.
    mutating func chooseAndRemove() -> Element? {
        guard count > 0 else { return nil }
        let index = arc4random_uniform(UInt32(count))
        return self.remove(at: Int(index))
    }
    /// Generates an array of elements picked at random with non-repeating behavior.
    ///
    /// - Parameters:
    ///   - n: the length of the required output array
    ///   - order: the minimum number of contiguous non-repeating elements allow in the list.
    /// - Returns: An array of length N with random elements chosen from the the input array.
    func createRandomSelection(ofLength n: Int, ofRepetitionOrder order: Int) -> [Element] {
        guard count > 1 else { return [] }
        let order = Swift.max(order, count - 1)
        var currentChoices = self
        var oldChoices: [Element] = []
        var resultChoices: [Element] = []
        for _ in 1...n {
            guard let result = currentChoices.chooseAndRemove() else { break }
            oldChoices.insert(result, at: 0)
            if oldChoices.count > order {
                let oldChoice = oldChoices.remove(at: order)
                currentChoices.append(oldChoice)
            }
            resultChoices.append(result)
        }
        return resultChoices
    }
}

extension Sequence where Iterator.Element: SignedNumeric & Comparable {
    
    /// Finds the nearest (offset, element) to the specified element.
    func nearestOffsetAndElement(to toElement: Iterator.Element) -> (offset: Int, element: Iterator.Element) {
        guard let nearest = enumerated().min( by: {
            let left = $0.1 - toElement
            let right = $1.1 - toElement
            return abs(left) <= abs(right)
        } ) else {
            return (offset: 0, element: toElement)
        }
        return nearest
    }
    public func nearestElement(to element: Iterator.Element) -> Iterator.Element {
        return nearestOffsetAndElement(to: element).element
    }
    public func indexOfNearestElement(to element: Iterator.Element) -> Int {
        return nearestOffsetAndElement(to: element).offset
    }
}
