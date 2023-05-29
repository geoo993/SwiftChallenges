import Foundation

// https://www.geeksforgeeks.org/minimax-algorithm-in-game-theory-set-1-introduction/

func example(of description: String, action: () -> Void) {
  print("\n--- Example of:", description, "---")
  action()
}

// Returns the optimal value a maximizer can obtain.
// depth is current depth in game tree.
// nodeIndex is index of current node in scores[].
// isMax is true if current move is
// of maximizer, else false
// scores[] stores leaves of Game tree.
// h is maximum height of Game tree
func minimax(
    _ depth: Int,
    _ nodeIndex: Int,
    _ isMax: Bool,
    _ scores: inout [Int],
    _ h: Int
) -> Int {
    // Terminating condition. i.e leaf node is reached
    if depth == h {
        return scores[nodeIndex]
    }
 
    // use tree
    
    // If current move is maximizer,
    // find the maximum attainable value
    if isMax {
        return max(
            minimax(depth + 1, nodeIndex * 2, false, &scores, h),
            minimax(depth + 1, nodeIndex * 2 + 1, false, &scores, h)
        )
    }
 
    // Else (If current move is Minimizer), find the minimum attainable value
    else {
        return min(
            minimax(depth + 1, nodeIndex * 2, true, &scores, h),
            minimax(depth + 1, nodeIndex * 2 + 1, true, &scores, h)
        )
    }
}

// A utility function to find Log n in base 2
func log2(_ n: Int) -> Int {
    (n==1) ? 0 : 1 + log2(n/2)
}

example(of: "Min max optimal value") {
    var scores = [3, 5, 2, 9, 12, 5, 23, 8, 16, 25, 14, 99]
    //
    // Max                    [25]
    //
    // Min           [5]               [12]                     [25]
    //
    // Max      [5]      [9]      [12]       [23]         [25]        [99]
    //
    // Min    [3] [5]  [2] [9]  [12] [5]   [23] [8]    [16] [25]   [14] [99]
    
    let n = scores.count
    let log2n = log2(n)
    let result = minimax(0, 0, true, &scores, log2n)
    print("n: \(n)\nh: \(log2n)")
    print("The optimal value is: \(result)")
}

// Time complexity : O(b^d) b is the branching factor and d is count of depth or ply of graph or tree.
// Space Complexity : O(bd) where b is branching factor into d is maximum depth of tree similar to DFS.

// In the above example, there are only two choices for a player.
// In general, there can be more choices. In that case, we need to recur for all possible moves and find the maximum/minimum. For example, in Tic-Tac-Toe, the first player can make 9 possible moves.
// In the above example, the scores (leaves of Game Tree) are given to us.
// For a typical game, we need to derive these values


enum MinMaxType {
    case none
    case value(Int)
}

extension MinMaxType: CustomStringConvertible {
    var description: String {
        switch self {
        case let .value(result):
            return "\(result)"
        default: return "none"
        }
    }
}

class TreeNode {
    weak var parent: TreeNode?
    var value: MinMaxType
    var children: [TreeNode] = []
    
    init(_ value: MinMaxType) {
        self.value = value
    }
    
    func add(_ child: TreeNode) {
        children.append(child)
    }
}

extension TreeNode: Comparable {
    static func < (lhs: TreeNode, rhs: TreeNode) -> Bool {
        switch (lhs.value, rhs.value) {
        case let (.value(result1), .value(result2)):
            return result1 < result2
        default: return false
        }
    }
    
    static func == (lhs: TreeNode, rhs: TreeNode) -> Bool {
        switch (lhs.value, rhs.value) {
        case let (.value(result1), .value(result2)):
            return result1 == result2
        default: return false
        }
    }
}

extension TreeNode: CustomStringConvertible {
    var description: String {
        value.description
    }
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

extension PriorityQueue: CustomStringConvertible {
    var description: String {
        diagram(for: self)
    }
    
    private func diagram(for queue: PriorityQueue?) -> String {
        guard let queue = queue else {
            return "nil\n"
        }
        return "\(queue.heap.elements)"
    }
}

/*
func printTreelevel() {
    // 1 - You begin by initializing a Queue data structure
    var queue = QueueArray<TreeNode<T>>()
    var nodesLeftInCurrentLevel = 0
    queue.enqueue(self)
    
    // 2 - Your level-order traversal continues until your queue is empty.
    while !queue.isEmpty {
        // 3 - Inside the first while loop, you begin by setting nodesLeftInCurrentLevel to the current elements in the queue.
        nodesLeftInCurrentLevel = queue.count
        
        // 4 - Using another while loop, you dequeue the first nodesLeftInCurrentLevel number of elements from the queue. Every element you dequeue is printed out without establishing a new line. You also enqueue all the children of the node.
        while nodesLeftInCurrentLevel > 0 {
            guard let node = queue.dequeue() else { break }
            print("\(node.value) ", terminator: "")
            node.children.forEach { queue.enqueue($0) }
            nodesLeftInCurrentLevel -= 1
        }
        
        // 5
        print()
    }
}
 */
func miniMax(tree: TreeNode, isMax: Bool) {
    let childrens = tree.children
    var queue = isMax ? PriorityQueue(sort: >, elements: childrens) : PriorityQueue(sort: <, elements: childrens)
    var nodesLeftInCurrentLevel = 0
    
    if tree.children.isEmpty {
        return
    }
    
    if isMax {
        tree.children.forEach { queue.enqueue($0) }
    } else {
        tree.children.forEach { queue.enqueue($0) }
    }
    print(queue)
}


func makeMinimaxTree() -> TreeNode {
    let tree = TreeNode(MinMaxType.none)
    
    let lastLevel1 = TreeNode(MinMaxType.value(1))
    let lastLevel2 = TreeNode(MinMaxType.value(17))
    let lastLevel3 = TreeNode(MinMaxType.value(20))
    let lastLevel4 = TreeNode(MinMaxType.value(11))
    let lastLevel5 = TreeNode(MinMaxType.value(5))
    let lastLevel6 = TreeNode(MinMaxType.value(0))
    let lastLevel7 = TreeNode(MinMaxType.value(2))
    let lastLevel8 = TreeNode(MinMaxType.value(9))
    let lastLevel9 = TreeNode(MinMaxType.value(8))
    let lastLevel10 = TreeNode(MinMaxType.value(3))
    let lastLevel11 = TreeNode(MinMaxType.value(43))
    
    let level2A = TreeNode(MinMaxType.none)
    level2A.add(lastLevel1)
    level2A.add(lastLevel2)
    let level2B = TreeNode(MinMaxType.none)
    level2B.add(lastLevel3)
    level2B.add(lastLevel4)
    let level2C = TreeNode(MinMaxType.none)
    level2C.add(lastLevel5)
    level2C.add(lastLevel6)
    let level2D = TreeNode(MinMaxType.none)
    level2D.add(lastLevel7)
    level2D.add(lastLevel8)
    let level2E = TreeNode(MinMaxType.none)
    level2E.add(lastLevel9)
    let level2F = TreeNode(MinMaxType.none)
    level2F.add(lastLevel10)
    level2F.add(lastLevel11)
    
    
    let level1A = TreeNode(MinMaxType.none)
    level1A.add(level2A)
    level1A.add(level2B)
    let level1B = TreeNode(MinMaxType.none)
    level1B.add(level2C)
    level1B.add(level2D)
    let level1C = TreeNode(MinMaxType.none)
    level1C.add(level2E)
    level1C.add(level2F)
    
    tree.add(level1A)
    tree.add(level1B)
    tree.add(level1C)
    
    return tree
}

example(of: "Minimax in each level order") {
    let makeTree = makeMinimaxTree()
    miniMax(tree: makeTree, isMax: true)
}
