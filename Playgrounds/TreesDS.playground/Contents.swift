import Foundation

func example(of description: String, action: () -> Void) {
  print("\n--- Example of:", description, "---")
  action()
}

/*
The tree is a data structure of profound importance. It is used in numerous facets of software development, such as:
- Representing hierarchical relationships.
- Managing sorted data.
- Facilitating fast lookup operations.
There are many types of trees, and they come in various shapes and sizes.
*/

// Terminology
// There are many terms associated with trees

// 1) Node - Like the linked list, trees are made up of nodes. Each node can carry some data and keeps track of its children.
// 2) Parent and child - Trees are viewed starting from the top and branching towards the bottom, just like a real tree, only upside-down.
//  Every node (except for the topmost one) is connected to exactly one node above it. That node is called a parent node. The nodes directly below and connected to it are called its child nodes. In a tree, every child has exactly one parent. That’s what makes a tree, well, a tree.
// 3) Root - The topmost node in the tree is called the root of the tree. It is the only node that has no parent
// 4) Leaf - A node is a leaf if it has no children


// Each node is responsible for a value and holds references to all its children using an array.
class TreeNode<T> {
    
    weak var parent: TreeNode?
    var value: T
    var children: [TreeNode] = []

    init(_ value: T) {
        self.value = value
    }
    
    // This method adds a child node to a node.
    func add(_ child: TreeNode) {
        children.append(child)
    }
    
}


example(of: "creating a tree") {
    let beverages = TreeNode("Beverages")
    
    let hot = TreeNode("Hot")
    let cold = TreeNode("Cold")
    
    beverages.add(hot)
    beverages.add(cold)
}


// Traversal algorithms
// Iterating through linear collections such as arrays or linked lists is straightforward
// but Iterating through trees is a bit more complicated.

// There are multiple strategies for different trees and different problems.
extension TreeNode {
    // Depth-first traversal
    func forEachDepthFirst(visit: (TreeNode) -> Void) {
        visit(self)
        children.forEach {
            $0.forEachDepthFirst(visit: visit)
        }
    }
}

func makeBeverageTree() -> TreeNode<String> {
    let tree = TreeNode("Beverages")
    
    let hot = TreeNode("hot")
    let cold = TreeNode("cold")
    
    let gingerAle1 = TreeNode("ginger ale")
    let tea = TreeNode("tea")
    let coffee = TreeNode("coffee")
    let chocolate = TreeNode("cocoa")
    
    let blackTea = TreeNode("black")
    let greenTea = TreeNode("green")
    let chaiTea = TreeNode("chai")
    
    let soda = TreeNode("soda")
    let milk = TreeNode("milk")
    
    let gingerAle2 = TreeNode("ginger ale")
    let bitterLemon = TreeNode("bitter lemon")
    
    tree.add(hot)
    tree.add(cold)
    
    hot.add(tea)
    hot.add(coffee)
    hot.add(chocolate)
    hot.add(gingerAle1)
    
    gingerAle1.add(tea)
    
    cold.add(soda)
    cold.add(milk)
    
    tea.add(blackTea)
    tea.add(greenTea)
    tea.add(chaiTea)
    
    soda.add(gingerAle2)
    soda.add(bitterLemon)
    
    return tree
}

example(of: "depth-first traversal") {
    let tree = makeBeverageTree()
    tree.forEachDepthFirst { print($0.value) }
}

protocol Queue {
    associatedtype Element
    mutating func enqueue(_ element: Element)
    mutating func dequeue() -> Element?
    var isEmpty: Bool { get }
    var peek: Element? { get }
}

struct QueueArray<T>: Queue {
    private var array: [T] = []
    init() {}
    
    var isEmpty: Bool { array.isEmpty }

    var peek: T? { array.first }
    
    var count: Int { array.count }

    mutating func enqueue(_ element: T) {
        array.append(element)
    }
    mutating func dequeue() -> T? {
        isEmpty ? nil : array.removeFirst()
    }
}

extension QueueArray: CustomStringConvertible {
    public var description: String {
        String(describing: array)
    }
}

extension TreeNode {
    // forEachLevelOrder visits each of the nodes in level-order
    func forEachLevelOrder(visit: (TreeNode) -> Void) {
        visit(self)
        var queue = QueueArray<TreeNode>()
        children.forEach { queue.enqueue($0) }
        while let node = queue.dequeue() {
            visit(node)
            node.children.forEach { queue.enqueue($0) }
        }
    }
}

example(of: "level-order traversal") {
    let tree = makeBeverageTree()
    tree.forEachLevelOrder { print($0.value) }
}

// We already have a method that iterates through all the nodes, so building a search algorithm shouldn’t take long
extension TreeNode where T: Equatable {
    func search(_ value: T) -> TreeNode? {
        var result: TreeNode?
        forEachLevelOrder { node in
            if node.value == value {
                result = node
            }
        }
        return result
    }
}


example(of: "searching for a node") {
    let tree = makeBeverageTree()
    tree.forEachLevelOrder { print($0.value) }
    print("---")
  
    // Here, you used your level-order traversal algorithm. Since it visits all of the nodes, if there are multiple matches, the last match will win.
    if let searchResult1 = tree.search("ginger ale") {
        print("Found node: \(searchResult1.value) with children:")
        searchResult1.forEachLevelOrder { print($0.value) }
        print("--")
    }
    if let searchResult2 = tree.search("WKD Blue") {
        print(searchResult2.value)
    } else {
        print("Couldn't find WKD Blue")
    }
}

// Key points
// - Trees share some similarities to linked lists, but, whereas linked-list nodes may only link to one successor node, a tree node can link to many child nodes.
// - Every tree node, except for the root node, has exactly one parent node.
// - A root node has no parent nodes.
// - Leaf nodes have no child nodes.
// - Be comfortable with the tree terminology such as parent, child, leaf and root. Many of these terms are common tongue for fellow programmers and will be used to help explain other tree structures.
// - Traversals, such as depth-first and level-order traversals, aren’t specific to the general tree. They work on other trees as well, although their implementation will be slightly different based on how the tree is structured.


func makeNumberTree() -> TreeNode<Int> {
    let tree = TreeNode(15)
    
    let second1 = TreeNode(1)
    let second2 = TreeNode(17)
    let second3 = TreeNode(20)
    
    let second1A = TreeNode(11)
    let second1B = TreeNode(5)
    let second1C = TreeNode(0)
    
    let second2A = TreeNode(2)
    
    let second3A = TreeNode(9)
    let second3B = TreeNode(8)
    let second3C = TreeNode(3)
    
    tree.add(second1)
    tree.add(second2)
    tree.add(second3)
    
    second1.add(second1A)
    second1.add(second1B)
    second1.add(second1C)
    
    second2.add(second2A)
    
    second3.add(second3A)
    second3.add(second3B)
    second3.add(second3C)
    return tree
}

// Challenge 1: Print a tree in level order
// Print all the values in a tree in an order based on their level. Nodes in the same level should be printed on the same line. For example, consider the following tree:


extension TreeNode {
    // This algorithm has a time complexity of O(n). Since you initialize the Queue data structure as an intermediary container, this algorithm also uses O(n) space.
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
}

example(of: "Print a tree in level order") {
    let makeTree = makeNumberTree()
    makeTree.printTreelevel()
}
