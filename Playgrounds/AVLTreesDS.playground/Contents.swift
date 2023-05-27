import Foundation

func example(of description: String, action: () -> Void) {
  print("\n--- Example of:", description, "---")
  action()
}

// you learned about the O(log n) performance characteristics of the binary search tree.
// However, you also learned that unbalanced trees can deteriorate the performance of the tree, all the way down to O(n).
// In 1962, Georgy Adelson-Velsky and Evgenii Landis came up with the first self-balancing binary search tree: The AVL Tree. In this chapter, you’ll dig deeper into how the balance of a binary search tree can impact performance and implement the AVL tree from scratch!

// A balanced tree is the key to optimizing the performance of the binary search tree.

// - Perfect balance
// The ideal form of a binary search tree is the perfectly balanced state. In technical terms, this means every level of the tree is filled with nodes, from top to bottom.
// Not only is the tree perfectly symmetrical, the nodes at the bottom level are completely filled. This is the requirement for being perfectly balanced.

// - “Good-enough” balance
// Although achieving perfect balance is ideal, it is rarely possible.
// A perfectly balanced tree has to contain the exact number of nodes to fill every level to the bottom, so it can only be perfect with a particular number of elements.

// As an example, a tree with 1, 3 or 7 nodes can be perfectly balanced, but a tree with 2, 4, 5 or 6 cannot be perfectly balanced, since the last level of the tree will not be filled.
// The definition of a balanced tree is that every level of the tree must be filled, except for the bottom level. In most cases of binary trees, this is the best you can do.

// - Unbalanced
// Finally, there’s the unbalanced state.
// Binary search trees in this state suffer from various levels of performance loss, depending on the degree of imbalance.
// Keeping the tree balanced gives the find, insert and remove operations an O(log n) time complexity.

// AVL trees maintain balance by adjusting the structure of the tree when the tree becomes unbalanced.

protocol TraversableBinaryNode {
    associatedtype Element
    var value: Element { get }
    var leftChild: Self? { get }
    var rightChild: Self? { get }
    func traverseInOrder(visit: (Element) -> Void)
    func traversePreOrder(visit: (Element) -> Void)
    func traversePostOrder(visit: (Element) -> Void)
}

extension TraversableBinaryNode {
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

final class AVLNode<Element>: TraversableBinaryNode {
    var value: Element
    var leftChild: AVLNode?
    var rightChild: AVLNode?
    var height = 0
    
    init(value: Element) {
        self.value = value
    }
}

extension AVLNode: CustomStringConvertible {
    var description: String {
        diagram(for: self)
    }
    
    func diagram(
        for node: AVLNode?,
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
            for: node.rightChild, top + "  ", top + "┌──", top + "│ "
        )
        + root + "\(node.value)\n"
        + diagram(
            for: node.leftChild, bottom + "│ ", bottom + "└──", bottom + "  "
        )
    }
}

struct AVLTree<Element: Comparable> {
    private(set) var root: AVLNode<Element>?
    init() {}
}

extension AVLTree: CustomStringConvertible {
    var description: String {
        guard let root = root else { return "empty tree" }
        return String(describing: root)
    }
}

extension AVLTree {
    mutating func insert(_ value: Element) {
        root = insert(from: root, value: value)
    }
    
//    private func insert(from node: AVLNode<Element>?, value: Element) -> AVLNode<Element> {
//        guard let node = node else {
//            return AVLNode(value: value)
//        }
//        if value < node.value {
//            node.leftChild = insert(from: node.leftChild, value: value)
//        } else {
//            node.rightChild = insert(from: node.rightChild, value: value)
//        }
//        return node
//    }
}

extension AVLTree {
    func contains(_ value: Element) -> Bool {
        var current = root
        while let node = current {
            if node.value == value {
                return true
            }
            if value < node.value {
                current = node.leftChild
            } else {
                current = node.rightChild
            }
        }
        return false
    }
}

private extension AVLNode {
    var min: AVLNode {
        leftChild?.min ?? self
    }
}

extension AVLTree {
    mutating func remove(_ value: Element) {
        root = remove(node: root, value: value)
    }
    
//    private func remove(node: AVLNode<Element>?, value: Element) -> AVLNode<Element>? {
//        guard let node = node else {
//            return nil
//        }
//        if value == node.value {
//            if node.leftChild == nil && node.rightChild == nil {
//                return nil
//            }
//            if node.leftChild == nil {
//                return node.rightChild
//            }
//            if node.rightChild == nil {
//                return node.leftChild
//            }
//            node.value = node.rightChild!.min.value
//            node.rightChild = remove(node: node.rightChild, value: node.value)
//        } else if value < node.value {
//            node.leftChild = remove(node: node.leftChild, value: value)
//        } else {
//            node.rightChild = remove(node: node.rightChild, value: value)
//        }
//        return node
//    }
}

// Binary search trees and AVL trees share much of the same implementation; in fact, all that you’ll add is the balancing component

// To keep a binary tree balanced, you’ll need a way to measure the balance of the tree. The AVL tree achieves this with a height property in each node. In tree-speak, the height of a node is the longest distance from the current node to a leaf node:

extension AVLNode {
    
    // You’ll use the relative heights of a node’s children to determine whether a particular node is balanced.
    // The height of the left and right children of each node must differ at most by 1.
    // This is known as the balance factor.
    // The balanceFactor computes the height difference of the left and right child.
    var balanceFactor: Int {
        leftHeight - rightHeight
    }
    
    // If a particular child is nil, its height is considered to be -1.
    var leftHeight: Int {
        leftChild?.height ?? -1
    }
    
    var rightHeight: Int {
        rightChild?.height ?? -1
    }
}

var exampleTree: AVLTree<Int> {
    var bst = AVLTree<Int>()
    bst.insert(50)
    bst.insert(25)
    bst.insert(37)
    bst.insert(75)
    bst.insert(40)
    return bst
}


example(of: "AVL - balanced tree") {
    print(exampleTree)
}


// Rotations
//The procedures used to balance a binary search tree are known as rotations.
//There are four rotations in total, for the four different ways that a tree can become unbalanced. These are known as left rotation, left-right rotation, right rotation and right-left rotation.

// The imbalance caused by inserting 40 into the tree can be solved by a left rotation.

extension AVLTree {
    func leftRotate(
        _ node: AVLNode<Element>
    ) -> AVLNode<Element> {
      
      // 1 - The right child is chosen as the pivot. This node will replace the rotated node as the root of the subtree (it will move up a level).
        guard let pivot = node.rightChild else { return node }
        // 2 - The node to be rotated will become the left child of the pivot (it moves down a level). This means that the current left child of the pivot must be moved elsewhere.
        node.rightChild = pivot.leftChild
        // 3 - The pivot’s leftChild can now be set to the rotated node.
        pivot.leftChild = node
        // 4 - You update the heights of the rotated node and the pivot.
        node.height = max(node.leftHeight, node.rightHeight) + 1
        pivot.height = max(pivot.leftHeight, pivot.rightHeight) + 1
        // 5 - Finally, you return the pivot so that it can replace the rotated node in the tree.
        return pivot
    }
}

// Right rotation
// Right rotation is the symmetrical opposite of left rotation. When a series of left children is causing an imbalance, it’s time for a right rotation.
// A generic right rotation of node x looks like this:

extension AVLTree {
    // This is nearly identical to the implementation of leftRotate, except the references to the left and right children have been swapped.
    func rightRotate(
        _ node: AVLNode<Element>
    ) -> AVLNode<Element> {
        
        guard let pivot = node.rightChild else { return node }
        node.leftChild = pivot.rightChild
        pivot.rightChild = node
        node.height = max(node.leftHeight, node.rightHeight) + 1
        pivot.height = max(pivot.leftHeight, pivot.rightHeight) + 1
        return pivot
    }
}


// Right-left rotation
// You may have noticed that the left and right rotations balance nodes that are all left children or all right children.
//  Consider the case in which 36 is inserted into the tree below.


// Doing a left rotation in this case won’t result in a balanced tree. The way to handle cases like this is to perform a right rotation on the right child before doing the left rotation.
// 1) You apply a right rotation to 37.
// 2) Now that nodes 25, 36 and 37 are all right children, you can apply a left rotation to balance the tree.
extension AVLTree {
    func rightLeftRotate(
        _ node: AVLNode<Element>
    ) -> AVLNode<Element> {
        guard let rightChild = node.rightChild else {
            return node
        }
        node.rightChild = rightRotate(rightChild)
        return leftRotate(node)
    }
}

// Left-right rotation
// Left-right rotation is the symmetrical opposite of the right-left rotation.

extension AVLTree {
    func leftRightRotate(
        _ node: AVLNode<Element>
    ) -> AVLNode<Element> {
        guard let leftChild = node.leftChild else {
            return node
        }
        node.leftChild = leftRotate(leftChild)
        return rightRotate(node)
    }
}

// Balance
// The next task is to design a method that uses balanceFactor to decide whether a node requires balancing or not.

extension AVLTree {
    func balanced(
        _ node: AVLNode<Element>
    ) -> AVLNode<Element> {
        switch node.balanceFactor {
        case 2:
            // A balanceFactor of 2 suggests that the left child is “heavier” (that is, contains more nodes) than the right child. This means that you want to use either right or left-right rotations.
            if let leftChild = node.leftChild, leftChild.balanceFactor == -1 {
                return leftRightRotate(node)
            } else {
                return rightRotate(node)
            }
        case -2:
            if let rightChild = node.rightChild, rightChild.balanceFactor == 1 {
                return rightLeftRotate(node)
            } else {
                return leftRotate(node)
            }
            // A balanceFactor of -2 suggests that the right child is heavier than the left child. This means that you want to use either left or right-left rotations.
        default:
            // The default case suggests that the particular node is balanced. There’s nothing to do here except to return the node.
            return node
        }
    }
}


// balanced inspects the balanceFactor to determine the proper course of action. All that’s left is to call balance at the proper spot.
// Now Update insert(from:value:) to the following:
extension AVLTree {
    
    func insert(
        from node: AVLNode<Element>?,
        value: Element
    ) -> AVLNode<Element> {
        guard let node = node else {
            return AVLNode(value: value)
        }
        if value < node.value {
            node.leftChild = insert(from: node.leftChild, value: value)
        } else {
            node.rightChild = insert(from: node.rightChild, value: value)
        }

        // Instead of returning the node directly after inserting, you pass it into balanced.
        // This ensures every node in the call stack is checked for balancing issues.
        // You also update the node’s height.
        let balancedNode = balanced(node)
        balancedNode.height = max(balancedNode.leftHeight, balancedNode.rightHeight) + 1
        return balancedNode
    }
}

example(of: "repeated insertions in sequence") {
    var tree = AVLTree<Int>()
    for i in 0..<15 {
        tree.insert(i)
    }
    print(tree)
}


// Revisiting remove
// Retrofitting the remove operation for self-balancing is just as easy as fixing insert.
//
extension AVLTree {
    func remove(node: AVLNode<Element>?, value: Element) -> AVLNode<Element>? {
        guard let node = node else {
            return nil
        }
        if value == node.value {
            if node.leftChild == nil && node.rightChild == nil {
                return nil
            }
            if node.leftChild == nil {
                return node.rightChild
            }
            if node.rightChild == nil {
                return node.leftChild
            }
            node.value = node.rightChild!.min.value
            node.rightChild = remove(node: node.rightChild, value: node.value)
        } else if value < node.value {
            node.leftChild = remove(node: node.leftChild, value: value)
        } else {
            node.rightChild = remove(node: node.rightChild, value: value)
        }
        
        let balancedNode = balanced(node)
        balancedNode.height = max(balancedNode.leftHeight, balancedNode.rightHeight) + 1
        return balancedNode
    }
}

example(of: "removing a value") {
    var tree = AVLTree<Int>()
    tree.insert(15)
    tree.insert(10)
    tree.insert(16)
    tree.insert(18)
    print(tree)
    tree.remove(10)
    print(tree)
}

// Whew! The AVL tree is the culmination of your search for the ultimate binary search tree.
// The self-balancing property guarantees that the insert and remove operations function at optimal performance with an O(log n) time complexity.

// Key points
// - A self-balancing tree avoids performance degradation by performing a balancing procedure whenever you add or remove elements in the tree.
// - AVL trees preserve balance by readjusting parts of the tree when the tree is no longer balanced.
// - Balance is achieved by four types of tree rotations on node insertion and removal.


// Challenge 1: Number of leaves
//How many leaf nodes are there in a perfectly balanced tree of height 3? What about a perfectly balanced tree of height h?
func leafNodes(inTreeOfHeight height: Int) -> Int {
  Int(pow(2.0, Double(height)))
}

example(of: "number of leaf nodes") {
    var tree = AVLTree<Int>()
    for i in 0..<15 {
        tree.insert(i)
    }
    let height = tree.root?.height ?? 1
    print(leafNodes(inTreeOfHeight: height))
}


// Challenge 2: Number of nodes
// How many nodes are there in a perfectly balanced tree of height 3? What about a perfectly balanced tree of height h?

func nodes(inTreeOfHeight height: Int) -> Int {
    Int(pow(2.0, Double(height + 1))) - 1
}

example(of: "number of nodes") {
    var tree = AVLTree<Int>()
    for i in 0..<15 {
        tree.insert(i)
    }
    let height = tree.root?.height ?? 1
    print(nodes(inTreeOfHeight: height))
}


// Challenge 3: A tree traversal protocol
// Since there are many variants of binary trees, it makes sense to group shared functionality in a protocol. The traversal methods are a good candidate for this.
// Create a TraversableBinaryNode protocol that provides a default implementation of the traversal methods so that conforming types get these methods for free. Have AVLNode conform to this.
example(of: "using TraversableBinaryNode") {
    var tree = AVLTree<Int>()
    for i in 0..<15 {
        tree.insert(i)
    }
    tree.root?.traverseInOrder { print($0) }
}
