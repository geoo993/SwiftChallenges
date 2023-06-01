import Foundation

func example(of description: String, action: () -> Void) {
  print("\n--- Example of:", description, "---")
  action()
}

protocol Queue {
    associatedtype Element
    mutating func enqueue(_ element: Element) -> Bool
    mutating func dequeue() -> Element?
    var isEmpty: Bool { get }
    var peek: Element? { get }
}

struct Heap<Element: Comparable> {
    var elements: [Element] = []
    let sort: (Element, Element) -> Bool
    
    init(sort: @escaping (Element, Element) -> Bool, elements: [Element] = []) {
        self.sort = sort
        self.elements = elements
        
        if !elements.isEmpty {
            for i in stride(from: elements.count / 2 - 1, through: 0, by: -1) {
                siftDown(from: i)
            }
        }
    }
    
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
    
    mutating func remove() -> Element? {
        guard !isEmpty else {
            return nil
        }
        elements.swapAt(0, count - 1)
        defer {
            siftDown(from: 0)
        }
        return elements.removeLast()
    }
    
    mutating func siftDown(from index: Int) {
        var parent = index
        while true {
            let left = leftChildIndex(ofParentAt: parent)
            let right = rightChildIndex(ofParentAt: parent)
            var candidate = parent
            if left < count && sort(elements[left], elements[candidate]) {
                candidate = left
            }
            if right < count && sort(elements[right], elements[candidate]) {
                candidate = right
            }
            if candidate == parent {
                return
            }
            elements.swapAt(parent, candidate)
            parent = candidate
        }
    }
    
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
    
    mutating func remove(at index: Int) -> Element? {
        guard index < elements.count else {
            return nil
        }
        if index == elements.count - 1 {
            return elements.removeLast()
        } else {
            elements.swapAt(index, elements.count - 1)
            defer {
                siftDown(from: index)
                siftUp(from: index)
            }
            return elements.removeLast()
        }
    }
    
    func index(of element: Element, startingAt i: Int) -> Int? {
        if i >= count {
            return nil
        }
        if sort(element, elements[i]) {
            return nil
        }
        if element == elements[i] {
            return i
        }
        if let j = index(of: element, startingAt: leftChildIndex(ofParentAt: i)) {
            return j
        }
        if let j = index(of: element, startingAt: rightChildIndex(ofParentAt: i)) {
            return j
        }
        return nil
    }
}

struct PriorityQueue<Element: Comparable>: Queue {
    private var heap: Heap<Element>
    
    init(
        sort: @escaping (Element, Element) -> Bool,
        elements: [Element] = []
    ) {
        heap = Heap(sort: sort, elements: elements)
    }

    var isEmpty: Bool {
        heap.isEmpty
    }
    
    var peek: Element? {
        heap.peek()
    }
    
    mutating func enqueue(_ element: Element) -> Bool {
        heap.insert(element)
        return true
    }

    mutating func dequeue() -> Element? {
        heap.remove()
    }
}

class TreeNode<T: Comparable> {
    var value: T?
    var children: [TreeNode] = []

    init(_ value: T? = nil) {
        self.value = value
    }
    
    // This method adds a child node to a node.
    func add(_ child: TreeNode) {
        children.append(child)
    }
}

extension TreeNode: Comparable where T: Comparable {
    static func < (lhs: TreeNode<T>, rhs: TreeNode<T>) -> Bool {
        switch (lhs.value, rhs.value) {
        case let (.some(result1), .some(result2)):
            return result1 < result2
        default: return false
        }
    }
}

extension TreeNode: Equatable where T: Equatable {
    static func == (lhs: TreeNode<T>, rhs: TreeNode<T>) -> Bool {
        switch (lhs.value, rhs.value) {
        case let (.some(result1), .some(result2)):
            return result1 == result2 && lhs.children == rhs.children
        default: return false
        }
    }
}

// Minimax algorithm implementation
func minimax(node: TreeNode<Int>, isMaximizing: Bool) -> Int {
    if node.children.isEmpty {
        return node.value ?? 0
    }
    
    if isMaximizing {
        var bestValue = Int.min
        let priorityQueue = PriorityQueue(sort: >, elements: node.children)
        if let value = priorityQueue.peek?.value {
            bestValue = value
        } else {
            for child in node.children {
                let value = minimax(node: child, isMaximizing: false)
                bestValue = max(bestValue, value)
            }
        }
        node.value = bestValue
        return bestValue
    } else {
        var bestValue = Int.max
        let priorityQueue = PriorityQueue(sort: <, elements: node.children)
        if let value = priorityQueue.peek?.value {
            bestValue = value
        } else {
            for child in node.children {
                let value = minimax(node: child, isMaximizing: true)
                bestValue = min(bestValue, value)
            }
        }
        node.value = bestValue
        return bestValue
    }
}

func printAll(from node: TreeNode<Int>) {
    if node.children.isEmpty {
        return
    }
    
    print()
    print(node.children.map{ $0.value })
    node.children.forEach(printAll)
}

example(of: "Mini max") {
    let bottom1 = TreeNode(3)
    let bottom2 = TreeNode(5)
    let bottom3 = TreeNode(2)
    let bottom4 = TreeNode(9)
    let bottom5 = TreeNode(12)
    let bottom6 = TreeNode(5)
    let bottom7 = TreeNode(23)
    let bottom8 = TreeNode(8)
    let bottom9 = TreeNode(16)
    let bottom10 = TreeNode(25)
    let bottom11 = TreeNode(14)
    let bottom12 = TreeNode(99)
    
    // row 3
    let row31: TreeNode<Int>  = TreeNode()
    let row32: TreeNode<Int>  = TreeNode()
    let row33: TreeNode<Int>  = TreeNode()
    let row34: TreeNode<Int>  = TreeNode()
    let row35: TreeNode<Int>  = TreeNode()
    let row36: TreeNode<Int>  = TreeNode()
    row31.add(bottom1)
    row31.add(bottom2)
    row32.add(bottom3)
    row32.add(bottom4)
    row33.add(bottom5)
    row33.add(bottom6)
    row34.add(bottom7)
    row34.add(bottom8)
    row35.add(bottom9)
    row35.add(bottom10)
    row36.add(bottom11)
    row36.add(bottom12)
    
    // row 2
    let row21: TreeNode<Int>  = TreeNode()
    let row22: TreeNode<Int>  = TreeNode()
    let row23: TreeNode<Int>  = TreeNode()
    row21.add(row31)
    row21.add(row32)
    row22.add(row33)
    row22.add(row34)
    row23.add(row35)
    row23.add(row36)
    
    // Create a sample tree
    let rootNode: TreeNode<Int>  = TreeNode()
    rootNode.add(row21)
    rootNode.add(row22)
    rootNode.add(row23)
    
    // Test the minimax algorithm
    let result = minimax(node: rootNode, isMaximizing: true)
    print("Optimal value: \(result)")

    //
    // Max                             [25]
    //
    // Min           [5]               [12]                     [25]
    //
    // Max      [5]      [9]      [12]       [23]         [25]        [99]
    //
    // Min    [3] [5]  [2] [9]  [12] [5]   [23] [8]    [16] [25]   [14] [99]
    printAll(from: rootNode)
}
