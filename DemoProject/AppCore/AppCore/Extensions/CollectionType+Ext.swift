
public extension Collection {
    /// Returns the element at the specified index iff it is within bounds, otherwise nil.
    subscript(safe index: Index) -> Iterator.Element? {
        return index >= startIndex && index < endIndex ? self[index] : nil
    }
    /// Returns the element at the specified index iff it is within bounds, otherwise nil.
    func get(index: Index,
                    functionName: StaticString = #function, fileName: StaticString = #file, lineNumber: Int = #line)
        -> Iterator.Element {
            // TODO: Replace this with log.fatal
            precondition(index >= startIndex && index < endIndex,
                         "Index out of bounds in func \(functionName) in \(fileName):\(lineNumber)")
            return self[index]
    }
    func toArray() -> [Iterator.Element] {
        return Array(self)
    }
}

// Protocol that adds pairing to CollectionType classes
public protocol Pairs {}
// We need to make sure SubSequence.Generator.Element == Generator.Element
// https://airspeedvelocity.net/2016/01/03/generic-collections-subsequences-and-overloading/
public extension Pairs where Self: Collection {
    /// Create a tuple array of adjacent pairs. The resulting array is length count-1
    /// - Parameter withWrap: if true pairs the last element with the first.
    func pairs(withWrap: Bool = false) -> [(Self.Iterator.Element, Self.Iterator.Element)] {
        guard count >= 1 else { return [] }
        if withWrap == true {
            var tail = Array(dropFirst())
            tail.append(first!)
            return Array(zip(self, tail))
        } else {
            let tail = dropFirst()
            return Array(zip(self, tail))
        }
    }

    func maybePairs() -> [(first: Self.Iterator.Element, second: Self.Iterator.Element?)] {
        guard count >= 1 else { return [] }
        let second = dropFirst()
            .map { (elm: Self.Iterator.Element) -> Self.Iterator.Element? in return elm } + [nil]
        return zip(self, second).map { $0 }
    }
}

public extension Collection {
    func split(after index: Self.Index) -> ([Self.Iterator.Element], [Self.Iterator.Element]) {
        guard index >= startIndex else { return ([], map { $0 }) }
        guard index < endIndex else { return (map { $0 }, []) }
        return (prefix(upTo: index).map { $0 }, suffix(from: index).map { $0 })
    }

    func split(before index: Self.Index) -> ([Self.Iterator.Element], [Self.Iterator.Element]) {
        return split(after: self.index(index, offsetBy: -1))
    }
}

public extension Collection {
    func cons() -> (head: Self.Iterator.Element?, tail: [Self.Iterator.Element]) {
        guard let head = self.first else { return (head: nil, tail: []) }
        let tail = dropFirst().compactMap { $0 }
        return (head: head, tail: tail)
    }

    func bodyTip() -> (body: [Self.Iterator.Element], tip: Self.Iterator.Element?) {
        let last = suffix(1).map { $0 }.first
        guard let tip = last else { return (body: [], tip: nil) }
        let body = dropLast().compactMap { $0 }
        return (body: body, tip: tip)
    }

    func recReduce(_ combine: @escaping (Self.Iterator.Element, Self.Iterator.Element)
        -> Self.Iterator.Element) -> Self.Iterator.Element? {
        return first.map { head in
            self.dropFirst().compactMap { $0 }
                .recReduce(combine)
                .map { combine(head, $0) }
                ?? head
        }
    }
}

extension Array: Pairs {}
extension Set: Pairs {}
