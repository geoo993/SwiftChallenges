import Foundation

func example(of description: String, action: () -> Void) {
  print("\n--- Example of:", description, "---")
  action()
}

// A heap is a complete binary tree, also known as a binary heap, that can be constructed using an array.

// Note: Don’t confuse these heaps with memory heaps. The term heap is sometimes confusingly used in computer science to refer to a pool of memory. Memory heaps are a different concept.

// Heaps come in two flavors:
// 1) Max heap, in which elements with a higher value have a higher priority.
// 2) Min heap, in which elements with a lower value have a higher priority.

// The heap property
// A heap has important characteristic that must always be satisfied. This is known as the heap invariant or heap property.

// - In a MAX heap, parent nodes must always contain a value that is greater than or equal to the value in its children. The root node will always contain the HIGHEST value.

// - In a MIN heap, parent nodes must always contain a value that is less than or equal to the value in its children. The root node will always contain the LOWEST value.

// Another important property of a heap is that it is a complete binary tree.
// This means that every level must be filled, except for the last level.
// It’s like a video game wherein you can’t go to the next level until you have completed the current one.

// Some useful applications of a heap include:
// - Calculating the minimum or maximum element of a collection.
// - Heap sort.
// - Constructing a priority queue.
// - Constructing graph algorithms, like Prim’s or Dijkstra’s, with a priority queue.

struct Heap<Element: Comparable> {
    // This type contains an array to hold the elements in the heap and a sort function that defines how the heap should be ordered.
    var elements: [Element]
    let sort: (Element, Element) -> Bool
    
    // By passing an appropriate function in the initializer, this type can be used to create both min and max heaps.
    
    // Building a heap
    // You now have all the necessary tools to represent a heap.
    // You can build a heap from an existing array of elements and test it out.
    init(
        sort: @escaping (Element, Element) -> Bool,
        elements: [Element] = []
    ) {
        self.sort = sort
        self.elements = elements
        
        if !elements.isEmpty {
            for i in stride(from: elements.count / 2 - 1, through: 0, by: -1) {
                siftDown(from: i)
            }
        }
    }
}

// Trees hold nodes that store references to their children. In the case of a binary tree, these are references to a left and right child. Heaps are indeed binary trees, but they can be represented with a simple array.
// This seems like an unusual way to build a tree.
// But one of the benefits of this heap implementation is efficient time and space complexity, as the elements in the heap are all stored together in memory.
// You will see later on that swapping elements will play a big part in heap operations. This is also easier to do with an array than with a binary tree data structure.

// To represent the heap above as an array, you would simply iterate through each element level-by-level from left to right.

// As you go up a level, you’ll have twice as many nodes than in the level before.
// It’s now easy to access any node in the heap. You can compare this to how you’d access elements in an array:
// Instead of traversing down the left or right branch, you can simply access the node in your array using simple formulas.
// Given a node at a zero-based index i:
// - The left child of this node can be found at index 2i + 1.
// - The right child of this node can be found at index 2i + 2.

// Note: Traversing down an actual binary tree to get the left and right child of a node is a O(log n) operation.
// In a random-access data structure, such as an array, that same operation is just O(1).

extension Heap {
    var isEmpty: Bool {
        elements.isEmpty
    }
    
    var count: Int {
        elements.count
    }
    
    func peek() -> Element? {
        elements.first
    }
    
    func leftChildIndex(ofParentAt index: Int) -> Int {
        (2 * index) + 1
    }
    
    func rightChildIndex(ofParentAt index: Int) -> Int {
        (2 * index) + 2
    }
    
    func parentIndex(ofChildAt index: Int) -> Int {
        (index - 1) / 2
    }
}

extension Heap: CustomStringConvertible {
    var description: String {
        diagram(for: self)
    }
    
    // diagram will recursively create a string representing the binary tree.
    private func diagram(for node: Heap?) -> String {
        guard let node = node else {
            return "\(peek())nil\n"
        }
        return "\(node.elements)"
    }
}

// Removing from a heap
// A basic remove operation simply removes the root node from the heap.

// A remove operation will remove the maximum value at the root node. To do so, you must first swap the root node with the last element in the heap.

// Once you’ve swapped the two elements, you can remove the last element and store its value so you can later return it.
// Now, you must check the max heap’s integrity. But first, ask yourself, “Is it still a max heap?”
// Remember: The rule for a max heap is that the value of every parent node must be larger than, or equal to, the values of its children. Since the heap no longer follows this rule, you must perform a sift down.

extension Heap {
    mutating func remove() -> Element? {
        guard !isEmpty else { // 1 Check to see if the heap is empty. If it is, return nil.
            return nil
        }
        elements.swapAt(0, count - 1) // 2 - Swap the root with the last element in the heap.
        defer {
            siftDown(from: 0) // 4 - Remove the last element (the maximum or minimum value) and return it.
        }
        return elements.removeLast() // 3 - The heap may not be a max or min heap anymore, so you must perform a sift down to make sure it conforms to the rules.
    }
    
    // siftDown(from:) accepts an arbitrary index. This will always be treated as the parent node.
    // Complexity: The overall complexity of remove() is O(log n). Swapping elements in an array takes only O(1), while sifting down elements in a heap takes O(log n) time.
    mutating func siftDown(from index: Int) {
        var parent = index // 1 - Store the parent index.
        while true { // 2 - Continue sifting until you return.
            let left = leftChildIndex(ofParentAt: parent) // 3 - Get the parent’s left and right child index.
            let right = rightChildIndex(ofParentAt: parent)
            var candidate = parent // 4 - The candidate variable is used to keep track of which index to swap with the parent.
            if left < count && sort(elements[left], elements[candidate]) {
                candidate = left // 5 - If there is a left child, and it has a higher priority than its parent, make it the candidate.
            }
            if right < count && sort(elements[right], elements[candidate]) {
                candidate = right // 6 - If there is a right child, and it has an even greater priority, it will become the candidate instead.
            }
            if candidate == parent {
                return // 7 - If candidate is still parent, you have reached the end, and no more sifting is required.
            }
            elements.swapAt(parent, candidate) // 8 - Swap candidate with parent and set it as the new parent to continue sifting.
            parent = candidate
        }
    }
}

example(of: "Heap - remove") {
    var heap = Heap(sort: >, elements: [3, 4, 6, 8, 7, 2, 5])
    heap.remove()
    print(heap)
}

// Inserting into a heap
// Let’s say you insert a value of 7 to the above heap
//
// First, you add the value to the end of the heap
// Now, you must check the max heap’s property. Instead of sifting down, you must now sift up since the node that you just inserted might have a higher priority than its parents.
// This sifting up works much like sifting down, by comparing the current node with its parent and swapping them if needed.

// Your heap has now satisfied the max heap property!

extension Heap {
    // Implementation of insert
    // As you can see, the implementation is pretty straightforward:
    // - insert appends the element to the array and then performs a sift up.
    // - siftUp swaps the current node with its parent, as long as that node has a higher priority than its parent.
    
    mutating func insert(_ element: Element) {
        elements.append(element)
        siftUp(from: elements.count - 1)
    }
    
    mutating func siftUp(from index: Int) {
        var child = index
        var parent = parentIndex(ofChildAt: child)
        while child > 0 && sort(elements[child], elements[parent]) {
            elements.swapAt(child, parent)
            child = parent
            parent = parentIndex(ofChildAt: child)
        }
    }
    // Complexity: The overall complexity of insert(_:) is O(log n).
    // Appending an element in an array takes only O(1), while sifting up elements in a heap takes O(log n).
}

extension Heap {
    // Removing from an arbitrary index
    mutating func remove(at index: Int) -> Element? {
        guard index < elements.count else {
            return nil // 1 - Check to see if the index is within the bounds of the array. If not, return nil.
        }
        if index == elements.count - 1 {
            return elements.removeLast() // 2 - If you’re removing the last element in the heap, you don’t need to do anything special. Simply remove and return the element.
        } else {
            elements.swapAt(index, elements.count - 1) // 3 - If you’re not removing the last element, first swap the element with the last element.
            defer {
                siftDown(from: index) // 5 - Finally, perform a sift down and a sift up to adjust the heap.
                siftUp(from: index)
            }
            return elements.removeLast() // 4 - Then, return and remove the last element.
        }
    }
}

// Removing an arbitrary element from a heap is an O(log n) operation.
// But how do you actually find the index of the element you wish to delete?

// Searching for an element in a heap
// To find the index of the element that you wish to delete, you must perform a search on the heap.
// Unfortunately, heaps are not designed for fast searches.
// With a binary search tree, you can perform a search in O(log n) time, but since heaps are built using an array, and the node ordering in an array is different, you can’t even perform a binary search.

extension Heap {
    // Complexity: To search for an element in a heap is, in the worst-case, an O(n) operation, since you may have to check every element in the array:
    func index(of element: Element, startingAt i: Int) -> Int? {
        if i >= count {
            return nil // 1 - If the index is greater than or equal to the number of elements in the array, the search failed. Return nil.
        }
        if sort(element, elements[i]) {
            return nil // 2 - Check to see if the element that you are looking for has higher priority than the current element at index i. If it does, the element you are looking for cannot possibly be lower in the heap.
        }
        if element == elements[i] {
            return i // 3 - If the element is equal to the element at index i, return i.
        }
        if let j = index(of: element, startingAt: leftChildIndex(ofParentAt: i)) {
            return j // 4 - Recursively search for the element starting from the left child of i.
        }
        if let j = index(of: element, startingAt: rightChildIndex(ofParentAt: i)) {
            return j // 5 - Recursively search for the element starting from the right child of i.
        }
        return nil // 6 - If both searches failed, the search failed. Return nil.
    }
    
    // Note: Although searching takes O(n) time, you have made an effort to optimize searching by taking advantage of the heap’s property and checking the priority of the element when searching.
}

example(of: "Heap - remove again") {
    var heap = Heap(sort: >, elements: [1,12,3,4,1,6,8,7])

    while !heap.isEmpty {
      print(heap.remove()!)
    }
    //This creates a max heap (because > is used as the sorting function) and removes elements one-by-one until it is empty. Notice that the elements are removed largest to smallest and the following numbers are printed to the console.
}

// Key points
// - Here is a summary of the algorithmic complexity of the heap operations that you implemented in this chapter:
//
// |     Operations    |       Time Complexity     |
// |___________________|___________________________|
// |     remove        |          0(log n)         |
// |___________________|___________________________|
// |     insert        |          0(log n)         |
// |___________________|___________________________|
// |     search        |            0(n)           |
// |___________________|___________________________|
// |     peek          |            0(1)           |
// |___________________|___________________________|
//
// The heap data structure is good for maintaining the highest- or lowest-priority element.
// Every time you insert or remove items from the heap, you must check to see if it satisfies the rules of the priority.

// Find the nth smallest integer
// Write a function to find the nth smallest integer in an unsorted array.


// There are many ways to solve for the nth smallest integer in an unsorted array.
// For example, you could choose a sorting algorithm you learned about in this chapter, sort the array, and just grab the element at the nth index.
func findNthSmallestValue(n: Int, elements: [Int]) -> Int? {
    var heap = Heap(sort: <, elements: elements) // 1 - Initialize a min-heap with the unsorted array.
    var current = 1 // 2 - current tracks the nth smallest element.
    while !heap.isEmpty { // 3 - As long as the heap is not empty, continue to remove elements.
        let element = heap.remove() // 4 - Remove the root element from the heap.
        if current == n { // 5 - Check to see if you reached the nth smallest element. if so, return the element.
            return element
        }
        current += 1 // 6 - If not, increment current.
    }
    return nil // 7 - Return nil if the heap is empty.
    // Building a heap takes O(n). Every element removal from the heap takes O(log n). Keep in mind that you are also doing this n times. The overall time complexity is O(n log n).
}

example(of: "Heap - nth smallest integer") {
    let array = [3, 10, 18, 5, 21, 100]
    let result = findNthSmallestValue(n: 3, elements: array)
    print(result)
}

// Challenge 2: Combining two heaps
// Write a method that combines two heaps.

extension Heap {
    // Merging two heaps is very straightforward.
    // You first combine both arrays which takes O(m), where m is the length of the heap you are merging.
    // Building the heap takes O(n). Overall the algorithm runs in O(n).
    mutating func merge(_ heap: Heap) {
        elements = elements + heap.elements
    }
}

// Challenge 3: A Min Heap?
// Write a function to check if a given array is a min heap.

// To check if the given array is a min heap, you only need to go through all the parent nodes of the binary heap.
// To satisfy the min heap, every parent node must be less than or equal to its left and right child node.

extension Heap {
    // The following are helper methods to grab the left and right child index for a given parent index.
    func isMinHeap() -> Bool {
        guard !elements.isEmpty else { // 1 - If the array is empty it is a min-heap!
            return true
        }
        // 2 - Go through all parent nodes in the array in reverse order.
        for i in stride(from: elements.count / 2 - 1, through: 0, by: -1) {
            let left = leftChildIndex(ofParentAt: i) // 3 - Get the left and right child index.
            let right = rightChildIndex(ofParentAt: i)
            if elements[left] < elements[i] { // 4 - Check to see if the left element is less than the parent.
                return false
            }
            if right < elements.count && elements[right] < elements[i]  { // 5 - Check to see if right index is within the bounds of the array, and check if the right element is less than the parent.
                return false
            }
        }
        return true // 6 - If every parent-child relationship satisfies the min-heap property, return true!
    }
}

example(of: "Min heap") {
    var array = [21, 10, 18, 5, 3, 100, 1]
    var heap = Heap(sort: >, elements: array)
    print("is Min Heap", heap.isMinHeap())
    
    var array2 = [1, 3, 44, 6, 7, 104, 101]
    var heap2: Heap<Int> = Heap(sort: <)
    heap2.insert(3)
    heap2.insert(9)
    heap2.insert(5)
    heap2.insert(6)
    heap2.insert(7)
    heap2.insert(104)
    heap2.insert(1)
    print("Heap", heap2)
    print("is Min Heap", heap2.isMinHeap())
}
