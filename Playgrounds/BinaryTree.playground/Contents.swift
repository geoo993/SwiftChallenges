import Foundation

func example(of description: String, action: () -> Void) {
  print("\n--- Example of:", description, "---")
  action()
}


// A binary tree is a tree in which each node has at most two children, often referred to as the left and right children
// Binary trees serve as the basis for many tree structures and algorithms.

class BinaryNode<Element> {
    var value: Element
    var leftChild: BinaryNode?
    var rightChild: BinaryNode?
    
    init(value: Element) {
        self.value = value
    }
}

var tree: BinaryNode<Int> = {
    let zero = BinaryNode(value: 0)
    let one = BinaryNode(value: 1)
    let five = BinaryNode(value: 5)
    let seven = BinaryNode(value: 7)
    let eight = BinaryNode(value: 8)
    let nine = BinaryNode(value: 9)
    
    let eleven = BinaryNode(value: 11)
    let twelve = BinaryNode(value: 12)
    let forty = BinaryNode(value: 40)
    
    let twentyTwo = BinaryNode(value: 22)
    let twenty = BinaryNode(value: 20)
    let eighten = BinaryNode(value: 18)
    let nineteen = BinaryNode(value: 19)
    
    seven.leftChild = one
    
    one.leftChild = zero
    one.rightChild = five
    
    zero.leftChild = twelve
    zero.rightChild = forty
    
    five.leftChild = eighten
    five.rightChild = nineteen
    
    seven.rightChild = nine
    
    nine.leftChild = eight
    nine.rightChild = eleven
    
    eight.leftChild = twentyTwo
    eight.rightChild = twenty
    
    return seven
}()

extension BinaryNode: CustomStringConvertible {
    var description: String {
        diagram(for: self)
    }
    
    // diagram will recursively create a string representing the binary tree.
    // To try it out, head back to the playground and write the following
    private func diagram(
        for node: BinaryNode?,
        _ top: String = "",
        _ root: String = "",
        _ bottom: String = ""
    ) -> String {
        guard let node = node else {
            return root + "nil\n"
        }
        if node.leftChild == nil && node.rightChild == nil {
            return root + "\(node.value)\n"
        }
        return diagram(
            for: node.rightChild,
            top + "  ", top + "┌──", top + "│ "
        )
        + root + "\(node.value)\n"
        + diagram(
            for: node.leftChild,
            bottom + "│ ", bottom + "└──", bottom + "  "
        )
    }
}

example(of: "tree diagram") {
    print(tree)
}

// Previously, you looked at a level-order traversal of a tree. With a few tweaks, you can make this algorithm work for binary trees as well. However, instead of re-implementing level-order traversal, you’ll look at three traversal algorithms for binary trees:
// in-order, pre-order and post-order traversals.


// In-order traversal
// In-order traversal visits the nodes of a binary tree in the following order, starting from the root node:
// 1) If the current node has a left child, recursively visit this child first.
// 2) Then visit the node itself.
// 3) If the current node has a right child, recursively visit this child.

extension BinaryNode {
    func traverseInOrder(visit: (Element) -> Void) {
        leftChild?.traverseInOrder(visit: visit)
        visit(value)
        rightChild?.traverseInOrder(visit: visit)
    }
    
    func traversePreOrder(visit: (Element) -> Void) {
        visit(value)
        leftChild?.traversePreOrder(visit: visit)
        rightChild?.traversePreOrder(visit: visit)
    }
    
    func traversePostOrder(visit: (Element) -> Void) {
      leftChild?.traversePostOrder(visit: visit)
      rightChild?.traversePostOrder(visit: visit)
      visit(value)
    }
}

example(of: "in-order traversal") {
    tree.traverseInOrder { print($0) }
}

// Pre-order traversal
// Pre-order traversal always visits the current node first, then recursively visits the left and right child
example(of: "pre-order traversal") {
    tree.traversePreOrder { print($0) }
}

// Post-order traversal
// Post-order traversal only visits the current node after the left and right child have been visited recursively.
example(of: "post-order traversal") {
    tree.traversePostOrder { print($0) }
}


// Each one of these traversal algorithms has both a time and space complexity of O(n).
// While this version of the binary tree isn’t too interesting, you saw that in-order traversal can be used to visit the nodes in ascending order.
// Binary trees can enforce this behavior by adhering to some rules during insertion.

// Key points
// The binary tree is the foundation to some of the most important tree structures. The binary search tree and AVL tree are binary trees that impose restrictions on the insertion/deletion behaviors.
// In-order, pre-order and post-order traversals aren’t just important only for the binary tree; if you’re processing data in any tree, you’ll use these traversals regularly.


// Challenge 1: Height of a Tree
// Given a binary tree, find the height of the tree.
// The height of the binary tree is determined by the distance between the root and the furthest leaf.
// The height of a binary tree with a single node is zero, since the single node is both the root and the furthest leaf.
// A recursive approach for finding the height of a binary tree is quite simple.
func heightOfNode<T>(of node: BinaryNode<T>?) -> Int {
  // 1 - This is the base case for the recursive solution. If the node is nil, you’ll return -1.
    guard let node = node else {
        return -1
    }
   
  // 2 - Here, you recursively call the height function. For every node you visit, you add one to the height of the highest child.
    return 1 + max(heightOfNode(of: node.leftChild), heightOfNode(of: node.rightChild))
    
    // This algorithm has a time complexity of O(n) since you need to traverse through all the nodes. This algorithm incurs a space cost of O(n), since you need to make the same n recursive calls to the call stack.
}
    
example(of: "tree height") {
    let height = heightOfNode(of: tree)
    print("Height", height)
}

// Challendge 2: Serialization
//A common task in software development is serializing an object into another data type. This process is known as serialization, and allows custom types to be used in systems that only support a closed set of data types.
// An example of serialization is JSON. Your task is to devise a way to serialize a binary tree into an array, and a way to deserialize the array back into the same binary tree.

extension BinaryNode {
    // This is the pre-order traversal function. As the code suggests, pre-order traversal will traverse each node and visit the node before traversing the children.
    // It’s important to point out that you’ll need to also visit the nil nodes since it’s important to record those for serialization and deserialization.
    // As with all traversal functions, this algorithm goes through every element of the tree once, so it has a time complexity of O(n).
    func traversePreOrderToArray(visit: (Element?) -> Void) {
        visit(value)
        if let leftChild = leftChild {
            leftChild.traversePreOrder(visit: visit)
        } else {
            visit(nil)
        }
        if let rightChild = rightChild {
            rightChild.traversePreOrder(visit: visit)
        } else {
            visit(nil)
        }
    }
}

// The time complexity of the serialization step is O(n).
// Since you’re creating a new array, this also incurs a O(n) space cost.
func serialize<T>(_ node: BinaryNode<T>) -> [T?] {
    var array: [T?] = []
    node.traversePreOrderToArray { array.append($0) }
    return array
}

example(of: "Serialization") {
    let array = serialize(tree)
    print("Array", array)
}

// Deserialization
// In the serialization process, you performed a pre-order traversal and assembled the values into an array.
// The deserialization process is to take each value of the array and reassemble it back to the tree.

// 1 - The deserialize function takes an inout array of values. This is important because you’ll be able to make mutations to the array in each recursive step and allow future recursive calls to see the changes.
func deserialize<T>(_ array: inout [T?])
  -> BinaryNode<T>? {
  
  // 2 - This is the base case. If removeFirst returns nil, there are no more elements in the array, thus you’ll end recursion here.
      guard !array.isEmpty, let value = array.removeFirst() else {
          return nil
      }
  
  // 3 - You reassemble the tree by creating a node from the current value, and recursively calling deserialize to assign nodes to the left and right children. Notice this is very similar to the pre-order traversal, except you are building nodes rather than extracting their values.
      let node = BinaryNode(value: value)
      node.leftChild = deserialize(&array)
      node.rightChild = deserialize(&array)
      return node
}

func deserialize<T>(_ array: [T?]) -> BinaryNode<T>? {
    var reversed = Array(array.reversed())
    return deserialize(&reversed)
}

example(of: "Deserialization") {
    var array = serialize(tree)
    let node = deserialize(array)
    print(node!)
}


