import Foundation

func example(of description: String, action: () -> Void) {
  print("\n--- Example of:", description, "---")
  action()
}

// O(n²) time complexity is not great performance, but the sorting algorithms in this category are easy to understand and useful in some scenarios.
// These algorithms are space efficient; they only require constant O(1) additional memory space.
// For small data sets, these sorts compare very favorably against more complex sorts.

// you’ll now be looking at the following sorting algorithms:
// 1- Bubble sort
// 2- Selection sort
// 3- Insertion sort

// All of these are comparison-based sorting methods. They rely on a comparison method, such as the less-than operator, to order the elements.
// The number of times this comparison gets called is how you can measure a sorting technique’s general performance.


// - Bubble sort
// One of the simplest sorts is the bubble sort, which repeatedly compares adjacent values and swaps them, if needed, to perform the sort.
// The larger values in the set will therefore “bubble up” to the end of the collection.

// Consider the following: [9, 4, 10, 3]
// A single pass of the bubble-sort algorithm would consist of the following steps:
// - Start at the beginning of the collection. Compare 9 and 4. These values need to be swapped. The collection then becomes [4, 9, 10, 3].
// - Move to the next index in the collection. Compare 9 and 10. These are in order.
// - Move to the next index in the collection. Compare 10 and 3. These values need to be swapped. The collection then becomes [4, 9, 3, 10].
// A single pass of the algorithm will seldom result in a complete ordering, which is true for this collection. It will, however, cause the largest value — 10 — to bubble up to the end of the collection.

// The sort is only complete when you can perform a full pass over the collection without having to swap any values. At worst, this will require n-1 passes, where n is the count of members in the collection.

var swapCount = 0
func bubbleSort<Element>(_ array: inout [Element]) where Element: Comparable {
    swapCount = 0
    // 1 - There is no need to sort the collection if it has less than two elements.
    guard array.count >= 2 else {
        return
    }
    
    // 2 - A single-pass bubbles the largest value to the end of the collection.
    // Every pass needs to compare one less value than in the previous pass, so you essentially shorten the array by one with each pass.
    for end in (1..<array.count).reversed() {
        var swapped = false
        // 3 - This loop performs a single pass; it compares adjacent values and swaps them if needed.
        for current in 0..<end {
            if array[current] > array[current + 1] {
                array.swapAt(current, current + 1)
                swapped = true
                swapCount += 1
            }
        }
        // 4 - If no values were swapped this pass, the collection must be sorted, and you can exit early.
        if !swapped {
            return
        }
    }
}
// Bubble sort has a best time complexity of O(n) if it’s already sorted, and a worst and average time complexity of O(n²), making it one of the least appealing sorts in the known universe.

example(of: "bubble sort") {
    var array = [9, 4, 10, 3, 5]
    print("Original: \(array)")
    bubbleSort(&array)
    print("Bubble sorted: \(array), with \(swapCount) swaps")
}

// - Selection sort
// Selection sort follows the basic idea of bubble sort, but improves upon this algorithm by reducing the number of swapAt operations.
// Selection sort will only swap at the end of each pass. You’ll see how that works in the following example and implementation.

// Assume you have the following: [9, 4, 10, 3]

// During each pass, selection sort will find the lowest unsorted value and swap it into place:
// 1- First, 3 is found as the lowest value. It is swapped with 9.
// 2- The next lowest value is 4. It’s already in the right place.
// 3- Finally, 9 is swapped with 10.

func selectionSort<Element>(_ array: inout [Element]) where Element: Comparable {
    guard array.count >= 2 else {
        return
    }
    // 1- you perform a pass for every element in the collection, except for the last one. There is no need to include the last element, since if all other elements are in their correct order, the last one will be as well.
    for current in 0..<(array.count - 1) {
        var lowest = current
        // 2 - In every pass, you go through the remainder of the collection to find the element with the lowest value.
        for other in (current + 1)..<array.count {
            if array[lowest] > array[other] {
                lowest = other
            }
        }
        // 3 - If that element is not the current element, swap them.
        if lowest != current {
            array.swapAt(lowest, current)
        }
    }
    
}
// Just like bubble sort, selection sort has a best, worst and average time complexity of O(n²), which is fairly dismal. It’s a simple one to understand, though, and it does perform better than bubble sort!

example(of: "selection sort") {
    var array = [9, 4, 10, 3, 5]
    print("Original: \(array)")
    selectionSort(&array)
    print("Selection sorted: \(array)")
}

// Insertion sort
// Insertion sort is a more useful algorithm. Like bubble sort and selection sort, insertion sort has an average time complexity of O(n²), but the performance of insertion sort can vary.
// The more the data is already sorted, the less work it needs to do. Insertion sort has a best time complexity of O(n) if the data is already sorted.
// The Swift standard library sort algorithm uses a hybrid of sorting approaches with insertion sort being used for small (<20 element) unsorted partitions.

// Give the following: [9, 4, 10, 3]

// Insertion sort will iterate once through the array, from left to right. Each item is shifted to the left until it reaches its correct position.
// 1) You can ignore the first card, as there are no previous cards to compare it with.
// 2) Next, you compare 4 with 9 and shift 4 to the left by swapping positions with 9.
// 3) 10 doesn’t need to shift, as it’s in the correct position compared to the previous card.
// 4) Finally, 3 is shifted all the way to the front by comparing and swapping it with 10, 9 and 4, respectively.

// It’s worth pointing out that the best case scenario for insertion sort occurs when the sequence of values are already in sorted order, and no left shifting is necessary.

func insertionSort<Element>(_ array: inout [Element]) where Element: Comparable {
    guard array.count >= 2 else {
        return
    }
    // 1 - Insertion sort requires you to iterate from left to right, once. This loop does that
    for current in 1..<array.count {
        // 2 - Here, you run backwards from the current index so you can shift left as needed.
        for shifting in (1...current).reversed() {
            // 3 - Keep shifting the element left as long as necessary. As soon as the element is in position, break the inner loop and start with the next element.
            if array[shifting] < array[shifting - 1] {
                array.swapAt(shifting, shifting - 1)
            } else {
                break
            }
        }
    }
}
// Insertion sort is one of the fastest sorting algorithm, if the data is already sorted. That sounds obvious, but it isn’t true for all sorting algorithms. In practice, a lot of data collections will already be largely — if not entirely — sorted, and insertion sort will perform quite well in those scenarios.

example(of: "insertion sort") {
    var array = [9, 4, 10, 3, 5]
    print("Original: \(array)")
    insertionSort(&array)
    print("Selection sorted: \(array)")
}

// Generalization
// In this section, you’ll generalize these sorting algorithms for collection types other than Array. Exactly which collection types, though, depends on the algorithm:
// - Insertion sort traverses the collection backwards when shifting elements. As such, the collection must be of type BidirectionalCollection.
// - Bubble sort and selection sort really only traverse the collection front to back, so they can handle any Collection.
// - In any case, the collection must be a MutableCollection as you need to be able to swap elements.

extension MutableCollection where Element: Comparable {
    // For bubble sort - The algorithm stays the same; you simply update the loop to use the collection’s indices.
    func bubbleSort() -> Self {
        var collection = self
        guard collection.count >= 2 else {
            return collection
        }
        for end in collection.indices.reversed() {
            var swapped = false
            var current = collection.startIndex
            while current < end {
                let next = collection.index(after: current)
                if collection[current] > collection[next] {
                    collection.swapAt(current, next)
                    swapped = true
                }
                current = next
            }
            if !swapped {
                return collection
            }
        }
        return collection
    }
    
    func selectionSort() -> Self {
        var collection = self
        guard collection.count >= 2 else {
            return collection
        }
        for current in collection.indices {
            var lowest = current
            var other = collection.index(after: current)
            while other < collection.endIndex {
                if collection[lowest] > collection[other] {
                    lowest = other
                }
                other = collection.index(after: other)
            }
            if lowest != current {
                collection.swapAt(lowest, current)
            }
        }
        return collection
    }
}


example(of: "bubble sort MutableCollection") {
    var array = [9, 4, 10, 3, 5]
    print("Original: \(array)")
    let result = array.bubbleSort()
    print("Bubble sorted: \(result)")
}

example(of: "selection sort MutableCollection") {
    var array = [9, 4, 10, 3, 5]
    print("Original: \(array)")
    let result = array.selectionSort()
    print("Selection sorted: \(result)")
}

extension MutableCollection where Self: BidirectionalCollection, Element: Comparable {
    func insertionSort() -> Self {
        var collection = self
        guard collection.count >= 2 else {
            return collection
        }
        for current in collection.indices {
            var shifting = current
            while shifting > collection.startIndex {
                let previous = collection.index(before: shifting)
                if collection[shifting] < collection[previous] {
                    collection.swapAt(shifting, previous)
                } else {
                    break
                }
                shifting = previous
            }
        }
        return collection
    }
}


example(of: "insertion sort BidirectionalCollection and MutableCollection") {
    var array = [9, 4, 10, 3, 5]
    print("Original: \(array)")
    let result = array.insertionSort()
    print("Insertion sorted: \(result)")
}

// Key points
// - 0n² algorithms often have a bad reputation, but some of these algorithms usually have some redeeming points. insertionSort can sort in O(n) time if the collection is already in sorted order and gradually scales down to O(n²).
// - insertionSort is one of the best sorts in situations wherein you know, ahead of time, that your data is mostly in a sorted order.

// Challenge 1: Group elements
// Given a collection of Equatable elements, bring all instances of a given value in the array to the right side of the array.
// The trick to this problem is to control two references to manage swapping operations. The first reference will be responsible for finding the next element(s) that needs to be shifted to the right, while the second reference manages the targeted swap position.
extension MutableCollection where Self: BidirectionalCollection, Element: Equatable {
    // The tricky part here is to understand what sort of capabilities you need. Since you need to make changes to the underlying storage, this function is only available to MutableCollection types.
    // To complete this algorithm efficiently, you need backwards index traversal, which is why you also constrain against the BidirectionalCollection protocol.
    // Finally, you also need the elements to be Equatable to target the appropriate values.
    // The time complexity of this solution is O(n).
    mutating func rightAlign(value: Element) {
        var left = startIndex
        var right = index(before: endIndex)
        
        while left < right {
            while self[right] == value {
                formIndex(before: &right)
            }
            while self[left] != value {
                formIndex(after: &left)
            }
            
            guard left < right else {
                return
            }
            swapAt(left, right)
        }
    }
}

// Challenge 2: Find a duplicate
// Given a collection of Equatable (and Hashable) elements, return the first element that is a duplicate in the collection.

extension Sequence where Element: Hashable {
    // Finding the first duplicated element is quite straightforward.
    // You use a Set to keep track of the elements you’ve encountered so far.
    // The constraints for this solution is on Sequence, since it relies on iterating the elements. Each element must also be Hashable, so that you can store it in a set.
    // The time complexity of this solution is O(n).
    var firstDuplicate: Element? {
        var found: Set<Element> = []
        for value in self {
            if found.contains(value) {
                return value
            } else {
                found.insert(value)
            }
        }
        return nil
    }
}

// Challenge 3: Reverse a collection
// Reverse a collection of elements by hand. Do not rely on the reverse or reversed methods.

// Reversing a collection is also quite straightforward.
// Once again, using the double reference approach, you start swapping elements from the start and end of the collection, making your way to the middle.
// Once you’ve hit the middle, you’re done swapping, and the collection is reversed.
extension MutableCollection where Self: BidirectionalCollection {
    // For this solution, you constrain against MutableCollection since you need to mutate the collection to reverse.
    // You also constrain against BidirectionalCollection to utilize backwards index traversal.
    // The time complexity of this solution is O(n).
    mutating func reverse() {
        var left = startIndex
        var right = index(before: endIndex)
        
        while left < right {
            swapAt(left, right)
            formIndex(after: &left)
            formIndex(before: &right)
        }
    }
}
