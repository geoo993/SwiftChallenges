import Foundation

func example(of description: String, action: () -> Void) {
  print("\n--- Example of:", description, "---")
  action()
}

// Binary search is one of the most efficient searching algorithms with a time complexity of O(log n).
// This is comparable with searching for an element inside a balanced binary search tree.

// There are two conditions that need to be met before binary search may be used:
// - The collection must be able to perform INDEX manipulation in constant time. This means that the collection must be a RandomAccessCollection.
// - The collection must be SORTED.


// Binary search handles things in a way that takes advantage of the fact that the collection is already sorted.

// Imagine an array: [1, 5, 15, 17, 19, 22, 24, 31, 101, 120]

// Instead of eight steps to find 31, it only takes three. Here’s how it works:
// - Step 1: Find middle index
// The first step is to find the middle index of the collection. This is fairly straightforward: 21
// - Step 2: Check the element at the middle index
// The next step is to check the element stored at the middle index. If it matches the value you’re looking for, you return the index. Otherwise, you’ll continue to Step 3.

// Step 3: Recursively call binary Search
// The final step is to recursively call binary search.
// However, this time, you’ll only consider the elements exclusively to the left or to the right of the middle index, depending on the value you’re searching for.
// If the value you’re searching for is less than the middle value, you search the left subsequence.
// If it is greater than the middle value, you search the right subsequence.

// Each step effectively removes half of the comparisons you would otherwise need to perform.
// Binary search achieves an O(log n) time complexity this way.


// 1 - Since binary search only works for types that conform to RandomAccessCollection, you add the method in an extension on RandomAccessCollection.
// This extension is constrained as you need to be able to compare elements.
extension RandomAccessCollection where Element: Comparable {
  // 2 - Binary search is recursive, so you need to be able to pass in a range to search. The parameter range is made optional so you can start the search without having to specify a range. In this case, where range is nil, the entire collection will be searched.
    func binarySearch(
        for value: Element,
        in range: Range<Index>? = nil
    ) -> Index? {
        // 1 - First, you check if range was nil. If so, you create a range that covers the entire collection.
        let range = range ?? startIndex..<endIndex
        // 2 - Then, you check if the range contains at least one element. If it doesn’t, the search has failed and you return nil.
        guard range.lowerBound < range.upperBound else {
            return nil
        }
        // 3 - Now that you’re sure you have elements in the range, you find the middle index in the range.
        let size = distance(from: range.lowerBound, to: range.upperBound)
        let middle = index(range.lowerBound, offsetBy: size / 2)
        // 4 - You then compare the value at this index with the value that you’re searching for. If they match, you return the middle index.
        if self[middle] == value {
            return middle
            // 5 - If not, you recursively search either the left or right half of the collection.
        } else if self[middle] > value {
            return binarySearch(for: value, in: range.lowerBound..<middle)
        } else {
            return binarySearch(for: value, in: index(after: middle)..<range.upperBound)
        }
    }
}

example(of: "Binary search") {
    let array = [1, 5, 15, 17, 19, 22, 24, 31, 105, 150]
    
    let search31 = array.firstIndex(of: 31)
    let binarySearch31 = array.binarySearch(for: 31)
    
    print("firstIndex(of:): \(String(describing: search31))")
    print("binarySearch(for:): \(String(describing: binarySearch31))")
}

// Binary search is a powerful algorithm to learn and comes up often in programming interviews.
// Whenever you read something along the lines of “Given a sorted array…”, consider using the binary search algorithm. Also, if you are given a problem that looks like it is going to be O(n²) to search, consider doing some up-front sorting so you can use binary searching to reduce it down to the cost of the sort at O(n log n).


// Key points
// - Binary search is only a valid algorithm on sorted collections.
// - Sometimes, it may be beneficial to sort a collection just to leverage the binary search capability for looking up elements.
// - The firstIndex(of:) method on sequences uses linear search, which has a O(n) time complexity. Binary search has a O(log n) time complexity, which scales much better for large data sets if you are doing repeated lookups.


// Challenge 1: Binary search as a free function
// You implemented binary search as an extension of the RandomAccessCollection protocol.
// Since binary search only works on sorted collections, exposing the function as part of RandomAccessCollection will have a chance of misuse.
// Your challenge is to implement binary search as a free function.

func search<C: RandomAccessCollection, V: Comparable, I>(for value: V, in collection: C, in range: Range<I>? = nil) -> I?
where V == C.Element, I == C.Index
{
    let range = range ?? collection.startIndex..<collection.endIndex
    guard range.lowerBound < range.upperBound else {
        return nil
    }
    let size = collection.distance(from: range.lowerBound, to: range.upperBound)
    let middle = collection.index(range.lowerBound, offsetBy: size / 2)
    if collection[middle] == value {
        return middle
    } else if collection[middle] > value {
        return search(for: value, in: collection, in: range.lowerBound..<middle)
    } else {
        return search(for: value, in: collection, in: collection.index(after: middle)..<range.upperBound)
    }
}

example(of: "Binary search function") {
    let array = [1, 5, 15, 17, 19, 22, 24, 31, 105, 150]
    let binarySearch31 = search(for: 31, in: array)
    print("search(for:): \(String(describing: binarySearch31))")
}

// Challenge 2: Searching for a range
// Write a function that searches a sorted array and that finds the range of indices for a particular element.
// For example: let array = [1, 2, 3, 3, 3, 4, 5, 5]
// findIndices(of: 3, in: array)

// findIndices should return the range 2..<5, since those are the start and end indices for the value 3.

func findIndices(of value: Int, in array: [Int]) -> Range<Int>? {
    guard let leftIndex = array.firstIndex(of: value) else {
        return nil
    }
    guard let rightIndex = array.lastIndex(of: value) else {
        return nil
    }
    return leftIndex..<rightIndex
}

example(of: "Find Indices") {
    let array = [1, 2, 3, 3, 3, 4, 5, 5]
    let indices = findIndices(of: 3, in: array)
    print("findIndices(of:): \(String(describing: indices))")
}

// The time complexity of this solution is O(n), which may not seem to be a cause for concern.
// However, the solution can be optimized to a O(_log n) time complexity solution.


// Binary search is an algorithm that identifies values in a sorted collection, so keep that in mind whenever the problem promises a SORTED collection. The binary search you implemented in the theory chapter is not powerful enough to reason whether the index is a start or end index.
// We modify the binary search that you learned to accommodate for this new rule.

func indices(
    of value: Int,
    in array: [Int]
) -> CountableRange<Int>? {
    guard let startIndex = startIndex(
        of: value,
        in: array,
        range: 0..<array.count
    ) else {
        return nil
    }
    guard let endIndex = endIndex(
        of: value,
        in: array,
        range: 0..<array.count
    ) else {
        return nil
    }
    return startIndex..<endIndex
}

func startIndex(
    of value: Int,
    in array: [Int],
    range: CountableRange<Int>
) -> Int? {
    // 1 - You start by calculating the middle value of the indices contained in range.
    let middleIndex = range.lowerBound + (range.upperBound - range.lowerBound) / 2
    
    // 2 - This is the base case of this recursive function. If the middle index is the first or last accessible index of the array, you don’t need to call binary search any further. You’ll make the determination on whether or not the current index is a valid bound for the given value.
    if middleIndex == 0 || middleIndex == array.count - 1 {
        if array[middleIndex] == value {
            return middleIndex
        } else {
            return nil
        }
    }
    
    // 3 - Here, you check the value at the index and make your recursive calls. If the value at middleIndex is equal to the value you’re given, you check to see if the predecessor is also the same value. If it isn’t, you know that you’ve found the starting bound. Otherwise, you’ll continue by recursively calling startIndex.
    if array[middleIndex] == value {
        if array[middleIndex - 1] != value {
            return middleIndex
        } else {
            return startIndex(
                of: value,
                in: array,
                range: range.lowerBound..<middleIndex
            )
        }
    } else if value < array[middleIndex]  {
        return startIndex(
            of: value,
            in: array,
            range: range.lowerBound..<middleIndex
        )
    } else {
        return startIndex(
            of: value,
            in: array,
            range: middleIndex..<range.upperBound
        )
    }
}

// The endIndex method is similar
func endIndex(
    of value: Int,
    in array: [Int],
    range: CountableRange<Int>
) -> Int? {
    let middleIndex = range.lowerBound + (range.upperBound - range.lowerBound) / 2
    
    if middleIndex == 0 || middleIndex == array.count - 1 {
        if array[middleIndex] == value {
            return middleIndex + 1
        } else {
            return nil
        }
    }
    
    if array[middleIndex] == value {
        if array[middleIndex + 1] != value {
            return middleIndex + 1
        } else {
            return endIndex(
                of: value,
                in: array,
                range: middleIndex..<range.upperBound
            )
        }
    } else if value < array[middleIndex]  {
        return endIndex(
            of: value,
            in: array,
            range: range.lowerBound..<middleIndex
        )
    } else {
        return endIndex(
            of: value,
            in: array,
            range: middleIndex..<range.upperBound
        )
    }
}


example(of: "Binary search with strict start and end index given sorted collection") {
    let array = [1, 2, 3, 3, 3, 4, 5, 5]
    let indices = indices(of: 3, in: array)
    print("indices(of:): \(String(describing: indices))")
    
    let binarySearch3 = search(for: 3, in: array, in: indices)
    print("search(for:): \(String(describing: binarySearch3))")
}
// This improves the time complexity from the previous O(n) to O(log n).
