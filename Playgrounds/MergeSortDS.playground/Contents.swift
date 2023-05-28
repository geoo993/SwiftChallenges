import Foundation

func example(of description: String, action: () -> Void) {
  print("\n--- Example of:", description, "---")
  action()
}

// Merge Sort

// Merge sort is one of the most efficient sorting algorithms. With a time complexity of O(n log n), it’s one of the fastest of all general-purpose sorting algorithms. The idea behind merge sort is divide and conquer — to break up a big problem into several smaller, easier-to-solve problems and then combine those solutions into a final result. The merge sort mantra is to split first and merge after

// Assume that you’re given a pile of unsorted array: [7,2,6,3,9]

// The merge sort algorithm works as follows:
// 1) First, split the pile in half. You now have two unsorted piles:
// [7,2] [6,3,9]

// 2) Now, keep splitting the resulting piles until you can’t split anymore.
// In the end, you will have one (sorted!) value in each pile:

// 3) Finally, merge the piles together in the reverse order in which you split them.
// During each merge, you put the contents in sorted order.
// This is easy because each individual pile has already been sorted

// Implementation


func mergeSort<Element>(_ array: [Element]) -> [Element] where Element: Comparable {
    // Here, you split the array into halves. Splitting once isn’t enough, however; you have to keep splitting recursively until you can’t split any more, which is when each subdivision contains just one element.
    
    // 1 - Recursion needs a base case, which you can also think of as an “exit condition.” In this case, the base case is when the array only has one element.
    guard array.count > 1 else {
        return array
    }
    
    let middle = array.count / 2
    // 2 - You’re now calling mergeSort on the left and right halves of the original array. As soon as you’ve split the array in half, you’ll try to split again.
    let left = mergeSort(Array(array[..<middle]))
    let right = mergeSort(Array(array[middle...]))
    
    // Finishing up
    // Complete the mergeSort function by calling merge.
    // Because you call mergeSort recursively, the algorithm will split and sort both halves before merging them together.
    return merge(left, right)
}

// Merge
// Your final step is to merge the left and right arrays together.
// To keep things clean, you will create a separate merge function for this.
private func merge<Element>(_ left: [Element], _ right: [Element]) -> [Element] where Element: Comparable {
    // 1 - The leftIndex and rightIndex variables track your progress as you parse through the two arrays.
    var leftIndex = 0
    var rightIndex = 0
    
    // 2 - The result array will house the combined array.
    var result: [Element] = []
    
    // 3 - Starting from the beginning, you compare the elements in the left and right arrays sequentially. If you’ve reached the end of either array, there’s nothing else to compare.
    while leftIndex < left.count && rightIndex < right.count {
        let leftElement = left[leftIndex]
        let rightElement = right[rightIndex]
        
        // 4 - The smaller of the two elements goes into the result array. If the elements were equal, they can both be added.
        if leftElement < rightElement {
            result.append(leftElement)
            leftIndex += 1
        } else if leftElement > rightElement {
            result.append(rightElement)
            rightIndex += 1
        } else {
            result.append(leftElement)
            leftIndex += 1
            result.append(rightElement)
            rightIndex += 1
        }
    }
    
    // 5 - The first loop guarantees that either left or right is empty. Since both arrays are sorted, this ensures that the leftover elements are greater than or equal to the ones currently in result. In this scenario, you can append the rest of the elements without comparison.
    if leftIndex < left.count {
        result.append(contentsOf: left[leftIndex...])
    }
    if rightIndex < right.count {
        result.append(contentsOf: right[rightIndex...])
    }
    return result
}


// Here’s a summary of the key procedures of merge sort:
// - The strategy of merge sort is to divide and conquer, so that you solve many small problems instead of one big problem.
// - It has two core responsibilities: a method to divide the initial array recursively, as well as a method to merge two arrays.
// - The merging function should take two sorted arrays and produce a single sorted array.

example(of: "merge sort") {
    let array = [7, 2, 6, 3, 9, 11, 5]
    print("Original: \(array)")
    print("Merge sorted: \(mergeSort(array))")
}

// Performance
// The best, worst and average time complexity of merge sort is O(n log n), which isn’t too bad. If you’re struggling to understand where n log n comes from, think about how the recursion works:
// - As you recurse, you split a single array into two smaller arrays. This means an array of size 2 will need one level of recursion, an array of size 4 will need two levels, an array of size 8 will need three levels, and so on. If you had an array of 1,024 elements, it would take 10 levels of recursively splitting in two to get down to 1024 single element arrays. In general, if you have an array of size n, the number of levels is log2(n).
// - A single recursion level will merge n elements. It doesn’t matter if there are many small merges or one large one; the number of elements merged will still be n at each level. This means the cost of a single recursion is O(n).
// This brings the total cost to O(log n) × O(n) = O(n log n).

// There are log2(n) levels of recursion and at each level n elements are used. That makes the total O(n log n) in space complexity. Merge sort is one of the hallmark sorting algorithms. It’s relatively simple to understand, and serves as a great introduction to how divide-and-conquer algorithms work. Merge sort is O(n log n) and this implementation requires O(n log n) of space. If you are really clever with your bookkeeping, you can reduce the memory required to O(n) by discarding the memory that is not actively being used.

// Key points
// - Merge sort is in the category of the divide-and-conquer algorithms.
// - There are many implementations of merge sort, and you can have different performance characteristics depending on the implementation.


// Challenge 1: Speeding up appends
// Consider the following code:

example(of: "Speeding up seconds") {
    let size = 1024
    var values: [Int] = []
    values.reserveCapacity(size) // 1 - Using reserveCapacity is a great way to speed up your appends.
    for i in 0 ..< size {
        values.append(i)
    }
}

// Challenge 2: Merge two sequences
// Write a function that takes two sorted sequences and merges them into a single sequence. Here’s the function signature to start off:

func mergeSequence<T: Sequence>(first: T, second: T) -> AnySequence<T.Element> where T.Element: Comparable {
    // 1 - Create a new container to store the merged sequences.
    var result: [T.Element] = []
    
    // 2 - Grab the iterators of the first and second sequence. Iterators sequentially dispense values of the sequence via the next method.
    var firstIterator = first.makeIterator()
    var secondIterator = second.makeIterator()
    
    // 3 - Create two variables that are initialized as the first and second iterator’s first value. next returns an optional element of the sequence, and a nil return value suggests the iterator has dispensed all elements in the sequence.
    var firstNextValue = firstIterator.next()
    var secondNextValue = secondIterator.next()
    
    while let first = firstNextValue, let second = secondNextValue {
        
        if first < second { // 1 - If the first value is less than the second one, you’ll append the first value in result and seed the next value to be compared with by invoking next on the first iterator.
            result.append(first)
            firstNextValue = firstIterator.next()
        } else if second < first { // 2 - If the second value is less than the first, you’ll do the opposite. You seed the next value to be compared by invoking next on the second iterator.
            result.append(second)
            secondNextValue = secondIterator.next()
        } else { // 3 - If they are equal, you append both the first and second values and seed both next values.
            result.append(first)
            result.append(second)
            firstNextValue = firstIterator.next()
            secondNextValue = secondIterator.next()
        }
    }
    
    // This will continue until one of the iterators run out of elements to dispense. In that scenario, it means the iterator with elements left have elements that are equal or greater than the current values in result.
    // Then add the rest of those values
    while let first = firstNextValue {
      result.append(first)
      firstNextValue = firstIterator.next()
    }

    while let second = secondNextValue {
      result.append(second)
      secondNextValue = secondIterator.next()
    }

    return AnySequence<T.Element>(result)
}

example(of: "Merge sequence") {
    var array1 = [1, 2, 23, 4, 5, 16, 7, 8]
    var array2 = [1, 3, 4, 5, 35, 6, 7, 7, 19, 11]

    let result1 = mergeSort(array1)
    let result2 = mergeSort(array2)
    for element in mergeSequence(first: result1, second: result2) {
        print(element)
    }
}
