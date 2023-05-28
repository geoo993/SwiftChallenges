import Foundation

func example(of description: String, action: () -> Void) {
  print("\n--- Example of:", description, "---")
  action()
}

// Quicksort is another comparison-based sorting algorithm.
// Much like merge sort, it uses the same strategy of divide and conquer.
// One important feature of quicksort is choosing a pivot point.
// The pivot divides the array into three partitions:

// [ elements < pivot | pivot | elements > pivot ]

//  A naïve implementation of quicksort will look like this


func quicksortNaive<T: Comparable>(_ a: [T]) -> [T] {
    guard a.count > 1 else { // 1 - There must be more than one element in the array. If not, the array is considered sorted.
        return a
    }
    let pivot = a[a.count / 2] // 2 - Pick the middle element of the array as your pivot.
    
    // 3 - Using the pivot, split the original array into three partitions.
    // Elements less than, equal to or greater than the pivot go into different buckets.
    let less = a.filter { $0 < pivot }
    let equal = a.filter { $0 == pivot }
    let greater = a.filter { $0 > pivot }
    return quicksortNaive(less) + equal + quicksortNaive(greater) // 4 - Recursively sort the partitions and then combine them.
}

// Let’s now visualize the code above with the following:
// [12, 0, 3, 9, 2, 18, 8, 27, 1, 5, 8, -1, 21]

// Your partition strategy in this implementation is to always select the middle element as the pivot.
// In this case, the element is 8. Partitioning the array using this pivot results in the following partitions:
// - less: [0, 3, 2, 1, 5, -1]
// - equal: [8, 8]
// - greater: [12, 9, 18, 27, 21]

// Notice that the three partitions aren’t completely sorted yet. Quicksort will recursively divide these partitions into even smaller ones. The recursion will only halt when all partitions have either zero or one element.

// Each level corresponds with a recursive call to quicksort.
// Once recursion stops, the leafs are combined again, resulting in a fully sorted array:
// [-1, 0, 1, 2, 3, 5, 8, 8, 9, 12, 18, 21, 27]

example(of: "Naive quick sort") {
    let array = [12, 0, 3, 9, 2, 18, 8, 27, 1, 5, 8, -1, 21]
    let result = quicksortNaive(array)
    print(result)
}

// While this naïve implementation is easy to understand, it raises some issues and questions:
// - Calling filter three times on the same array is not efficient.
// - Creating a new array for every partition isn’t space efficient. Could you possibly sort in place?
// - Is picking the middle element the best pivot strategy? What pivot strategy should you adopt?


//=== Partitioning strategies
// The first partitioning algorithm you will look at is Lomuto’s algorithm.

// Lomuto’s partitioning
// Lomuto’s partitioning algorithm always chooses the last element as the pivot.

// This function takes three arguments:
func partitionLomuto<T: Comparable>(
    _ a: inout [T], // - a is the array you are partitioning.
    low: Int, //- low and high set the range within the array you will partition. This range will get smaller and smaller with every recursion.
    high: Int
) -> Int {
    // The function returns the index of the pivot.
    
    let pivot = a[high] // 1 - Set the pivot. Lomuto always chooses the last element as the pivot.
    var i = low // 2 - The variable i indicates how many elements are less than the pivot. Whenever you encounter an element that is less than the pivot, you swap it with the element at index i and increase i.
    for j in low..<high { // 3 - Loop through all the elements from low to high, but not including high since it’s the pivot.
        if a[j] <= pivot { // 4 - Check to see if the current element is less than or equal to the pivot.
            a.swapAt(i, j) // 5 - If it is, swap it with the element at index i and increase i.
            i += 1
        }
    }
    
    a.swapAt(i, high) // 6 - Once done with the loop, swap the element at i with the pivot. The pivot always sits between the less and greater partitions.
    return i // 7 - Return the index of the pivot.
}

// While this algorithm loops through the array, it divides the array into four regions:
// 1- a[low..<i] contains all elements <= pivot.
// 2- a[i...j-1] contains all elements > pivot.
// 3- a[j...high-1] are elements you have not compared yet.
// 4- a[high] is the pivot element.

// [ values <= pivot | values > pivot | not compared yet | pivot ]
//   low        i-1     i        j-1    j         high-1   high

// In the naïve implementation of quicksort, you created three new arrays and filtered the unsorted array three times.
// Lomuto’s algorithm performs the partitioning in place. That’s much more efficient!
// With your partitioning algorithm in place, you can now implement quicksort:

func quicksortLomuto<T: Comparable>(
    _ a: inout [T],
    low: Int,
    high: Int
) {
    // Here, you simply apply Lomuto’s algorithm to partition the array into two regions, then you recursively sort these regions. Recursion ends once a region has less than two elements.
    if low < high {
        let pivot = partitionLomuto(&a, low: low, high: high)
        quicksortLomuto(&a, low: low, high: pivot - 1)
        quicksortLomuto(&a, low: pivot + 1, high: high)
    }
}

example(of: "Lomuto partition quick sort") {
    var list = [12, 0, 3, 9, 2, 21, 18, 27, 1, 5, 8, -1, 8]
    quicksortLomuto(&list, low: 0, high: list.count - 1)
    print(list)
}


// Hoare’s partitioning
// Hoare’s partitioning algorithm always chooses the first element as the pivot.
// Let’s look at how this works in code.

func partitionHoare<T: Comparable>(
    _ a: inout [T],
    low: Int,
    high: Int
) -> Int {
    let pivot = a[low] // 1 - Select the first element as the pivot.
    
    // 2- Indexes i and j define two regions. Every index before i will be less than or equal to the pivot.
    // Every index after j will be greater than or equal to the pivot.
    var i = low - 1
    var j = high + 1
    
    while true {
        repeat { j -= 1 } while a[j] > pivot // 3 - Decrease j until it reaches an element that is not greater than the pivot.
        repeat { i += 1 } while a[i] < pivot // 4 - Increase i until it reaches an element that is not less than the pivot.
        
        if i < j { // 5 - If i and j have not overlapped, swap the elements.
            a.swapAt(i, j)
        } else {
            return j // 6 - Return the index that separates both regions.
        }
        // Note: The index returned from the partition does not necessarily have to be the index of the pivot element.
    }
}

// In the Hoare’s algorithm, there are far fewer swaps here compared to Lomuto’s algorithm. Isn’t that nice?
// You can now implement a quicksortHoare function:
func quicksortHoare<T: Comparable>(
    _ a: inout [T],
    low: Int,
    high: Int
) {
    if low < high {
        let p = partitionHoare(&a, low: low, high: high)
        quicksortHoare(&a, low: low, high: p)
        quicksortHoare(&a, low: p + 1, high: high)
    }
}

example(of: "Hoare partition quick sort") {
    var list = [12, 0, 3, 9, 2, 21, 18, 27, 1, 5, 8, -1, 8]
    quicksortHoare(&list, low: 0, high: list.count - 1)
    print(list)
}

// Effects of a bad pivot choice
// The most important part of implementing quicksort is choosing the right partitioning strategy.
// You have looked at three different partitioning strategies:

// 1) Choosing the middle element as a pivot.
// 2) Lomuto, or choosing the last element as a pivot.
// 3) Hoare, or choosing the first element as a pivot.

// What are the implications of choosing a bad pivot?
// Let’s start with the following unsorted array: [8, 7, 6, 5, 4, 3, 2, 1]

// If you use Lomuto’s algorithm, the pivot will be the last element 1. This results in the following partitions:
// - less: [ ]
// - equal: [1]
// - greater: [8, 7, 6, 5, 4, 3, 2]

// An ideal pivot would split the elements evenly between the less than and greater than partitions.
// Choosing the first or last element of an already sorted array as a pivot makes quicksort perform much like insertion sort, which results in a worst-case performance of O(n²).
// One way to address this problem is by using the median of three pivot selection strategy. Here, you find the median of the first, middle and last element in the array and use that as a pivot.
// This prevents you from picking the highest or lowest element in the array.

func medianOfThree<T: Comparable>(
    _ a: inout [T],
    low: Int,
    high: Int
) -> Int {
    // Here, you find the median of a[low], a[center] and a[high] by sorting them.
    // The median will end up at index center, which is what the function returns.
    let center = (low + high) / 2
    if a[low] > a[center] {
        a.swapAt(low, center)
    }
    if a[low] > a[high] {
        a.swapAt(low, high)
    }
    if a[center] > a[high] {
        a.swapAt(center, high)
    }
    return center
}

// Now implement a variant of Quicksort using this median of three:
public func quickSortMedian<T: Comparable>(
    _ a: inout [T],
    low: Int,
    high: Int
) {
    if low < high {
        let pivotIndex = medianOfThree(&a, low: low, high: high)
        a.swapAt(pivotIndex, high)
        let pivot = partitionLomuto(&a, low: low, high: high)
        quicksortLomuto(&a, low: low, high: pivot - 1)
        quicksortLomuto(&a, low: pivot + 1, high: high)
    }
}

example(of: "Quick sort mediam") {
    var list = [8, 7, 6, 5, 4, 3, 2, 1]
    quickSortMedian(&list, low: 0, high: list.count - 1)
    print(list)
    
    var list2 = [12, 0, 3, 9, 2, 21, 18, 27, 1, 5, 8, -1, 8]
    quickSortMedian(&list2, low: 0, high: list2.count - 1)
    print(list2)
}



// This is definitely an improvement, but can we do better?

//== Dutch national flag partitioning
// A problem with Lomuto’s and Hoare’s algorithms is that they don’t handle duplicates really well.
// - With Lomuto’s algorithm, duplicates end up in the less than partition and aren’t grouped together.
// - With Hoare’s algorithm, the situation is even worse as duplicates can be all over the place.

example(of: "Partition sort with duplicate issues") {
    var list = [8, 7, 6, 2, 7, 2, 6, 8, 9, 9, 6, 5, 4, 3, 2, 1, 4, 7, 2, 7]
    quicksortHoare(&list, low: 0, high: list.count - 1)
    print(list)
    
    var list2 = [8, 7, 6, 2, 7, 2, 6, 8, 9, 9, 6, 5, 4, 3, 2, 1, 4, 7, 2, 7]
    quicksortLomuto(&list2, low: 0, high: list.count - 1)
    print(list2)
}

// A solution to organize duplicate elements is using Dutch national flag partitioning.
// This technique is named after the Dutch flag, which has three bands of colors: red, white and blue.
// This is similar to how you create three partitions.
// Dutch national flag partitioning is a good technique to use if you have a lot of duplicate elements.

func partitionDutchFlag<T: Comparable>(
    _ a: inout [T],
    low: Int, high: Int,
    pivotIndex: Int
) -> (Int, Int) {
    let pivot = a[pivotIndex] // You will adopt the same strategy as Lomuto’s partition by choosing the last element as the pivotIndex
    var smaller = low // 1 - Whenever you encounter an element that is less than the pivot, move it to index smaller. This means that all elements that come before this index are less than the pivot.
    var equal = low // 2 - Index equal points to the next element to compare. Elements that are equal to the pivot are skipped, which means that all elements between smaller and equal are equal to the pivot.
    var larger = high // 3 - Whenever you encounter an element that is greater than the pivot, move it to index larger. This means that all elements that come after this index are greater than the pivot.
    
    // 4 - The main loop compares elements and swaps them if needed. This continues until index equal moves past index larger, meaning all elements have been moved to their correct partition.
    
    while equal <= larger {
        if a[equal] < pivot {
            a.swapAt(smaller, equal)
            smaller += 1
            equal += 1
        } else if a[equal] == pivot {
            equal += 1
        } else {
            a.swapAt(equal, larger)
            larger -= 1
        }
    }
    return (smaller, larger) // 5 - The algorithm returns indices smaller and larger. These point to the first and last elements of the middle partition.
}

// You’re now ready to implement a new version of quicksort using Dutch national flag partitioning:
func quicksortDutchFlag<T: Comparable>(
    _ a: inout [T],
    low: Int,
    high: Int
) {
    // Notice how recursion uses the middleFirst and middleLast indices to determine the partitions that need to be sorted recursively. Because the elements equal to the pivot are grouped together, they can be excluded from the recursion.
    if low < high {
        let (middleFirst, middleLast) = partitionDutchFlag(&a, low: low, high: high, pivotIndex: high)
        quicksortDutchFlag(&a, low: low, high: middleFirst - 1)
        quicksortDutchFlag(&a, low: middleLast + 1, high: high)
    }
}

example(of: "Quick sort with Dutch national flag partitioning") {
    var list = [12, 0, 3, 9, 2, 21, 18, 27, 1, 5, 8, -1, 8]
    quicksortDutchFlag(&list, low: 0, high: list.count - 1)
    print(list)
}

// Key points
// - The naïve partitioning creates a new array on every filter function; this is inefficient. All other strategies sort in place.
// - Lomuto’s partitioning chooses the last element as the pivot.
// - Hoare’s partitioning chooses the first element as its pivot.
// - An ideal pivot would split the elements evenly between partitions.
// - Choosing a bad pivot can cause quicksort to perform in O(n²).
// - Median of three finds the pivot by taking the median of the first, middle and last element.
// - Dutch national flag partitioning strategy helps to organize duplicate elements in a more efficient way.


// Challenge 1: Iterative quicksort
// Your challenge here is to implement quicksort iteratively.
// Choose any partition strategy you learned in this chapter.

// This function takes in an array, and the range between low and high. We are going to leverage the stack to store pairs of start and end values.
struct Stack<Element> {
    private var storage: [Element] = []
    
    init() { }
    
    mutating func push(_ element: Element) {
        storage.append(element)
    }
    
    @discardableResult
    mutating func pop() -> Element? {
        storage.popLast()
    }
    
    func peek() -> Element? {
        storage.last
    }

    var isEmpty: Bool {
        peek() == nil
    }
}

public func quicksortIterativeLomuto<T: Comparable>(
    _ a: inout [T],
    low: Int,
    high: Int
) {
    var stack = Stack<Int>() // 1 - Create a stack that stores indices.
    
    // 2 - Push the starting low and high boundaries on the stack to initiate the algorithm.
    stack.push(low)
    stack.push(high)
    
    // 3 - As long as the stack is not empty, quicksort is not complete.
    while !stack.isEmpty {
        // 4 - Get the pair of start and end indices from the stack.
        guard let end = stack.pop(), let start = stack.pop() else {
            continue
        }
        
        // 5- Perform Lomuto’s partitioning with the current start and end index. Recall that Lomuto picks the last element as the pivot, and splits the partitions into three parts: elements that are less than the pivot, the pivot, and finally elements that are greater than the pivot.
        let p = partitionLomuto(&a, low: start, high: end)
        
        // 6 - Once the partitioning is complete, check and add the lower bound’s start and end indices to later partition the lower half.
        if (p - 1) > start {
            stack.push(start)
            stack.push(p - 1)
        }
        
        // 7 - Similarly check and add the upper bound’s start and end indices to later partition the upper half.
        if (p + 1) < end {
            stack.push(p + 1)
            stack.push(end)
        }
    }
    // You are simply using the stack to store a pair of start and end indices to perform the partitions.
}

example(of: "Lomuto partition quick sort iteratively") {
    var list = [12, 0, 3, 9, 2, 21, 18, 27, 1, 5, 8, -1, 8]
    quicksortIterativeLomuto(&list, low: 0, high: list.count - 1)
    print(list)
}

// Challenge 2: Merge sort or quicksort
// Explain when and why you would use merge sort over quicksort.

// - Merge sort is preferable over quicksort when you need stability. Merge sort is a stable sort and guarantees O(n log n). This is not the case with quicksort, which isn’t stable and can perform as bad as O(n²).
// - Merge sort works better for larger data structures or data structures where elements are scattered throughout memory. Quicksort works best when elements are stored in a contiguous block.


// Challenge 3: Partitioning with Swift standard library
// Implement Quicksort using the partition(by:) function that is part of the Swift Standard Library.

// To perform quicksort on a Collection, the following must hold true:
// 1- The collection must be a MutableCollection. This gives you the ability to change the value of elements in a collection.
// 2- The collection must be a BidirectionalCollection. This gives you the ability to traverse the collection forwards and backwards. Quicksort depends on the first and last index of a collection.
// 3- The elements in the collection must be Comparable.

extension MutableCollection
where Self: BidirectionalCollection, Element: Comparable {
    
    // Here you define a function called quicksort(). This internally calls a quicksortLumuto(_:) that takes in the low and high indexes to start the sorting algorithm.
    mutating func quicksort() {
        quicksortLumuto(low: startIndex, high: index(before: endIndex))
    }
    
    private mutating func quicksortLumuto(low: Index, high: Index) {
        if low <= high { // 1 - Continue to perform quicksort on the collection till the start and end indexes overlap each other.
            let pivotValue = self[high] // 2 - Lumuto’s partition always takes the last element in the collection to perform the partition.
            var p = self.partition { $0 > pivotValue } // 3 - partition the elements in the collection and return the first index p satisfying the condition where, elements are greater than the pivotValue. Elements before index p represents elements that don’t satisfy the predicate, and elements after p represents elements that do satisfy the condition.
            
            if p == endIndex { // 4 - Handle the base case. If p is the last index, move to the index before.
                p = index(before: p)
            }
            // 5 - Perform quicksort on the first partition that is made up of elements not greater than the pivotValue.
            self[..<p].quicksortLumuto(low: low, high: index(before: p))
            // 6 - Perform quicksort on the second partition that is made up of elements greater than the pivotValue.
            self[p...].quicksortLumuto(low: index(after: p), high: high)
        }
    }
}

example(of: "Lomuto Partition quicksort from MutableCollection") {
    var numbers = [12, 0, 3, 9, 2, 21, 18, 27, 1, 5, 8, -1, 8]
    print(numbers)
    numbers.quicksort()
    print(numbers)
}
