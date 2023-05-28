import Foundation

func example(of description: String, action: () -> Void) {
  print("\n--- Example of:", description, "---")
  action()
}

// Heapsort is another comparison-based algorithm that sorts an array in ascending order using a heap.
// It builds “The Heap Data Structure.”

// Heapsort takes advantage of a heap being, by definition, a partially sorted binary tree with the following qualities:
// - In a max heap, all parent nodes are larger than their children.
// - In a min heap, all parent nodes are smaller than their children.

// The diagram below shows a heap with parent node values underlined:
//                     10
//                _____|_____
//                |         |
//                8         4
//             ___|___   ___|___
//            |       |  |      |
//            5       1  2      3
//
//                Max Heap

//                     1
//                _____|_____
//                |         |
//                2         4
//             ___|___   ___|___
//            |       |  |      |
//            5       8  7      9
//
//                Min Heap


// For any given unsorted array, to sort from lowest to highest, heap sort must first convert this array into a max heap: [6, 12, 2, 26, 8, 18, 21, 9, 5]
// This conversion is done by sifting down all the parent nodes so that they end up in the right spot. The resulting max heap is:

//                     26
//                _____|_____
//                |         |
//               12         21
//             ___|___   ___|___
//            |       |  |      |
//            9       8 18      2
//         ___|___
//        |       |
//        6       5
//
// This corresponds with the following array: [26, 12, 21, 9, 8, 18, 2, 6, 5]

// Because the time complexity of a single sift-down operation is O(log n), the total time complexity of building a heap is O(n log n).

// In order to sort this array in ascending order.
// Because the largest element in a max heap is always at the root, you start by swapping the first element at index 0 with the last element at index n - 1.
// As a result of this swap, the last element of the array is in the correct spot, but the heap is now invalidated.
// The next step is, thus, to sift down the new root note 5 until it lands in its correct position.
// As a result of sifting down 5, the second largest element 21 becomes the new root. You can now repeat the previous steps, swapping 21 with the last element 6, shrinking the heap and sifting down 6.

struct Heap<Element: Comparable> {
    var elements: [Element]
    let sort: (Element, Element) -> Bool
    
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
    
    init(
        sort: @escaping (Element, Element) -> Bool,
        elements: [Element] = []
    ) {
        self.sort = sort
        self.elements = elements
        
        if !elements.isEmpty {
            for i in stride(from: elements.count / 2 - 1, through: 0, by: -1) {
                siftDown(from: i, upTo: elements.count)
            }
        }
    }
}

extension Heap: CustomStringConvertible {
    var description: String {
        diagram(for: self)
    }
    
    private func diagram(for node: Heap?) -> String {
        guard let node = node else {
            return "nil\n"
        }
        return "\(node.elements)"
    }
}

extension Heap {
    // In order to support heap sort, you’ve added an additional parameter upTo to the siftDown method.
    // This way, the sift down only uses the unsorted part of the array, which shrinks with every iteration of the loop.
    mutating func siftDown(from index: Int, upTo size: Int) {
        var parent = index
        while true {
            let left = leftChildIndex(ofParentAt: parent)
            let right = rightChildIndex(ofParentAt: parent)
            var candidate = parent
            if left < size && sort(elements[left], elements[candidate]) {
                candidate = left
            }
            if right < size && sort(elements[right], elements[candidate]) {
                candidate = right
            }
            if candidate == parent {
                return
            }
            elements.swapAt(parent, candidate)
            parent = candidate
        }
    }

    func sorted() -> [Element] {
        var heap = Heap(sort: sort, elements: elements) // 1 - You first make a copy of the heap. After heap sort sorts the elements array, it is no longer a valid heap. By working on a copy of the heap, you ensure the heap remains valid.
        for index in heap.elements.indices.reversed() { // 2 - You loop through the array, starting from the last element.
            heap.elements.swapAt(0, index) // 3 - You swap the first element and the last element. This moves the largest unsorted element to its correct spot.
            heap.siftDown(from: 0, upTo: index) // 4 - Because the heap is now invalid, you must sift down the new root node. As a result, the next largest element will become the new root.
        }
        return heap.elements
    }
}

example(of: "Heap sort") {
    let heap = Heap(sort: >, elements: [6, 12, 2, 26, 8, 18, 21, 9, 5])
    print(heap.sorted())
}


// Performance
// Even though you get the benefit of in-memory sorting, the performance of heap sort is O(n log n) for its best, worse and average cases.
// This is because you have to traverse the whole list once and, every time you swap elements, you must perform a sift down, which is an O(log n) operation.

// Heap sort is also not a stable sort because it depends on how the elements are laid out and put into the heap.
// If you were heap sorting a deck of cards by their rank, for example, you might see their suite change order with respect to the original deck.


// Key points
// - Heap sort leverages the max-heap data structure to sort elements in an array.
// - Heap sort sorts its elements by following a simple pattern:
//      1- Swap the first and last element.
//      2- Perform a sift-down from the root to satisfy the requirement of being a heap.
//      3- Decrease the array size by one, since the element at the end will be the largest element.
//      4- Repeat these steps till you reach the start of the array.


// Challenge 1: Add heap sort to Array
// Add a heapSort() method to Array. This method should sort the array in ascending order.


extension Array where Element: Comparable {
    func leftChildIndex(ofParentAt index: Int) -> Int {
        (2 * index) + 1
    }

    func rightChildIndex(ofParentAt index: Int) -> Int {
        (2 * index) + 2
    }

    mutating func siftDown(from index: Int, upTo size: Int) {
        var parent = index
        while true {
            let left = leftChildIndex(ofParentAt: parent)
            let right = rightChildIndex(ofParentAt: parent)
            var candidate = parent
            
            if (left < size) && (self[left] > self[candidate]) {
                candidate = left
            }
            if (right < size) && (self[right] > self[candidate]) {
                candidate = right
            }
            if candidate == parent {
                return
            }
            swapAt(parent, candidate)
            parent = candidate
        }
    }
  
    mutating func heapSort() {
        if !isEmpty {
            for i in stride(from: count / 2 - 1, through: 0, by: -1) {
                siftDown(from: i, upTo: count)
            }
        }
        
        for index in indices.reversed() {
            swapAt(0, index)
            siftDown(from: 0, upTo: index)
        }
  }
}

example(of: "Heap sort array") {
    var array = [6, 12, 2, 26, 8, 18, 21, 9, 5]
    array.heapSort()
    print(array)
}


// Challenge 3: Descending order
// The current implementation of heapsort in Chapter 32 sorts the elements in ascending order. How would you sort in descending order?

example(of: "Heap sorted descending order") {
    let heap = Heap(sort: <, elements: [6, 12, 2, 26, 8, 18, 21, 9, 5])
    print(heap.sorted())
}
