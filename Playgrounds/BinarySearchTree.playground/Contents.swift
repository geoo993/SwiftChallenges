import Foundation

func example(of description: String, action: () -> Void) {
  print("\n--- Example of:", description, "---")
  action()
}

// A binary search tree, or BST, is a data structure that facilitates fast lookup, insert and removal operations.
// Once you make a decision and choose a branch there is no looking back.
// You keep going until you make a final decision at a leaf node.
// Binary trees let you do the same thing. Specifically, a binary search tree imposes two rules on the binary tree:
// - The value of a left child must be less than the value of its parent.
// - Consequently, the value of a right child must be greater than or equal to the value of its parent.

// Binary search trees use this property to save you from performing unnecessary checking. As a result, lookup, insert and removal have an average time complexity of O(log n), which is considerably faster than linear data structures such as arrays and linked lists.

// Every time the search algorithm visits a node in the BST, it can safely make these two assumptions:
// 1- If the search value is less than the current value, it must be in the left subtree.
// 2- If the search value value is greater than the current value, it must be in the right subtree.
// By leveraging the rules of the BST, you can avoid unnecessary checks and cut the search space in half every time you make a decision. That’s why element lookup in a BST is an O(log n) operation.

// Binary search trees drastically reduce the number of steps for add, remove and lookup operations
class BinaryNode<Element: Equatable> {
    var value: Element
    var leftChild: BinaryNode?
    var rightChild: BinaryNode?
    
    init(value: Element) {
        self.value = value
    }
}

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

struct BinarySearchTree<Element: Comparable> {
    private(set) var root: BinaryNode<Element>?
    init() {}
    
}

extension BinarySearchTree: CustomStringConvertible {
    var description: String {
        guard let root = root else { return "empty tree" }
        return String(describing: root)
    }
}

extension BinarySearchTree {

    // Inserting elements
    // In accordance with the rules of the BST, nodes of the left child must contain values less than the current node. Nodes of the right child must contain values greater than or equal to the current node. You’ll implement the insert method while respecting these rules.
    mutating func insert(_ value: Element) {
        root = insert(from: root, value: value)
    }
  
    private func insert(
        from node: BinaryNode<Element>?,
        value: Element
    ) -> BinaryNode<Element> {
        // 1 - This is a recursive method, so it requires a base case for terminating recursion. If the current node is nil, you’ve found the insertion point and you return the new BinaryNode.
        guard let node = node else {
            return BinaryNode(value: value)
        }
        // 2 - This if statement controls which way the next insert call should traverse. If the new value is less than the current value, you call insert on the left child. If the new value is greater than or equal to the current value, you’ll call insert on the right child.
        if value < node.value {
            node.leftChild = insert(from: node.leftChild, value: value)
        } else {
            node.rightChild = insert(from: node.rightChild, value: value)
        }
        // 3 - Return the current node. This makes assignments of the form node = insert(from: node, value: value) possible as insert will either create node (if it was nil) or return node (it it was not nil).
        return node
    }
}

example(of: "building a BST - Unbalanced tree") {
    // This tree looks a bit unbalanced, but it does follow the rules.
    // An unbalanced tree affects performance.
    // If you insert 5 into the unbalanced tree you’ve created, it becomes an O(n) operation
    var bst = BinarySearchTree<Int>()
    for i in 0..<5 {
        bst.insert(i)
    }
    print(bst)
}

// Balanced tree
var exampleTree: BinarySearchTree<Int> {
    var bst = BinarySearchTree<Int>()
    bst.insert(3)
    bst.insert(7)
    bst.insert(1)
    bst.insert(15)
    bst.insert(4)
    bst.insert(18)
    bst.insert(0)
    bst.insert(2)
    bst.insert(5)
    bst.insert(8)
    return bst
}

var binarytree: BinaryNode<Int> = {
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
    
    zero.leftChild = forty
    zero.rightChild = twelve
    
    five.leftChild = eighten
    five.rightChild = nineteen
    
    seven.rightChild = nine
    
    nine.leftChild = eight
    nine.rightChild = eleven
    
    eight.leftChild = twentyTwo
    eight.rightChild = twenty
    
    return seven
}()


example(of: "building a BST - balanced tree") {
    print(exampleTree)
    print(binarytree)
}

// Finding elements
// Finding an element in a BST requires you to traverse through its nodes.
// It’s possible to come up with a relatively simple implementation by using the existing traversal mechanisms from the BinaryTree.
extension BinarySearchTree {
    
    // // In-order traversal has a time complexity of O(n), thus this implementation of contains has the same time complexity as an exhaustive search through an unsorted array. However, you can do better.
    func contains(_ value: Element) -> Bool {
        guard let root = root else {
            return false
        }
        var found = false
        root.traverseInOrder {
            if $0 == value {
                found = true
            }
        }
        return found
    }
    
    // You can rely on the rules of the BST to avoid needless comparisons.
    // This implementation of hasElement is an O(log n) operation in balanced binary search tree.
    func hasElement(_ value: Element) -> Bool {
        // 1 - Start by setting current to the root node.
        var current = root
        // 2 - While current is not nil, check the current node’s value.
        while let node = current {
            // 3 - If the value is equal to what you’re trying to find, return true.
            if node.value == value {
                return true
            }
            // 4 - Otherwise, decide whether you’re going to check the left or the right child.
            if value < node.value {
                current = node.leftChild
            } else {
                current = node.rightChild
            }
        }
        return false
    }
}


example(of: "finding a node") {
    if exampleTree.hasElement(15) {
        print("Found 15!")
    } else {
        print("Couldn’t find 15")
    }
}


// Removing elements
// Removing elements is a little more tricky, as there are a few different scenarios you need to handle.

// Case 1: Leaf node
// Removing a leaf node is straightforward; simply detach the leaf node.
// For non-leaf nodes, however, there are extra steps you must take.

// Case 2: Nodes with one child
// When removing nodes with one child, you’ll need to reconnect that one child with the rest of the tree:

// Case 3: Nodes with two children
// Nodes with two children are a bit more complicated, so a more complex example tree will serve better to illustrate how to handle this situation.

// When removing a node with two children, replace the node you removed with smallest node in its right subtree. Based on the rules of the BST, this is the leftmost node of the right subtree
// It’s important to note that this produces a valid binary search tree.
// Because the new node was the smallest node in the right subtree, all nodes in the right subtree will still be greater than or equal to the new node.
// And because the new node came from the right subtree, all nodes in the left subtree will be less than the new node.

private extension BinaryNode {
    // We add a recursive min property to BinaryNode to find the minimum node in a subtree.
    var min: BinaryNode {
        leftChild?.min ?? self
    }
}

extension BinarySearchTree {
    mutating func remove(_ value: Element) {
        root = remove(node: root, value: value)
    }
    
    private func remove(node: BinaryNode<Element>?, value: Element)
    -> BinaryNode<Element>? {
        guard let node = node else {
            return nil
        }
        if value == node.value {
            // 1 - In the case in which the node is a leaf node, you simply return nil, thereby removing the current node.
            if node.leftChild == nil && node.rightChild == nil {
              return nil
            }
            // 2 - If the node has no left child, you return node.rightChild to reconnect the right subtree.
            if node.leftChild == nil {
              return node.rightChild
            }
            // 3 - If the node has no right child, you return node.leftChild to reconnect the left subtree.
            if node.rightChild == nil {
              return node.leftChild
            }
            // 4 - This is the case in which the node to be removed has both a left and right child. You replace the node’s value with the smallest value from the right subtree. You then call remove on the right child to remove this swapped value.
            guard let rightNode = node.rightChild else { return nil }
            node.value = rightNode.min.value
            node.rightChild = remove(node: node.rightChild, value: node.value)
        } else if value < node.value {
            node.leftChild = remove(node: node.leftChild, value: value)
        } else {
            node.rightChild = remove(node: node.rightChild, value: value)
        }
        return node
    }
}

example(of: "removing a node") {
    var tree = exampleTree
    print("Tree before removal:")
    print(tree)
    tree.remove(3)
    print("Tree after removing root:")
    print(tree)
}

// Key points
//  - The binary search tree is a powerful data structure for holding sorted data.
// - Elements of the binary search tree must be comparable. This can be achieved using a generic constraint or by supplying closures to compare with.
// - The time complexity for insert, remove and contains methods in a BST is O(log n).
// - Performance will degrade to O(n) as the tree becomes unbalanced.
// - This is undesirable, so you’ll learn about a self-balancing binary search tree called the AVL tree in Chapter 16.


// Challenge 1: Binary tree or binary search tree?
// Create a function that checks if a binary tree is a binary search tree.
extension BinaryNode where Element: Comparable {
    var isBinarySearchTree: Bool {
        isBST(self, min: nil, max: nil)
    }

  // 1 - isBST is responsible for recursively traversing through the tree and checking for the BST property. It needs to keep track of progress via a reference to a BinaryNode, and also keep track of the min and max values to verify the BST property.
    private func isBST(
        _ tree: BinaryNode<Element>?,
        min: Element?,
        max: Element?
    ) -> Bool {
        // 2 - This is the base case. If tree is nil, then there are no nodes to inspect. A nil node is a binary search tree, so you’ll return true in that case.
        guard let tree = tree else {
            return true
        }
        
        // 3 - This is essentially a bounds check. If the current value exceeds the bounds of the min and max, the current node does not respect the binary search tree rules.
        if let min = min, tree.value <= min {
            return false
        } else if let max = max, tree.value > max {
            return false
        }
        
        // 4 - This line contains the recursive calls. When traversing through the left children, the current value is passed in as the max value. This is because any nodes in the left side cannot be greater than the parent. ice versa, when traversing to the right, the min value is updated to the current value. Any nodes in the right side must be greater than the parent. If any of the recursive calls evaluate false, the false value will propagate back to the top.
        return isBST(tree.leftChild, min: min, max: tree.value) &&
        isBST(tree.rightChild, min: tree.value, max: max)
    }
}

func isBinarySearchTree<T: Comparable>(root: BinaryNode<T>?) -> Bool {
    var current = root
    while let node = current {
        
        if let left = node.leftChild, let right = node.rightChild, left.value > right.value {
            return false
        }
        
        if let left = node.leftChild {
            current = left
            continue
        } else {
            current = node.rightChild
            continue
        }
    }
    return true
}

example(of: "Binary tree or binary search tree?") {
    let isSearchTree = exampleTree.root?.isBinarySearchTree// isBinarySearchTree(root: exampleTree.root)
    print("Is this a binary search tree?", isSearchTree)
    
    let isTree = binarytree.isBinarySearchTree//isBinarySearchTree(root: binarytree)
    print(binarytree)
    print("Is this a binary search tree?", isTree)
}


// Challenge 2: Equatable
// The binary search tree currently lacks Equatable conformance. Your challenge is to conform adopt the Equatable protocol.

extension BinaryNode: Equatable {
    // 1 - This is the function that the Equatable protocol requires. Inside the function, you’ll return the result from the isEqual helper function
    static func == (lhs: BinaryNode<Element>, rhs: BinaryNode<Element>) -> Bool {
        isEqual(lhs, rhs)
    }
    
    // 2 - isEqual will recursively check two nodes and its descendents for equality.
    private static func isEqual<Element: Equatable>(
        _ node1: BinaryNode<Element>?,
        _ node2: BinaryNode<Element>?
    ) -> Bool {
        
        // 3 - This is the base case. If one or more of the nodes are nil, then there’s no need to continue checking. If both nodes are nil, they are equal. Otherwise, one is nil and one isn’t nil, so they must not be equal.
        guard let leftNode = node1, let rightNode = node2 else {
            return node1 == nil && node2 == nil
        }
        
        // 4 - Here, you check the value of the left and right nodes for equality. You also recursively check the left children and right children for equality.
        return leftNode.value == rightNode.value &&
        isEqual(leftNode.leftChild, rightNode.leftChild) &&
        isEqual(leftNode.rightChild, rightNode.rightChild)
    }
}

extension BinarySearchTree: Equatable {
    static func == (lhs: BinarySearchTree<Element>, rhs: BinarySearchTree<Element>) -> Bool {
        guard let leftNode = lhs.root, let rightNode = rhs.root else {
            return lhs.root == nil && rhs.root == nil
        }
        return leftNode == rightNode
    }
}


example(of: "is tree equatable") {
    var firstTree = exampleTree.root
    let searchTree = firstTree
    print("Is this same a binary search tree?", searchTree == binarytree)
}


// Challenge 3: Is it a subtree?
// Create a method that checks if the current tree contains all the elements of another tree. You may require that elements are Hashable.

// 1- we make use of a Set for this solution. To insert elements into a Set, the elements must be Hashable, so you first constrain the extension where Element is Hashable.
extension BinarySearchTree where Element: Hashable {
    // The goal is to create a method that checks if the current tree contains all the elements of another tree
    func contains(_ subtree: BinarySearchTree) -> Bool {
        
        // 2 - Inside the contains function, you begin by inserting all the elements of the current tree into the set.
        var set: Set<Element> = []
        root?.traverseInOrder {
            set.insert($0)
        }
        
        // 3 - isEqual is to store the end result. The reason you need this is because traverseInOrder takes a closure and you cannot directly return from inside the closure.
        var isEqual = true
        
        // 4 - For every element in the subtree, you check if the value is contained in the set. If at any point set.contains($0) evaluates as false, you’ll make sure isEqual stays false even if subsequent elements evaluate as true by assigning isEqual && set.contains($0) to itself.
        subtree.root?.traverseInOrder {
            isEqual = isEqual && set.contains($0)
        }
        
        // The time complexity for this algorithm is O(n). The space complexity for this algorithm is O(n).
        return isEqual
    }
}
