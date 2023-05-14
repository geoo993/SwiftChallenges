import Foundation

func example(of description: String, action: () -> Void) {
  print("\n--- Example of:", description, "---")
  action()
}

// A linked list is a collection of values arranged in a linear unidirectional sequence. A linked list has several theoretical advantages over contiguous storage options such as the Swift Array:
// - Constant time insertion and removal from the front of the list.
// - Reliable performance characteristics.


// A linked list is a chain of nodes. Nodes have two responsibilities:
// - Hold a value.
// - Hold a reference to the next node. A nil value represents the end of the list.

final class Node<Value: Comparable> {
    var value: Value
    var next: Node?
    
    init(value: Value, next: Node? = nil) {
        self.value = value
        self.next = next
    }
}

extension Node: CustomStringConvertible {
    var description: String {
        guard let next = next else {
            return "\(value)"
        }
        return "\(value) -> " + String(describing: next) + " "
    }
}

struct LinkedList<Value: Comparable> {
    // A linked list has the concept of a head and tail, which refers to the first and last nodes of the list respectively:
    var head: Node<Value>?
    var tail: Node<Value>?
    
    init() {}
    
    var isEmpty: Bool {
        head == nil
    }
    
    // We first take care of adding values.
    // There are three ways to add values to a linked list, each having their own unique performance characteristics:
    
    // - push: Adds a value at the front of the list.
    // Adding a value at the front of the list is known as a push operation. This is also known as head-first insertion. The code for it is deliciously simple.
    /*  Performance analysis, push has an insert at head behaviour, and has an O(1) time complexity */
    mutating func push(_ value: Value) {
        copyNodes()
        head = Node(value: value, next: head)
        if tail == nil {
            tail = head
        }
    }

    // - append: Adds a value at the end of the list.
    // This is meant to add a value at the end of the list, and it is known as tail-end insertion.
    /*  Performance analysis, append has an insert at tail behaviour, and has an O(1) time complexity */
    mutating func append(_ value: Value) {
        copyNodes()
      // 1- Like before, if the list is empty, you’ll need to update both head and tail to the new node. Since append on an empty list is functionally identical to push, you simply invoke push to do the work for you.
        guard !isEmpty else {
            push(value)
            return
        }
      
      // 2 - In all other cases, you simply create a new node after the tail node.
        tail?.next = Node(value: value)
      
      // 3 - Since this is tail-end insertion, your new node is also the tail of the list.
        tail = tail?.next
    }
    
    // node(at:) will try to retrieve a node in the list based on the given index. Since you can only access the nodes of the list from the head node, you’ll have to make iterative traversals.
    /*  Performance analysis, node(at has an insert after a node behaviour, and has an O(1) time complexity */
    // Here’s the play-by-play:
    func node(at index: Int) -> Node<Value>? {
      // 1 - You create a new reference to head and keep track of the current number of traversals.
        var currentNode = head
        var currentIndex = 0
      
      // 2 - Using a while loop, you move the reference down the list until you’ve reached the desired index. Empty lists or out-of-bounds indexes will result in a nil return value.
        while currentNode != nil && currentIndex < index {
            currentNode = currentNode?.next
            currentIndex += 1
        }
        return currentNode
    }

    // - insert(after:): Adds a value after a particular node of the list.
    // This operation inserts a value at a particular place in the list, and requires two steps:
    //  - Finding a particular node in the list.
    //  - Inserting the new node.
    /*  Performance analysis, insert(at has return a node at given index behaviour, and has an O(i) time complexity where i is the given index */
    
    // 1 - @discardableResult lets callers ignore the return value of this method without the compiler jumping up and down warning you about it.
    @discardableResult
    mutating func insert(
        _ value: Value,
        after node: Node<Value>
    ) -> Node<Value> {
        copyNodes()
      // 2 - In the case where this method is called with the tail node, you’ll call the functionally equivalent append method. This will take care of updating tail.
        guard tail !== node else {
            append(value)
            return tail!
        }
      // 3 - Otherwise, you simply link up the new node with the rest of the list and return the new node.
        let next = Node(value: value, next: node.next)
        node.next = next
        return next
    }
    
    // Next, you’ll focus on the opposite action: removal operations.
    // There are three main operations for removing nodes:
    
    // - pop: Removes the value at the front of the list.
    // Removing a value at the front of the list is often referred to as pop. This operation is almost as simple as push, so dive right in.
    /*  Performance analysis, pop has a remove at head behaviour, and has an O(1) time complexity */
    @discardableResult
    public mutating func pop() -> Value? {
        copyNodes()
        defer {
            // By moving the head down a node, you’ve effectively removed the first node of the list. ARC will remove the old node from memory once the method finishes, since there will be no more references attached to it. In the event that the list becomes empty, you set tail to nil.
            head = head?.next
            if isEmpty {
                tail = nil
            }
        }
        
        // pop returns the value that was removed from the list. This value is optional, since it’s possible that the list is empty.
        return head?.value
    }
    
    // - removeLast: Removes the value at the end of the list.
    // Removing the last node of the list is somewhat inconvenient. Although you have a reference to the tail node, you can’t chop it off without having a reference to the node before it. Thus, you’ll have to do an arduous traversal.
    /*  Performance analysis, removeLast has a remove at tail behaviour, and has an O(n) time complexity */
    @discardableResult
    mutating func removeLast() -> Value? {
        copyNodes()
        // 1 - If head is nil, there’s nothing to remove, so you return nil.
        guard let head = head else {
            return nil
        }
        
        // 2 - If the list only consists of one node, removeLast is functionally equivalent to pop. Since pop will handle updating the head and tail references, you’ll just delegate this work to it.
        guard head.next != nil else {
            return pop()
        }
        
        // 3 - You keep searching for a next node until current.next is nil. This signifies that current is the last node of the list.
        var prev = head
        var current = head
        
        while let next = current.next {
            prev = current
            current = next
        }

        // 4 - Since current is the last node, you simply disconnect it using the prev.next reference. You also make sure to update the tail reference.
        prev.next = nil
        tail = prev
        return current.value
    }

    // - remove(at:): Removes a value anywhere in the list.
    // The final remove operation is removing a particular node at a particular point in the list. This is achieved much like insert(after:);
    // You’ll first find the node immediately before the node you wish to remove, and then unlink it.
    /*  Performance analysis, remove(after has a remove the immediate next node behaviour, and has an O(1) time complexity */
    @discardableResult
    public mutating func remove(after node: Node<Value>) -> Value? {
        guard let node = copyNodes(returningCopyOf: node) else { return nil }
        // The unlinking of the nodes occurs in the defer block. Special care needs to be taken if the removed node is the tail node, since the tail reference will need to be updated.
        defer {
            if node.next === tail {
                tail = node
            }
            node.next = node.next?.next
        }
        return node.next?.value
    }
    
    // The strategy to achieve value semantics with COW is fairly straightforward. Before mutating the contents of the linked list, you want to perform a copy of the underlying storage and update all references (head and tail) to the new copy.
    private mutating func copyNodes() {
        // Using isKnownUniquelyReferenced, you can check whether or not the underlying node objects are being shared!
        guard !isKnownUniquelyReferenced(&head) else {
          return
        }
        guard var oldNode = head else {
            return
        }
        
        head = Node(value: oldNode.value)
        var newNode = head
        
        while let nextOldNode = oldNode.next {
            newNode?.next = Node(value: nextOldNode.value)
            newNode = newNode?.next
            
            oldNode = nextOldNode
        }
        
        tail = newNode
    }
    
    // This method shares many similarities with the previous implementation. The main difference is that it will return the newly copied node based on the passed in parameter.
    private mutating func copyNodes(
        returningCopyOf node: Node<Value>?
    ) -> Node<Value>? {
        guard !isKnownUniquelyReferenced(&head) else {
            return nil
        }
        guard var oldNode = head else {
            return nil
        }
        
        head = Node(value: oldNode.value)
        var newNode = head
        var nodeCopy: Node<Value>?
        
        while let nextOldNode = oldNode.next {
            if oldNode === node {
                nodeCopy = newNode
            }
            newNode?.next = Node(value: nextOldNode.value)
            newNode = newNode?.next
            oldNode = nextOldNode
        }
        
        return nodeCopy
    }
}

extension LinkedList: CustomStringConvertible {
    var description: String {
        guard let head = head else {
            return "Empty list"
        }
        return String(describing: head)
    }
}


example(of: "creating and linking nodes") {
    let node1 = Node(value: 1)
    let node2 = Node(value: 2)
    let node3 = Node(value: 3)
    
    node1.next = node2
    node2.next = node3
    
    print(node1)
}

example(of: "push") {
    var list = LinkedList<Int>()
    list.push(3)
    list.push(2)
    list.push(1)
    
    print(list)
}

example(of: "append") {
    var list = LinkedList<Int>()
    list.append(1)
    list.append(2)
    list.append(3)
    
    print(list)
}

example(of: "inserting at a particular index") {
    var list = LinkedList<Int>()
    list.push(3)
    list.push(2)
    list.push(1)
    
    print("Before inserting: \(list)")
    var middleNode = list.node(at: 1)!
    for _ in 1...4 {
        middleNode = list.insert(-1, after: middleNode)
    }
    print("After inserting: \(list)")
}

example(of: "pop") {
    var list = LinkedList<Int>()
    list.push(3)
    list.push(2)
    list.push(1)
    
    print("Before popping list: \(list)")
    let poppedValue = list.pop()
    print("After popping list: \(list)")
    print("Popped value: " + String(describing: poppedValue))
}

example(of: "removing the last node") {
    var list = LinkedList<Int>()
    list.push(5)
    list.push(4)
    list.push(3)
    list.push(2)
    list.push(1)
    
    print("Before removing last node: \(list)")
    let removedValue = list.removeLast()
    
    print("After removing last node: \(list)")
    print("Removed value: " + String(describing: removedValue))
}

example(of: "removing a node after a particular node") {
    var list = LinkedList<Int>()
    list.push(5)
    list.push(4)
    list.push(3)
    list.push(2)
    list.push(1)
    
    print("Before removing at particular index: \(list)")
    let index = 1
    let node = list.node(at: index - 1)!
    let removedValue = list.remove(after: node)
    
    print("After removing at index \(index): \(list)")
    print("Removed value: " + String(describing: removedValue))
}


//================ LinkedList Sequense and Collection protocol

// The Swift standard library has a set of protocols that help define what’s expected of a particular type. Each of these protocols provides certain guarantees on characteristics and performance.
// Of these set of protocols, four are referred to as collection protocols.

// Here’s a small sampler of what each protocol represents:

// - Tier 1, Sequence: A sequence type provides sequential access to its elements. This axiom comes with a caveat: Using the sequential access may destructively consume the elements.

// - Tier 2, Collection: A collection type is a sequence type that provides additional guarantees. A collection type is finite and allows for repeated nondestructive sequential access.

// - Tier 3, BidirectionalColllection: A collection type can be a bidirectional collection type if it, as the name suggests, can allow for bidirectional travel up and down the sequence. This isn’t possible for the linked list, since you can only go from the head to the tail, but not the other way around.

// - Tier 4, RandomAccessCollection: A bidirectional collection type can be a random access collection type if it can guarantee that accessing an element at a particular index will take just as long as access an element at any other index. This is not possible for the linked list, since accessing a node near the front of the list is substantially quicker than one that is further down the list.

// A linked list can earn two qualifications from the Swift collection protocols.
// - First, since a linked list is a chain of nodes, adopting the Sequence protocol makes sense.
// - Second, since the chain of nodes is a finite sequence, it makes sense to adopt the Collection protocol.

// A defining metric for performance of the Collection protocol methods is the speed of mapping an Index to a value. Unlike other storage options such as the Swift Array, the linked list cannot achieve O(1) subscript operations using integer indexes. Thus, your goal is to define a custom index that contains a reference to its respective node.


extension LinkedList: Collection {
    struct Index: Comparable {
        var node: Node<Value>?
        
        static func ==(lhs: Index, rhs: Index) -> Bool {
            switch (lhs.node, rhs.node) {
            case let (left?, right?):
                return left.next === right.next
            case (nil, nil):
                return true
            default:
                return false
            }
        }
        
        static func <(lhs: Index, rhs: Index) -> Bool {
            guard lhs != rhs else {
                return false
            }
            let nodes = sequence(first: lhs.node) { $0?.next }
            return nodes.contains { $0 === rhs.node }
        }
    }
    
    // 1 - The startIndex is reasonably defined by the head of the linked list.
    var startIndex: Index {
        Index(node: head)
    }

    // 2 - Collection defines the endIndex as the index right after the last accessible value, so you give it tail?.next.
    var endIndex: Index {
        Index(node: tail?.next)
    }

    // 3 - index(after:) dictates how the index can be incremented. You simply give it an index of the immediate next node.
    func index(after i: Index) -> Index {
        Index(node: i.node?.next)
    }

    // 4 - The subscript is used to map an Index to the value in the collection. Since you’ve created the custom index, you can easily achieve this in constant time by referring to the node’s value.
    subscript(position: Index) -> Value {
        position.node!.value
    }
}


example(of: "using collection") {
    var list = LinkedList<Int>()
    for i in 0...9 {
        list.append(i)
    }
    
    print("List: \(list)")
    print("First element: \(list[list.startIndex])")
    print("Array containing first 3 elements: \(Array(list.prefix(3)))")
    print("Array containing last 3 elements: \(Array(list.suffix(3)))")
    
    let sum = list.reduce(0, +)
    print("Sum of all values: \(sum)")
}


// =========== Value semantics and copy-on-write
// Another important quality of a Swift collections is that they have value semantics. This is implemented using copy-on-write, hereby known as COW. To illustrate this concept, you’ll verify this behavior using arrays.

example(of: "array cow") {
    let array1 = [1, 2]
    var array2 = array1
    
    print("array1: \(array1)")
    print("array2: \(array2)")
    
    print("---After adding 3 to array 2---")
    array2.append(3)
    print("array1: \(array1)")
    print("array2: \(array2)")
    
}

// The elements of array1 are unchanged when array2 is modified.
// Underneath the hood, array2 makes a copy of the underlying storage when append is called

// Now write the equivalent of LinkedList like the following
example(of: "linked list cow") {
    var list1 = LinkedList<Int>()
    list1.append(1)
    list1.append(2)
    var list2 = list1
    print("List1: \(list1)")
    print("List2: \(list2)")
    
    print("After appending 3 to list2")
    list2.append(3)
    print("List1: \(list1)")
    print("List2: \(list2)")
    
    print("Removing middle node on list2")
    if let node = list2.node(at: 0) {
      list2.remove(after: node)
    }
    print("List2: \(list2)")
}

example(of: "Sharing nodes") {
    var list1 = LinkedList<Int>()
    (1...3).forEach { list1.append($0) }
    var list2 = list1
    print("List1: \(list1)")
    print("List2: \(list2)")
    
    print("After pushing 0 to list2")
    list2.push(0)
    // Is list1 affected by push operation on list2?
    print("List1: \(list1)")
    print("List2: \(list2)")
    
    // The result of pushing 100 to list1 in this case is also safe
    print("After pushing 100 to list1")
    list1.push(100)
    print("List1: \(list1)")
    print("List2: \(list2)")
}


// Key points
// - Linked lists are linear and unidirectional. As soon as you move a reference from one node to another, you can’t go back.
// - Linked lists have a O(1) time complexity for head first insertions. Arrays have O(n) time complexity for head-first insertions.
// - Conforming to Swift collection protocols such as Sequence and Collection offers a host of helpful methods for a fairly small amount of requirements.
// - Copy-on-write behavior lets you achieve value semantics.
                                                

//=========== Reverse array
// A straightforward way to solve this problem is to use recursion. Since recursion allows you to build a call stack, you just need to call the print statements as the call stack unwinds.
private func printInReverse<T>(_ node: Node<T>?) {
  // 1 - You first start off with the base case: the condition to terminating the recursion. If node is nil, then it means you’ve reached the end of the list.
    guard let node = node else { return }

  // 2 - This is your recursive call, calling the same function with the next node.
    printInReverse(node.next)
    print(node.value)
}

func printInReverse<T>(_ list: LinkedList<T>) {
  printInReverse(list.head)
}

example(of: "Print in reverse") {
    let node1 = Node(value: 1)
    let node2 = Node(value: 2)
    let node3 = Node(value: 3)
    
    node1.next = node2
    node2.next = node3
    
    printInReverse(node1)
}

example(of: "printing in reverse") {
  var list = LinkedList<Int>()
  list.push(3)
  list.push(2)
  list.push(1)

  print("Original list: \(list)")
  print("Printing in reverse:")
  printInReverse(list)
}

//=========== Find the middle node
// One solution is to have two references traverse down the nodes of the list where one is twice as fast as the other. Once the faster reference reaches the end, the slower reference will be in the middle.

func getMiddle<T>(_ list: LinkedList<T>) -> Node<T>? {
    var slow = list.head
    var fast = list.head
    // In this declaration, you bind the next node to nextFast.
    // If there is a next node, you update fast to the next node of nextFast, effectively traversing the list twice.
    // The slow pointer is updated only once. This is known as the runner’s technique.
    while let nextFast = fast?.next {
        fast = nextFast.next
        slow = slow?.next
    }
    
    return slow
}

example(of: "getting the middle node") {
    var list = LinkedList<Int>()
    list.push(3)
    list.push(2)
    list.push(1)
    
    print(list)
    
    if let middleNode = getMiddle(list) {
        print(middleNode)
    }
    // The time complexity of this algorithm is O(n), since you traversed the list in a single pass. The runner’s technique is helpful in solving a variety of problems associated with the linked list.
}

//=========== Reverse a linked list
// To reverse a linked list, you need to visit each node and update the next reference to point in the other direction.
// This can be a tricky task, since you’ll need to manage multiple references to multiple nodes.

extension LinkedList {
    // This ethod has an O(n) time complexity, but short and sweet
    mutating func reverse1() {
        
        // 1 - You first start by pushing the current values in your list to a new tmpList. This will create a list in reverse order.
        var tmpList = LinkedList<Value>()
        for value in self {
            tmpList.push(value)
        }
        
        // 2 - You point the head of the list to the reversed nodes.
        head = tmpList.head
    }
    
    // Although O(n) is the optimal time complexity for reversing a list, there’s a significant resource cost in the previous solution. As it is now, reverse will have to allocate new nodes for each push method on the temporary list. You can avoid using the temporary list entirely, and reverse the list by manipulating the next pointers of each node. The code ends up being more complicated, but you reap considerable benefits in terms of performance.
    
    mutating func reverse2() {
        // You begin by assigning head to tail. Next, you create two references — prev and current — to keep track of traversal. The strategy is fairly straightforward: each node points to the next node down the list. You’ll traverse the list and make each node point to the previous node instead:
        tail = head
        var prev = head
        var current = head?.next
        prev?.next = nil

        // By pointing current to prev, you’ve lost the link to the rest of the list. Therefore, you’ll need to manage a third pointer.
        while current != nil {
            let next = current?.next
            current?.next = prev
            prev = current
            current = next
        }
        
        // Each time you perform the reversal, you create a new reference to the next node. After every reversal procedure, you move the two pointers to the next two nodes.
        
        // Once you’ve finished reversing all the pointers, you’ll set the head to the last node of this list.
        head = prev
    }
}

example(of: "reversing a list") {
    var list = LinkedList<Int>()
    list.push(3)
    list.push(2)
    list.push(1)
    
    print("Original list: \(list)")
    list.reverse2()
    print("Reversed list: \(list)")
    // The time complexity of your new reverse method is still O(n), the same as the trivial implementation discussed earlier.
}


//=========== Merge two lists
// The solution to this problem is to continuously pluck nodes from the two sorted lists and add them to a new list. Since the two lists are sorted, you can compare the next node of both lists to see which one should be the next one to add to the new list.

func mergeSorted<T>(left: LinkedList<T>, right: LinkedList<T>) -> LinkedList<T> {
    // If one is empty, you return the other.
    guard !left.isEmpty else {
      return right
    }

    guard !right.isEmpty else {
      return left
    }

    // You introduce a new reference to hold a sorted list of Node objects. The strategy is to merge the nodes in left and right onto newHead in sorted order.
    var newHead: Node<T>?
    
    // 1 - You create a pointer to the tail of the new list you’re adding to. This allows for constant-time append operations.
    var tail: Node<T>?
    var currentLeft = left.head
    var currentRight = right.head
    // 2 - You compare the first nodes of left and right to assign newHead.
    if let leftNode = currentLeft, let rightNode = currentRight {
        if leftNode.value < rightNode.value {
            newHead = leftNode
            currentLeft = leftNode.next
        } else {
            newHead = rightNode
            currentRight = rightNode.next
        }
        tail = newHead
    }
    
    // Next, you’ll need to iterate through both left and right, cherry picking the nodes to add to ensure that the new list is sorted
    
    // 1 - The while loop will continue until one of the list reaches the end.
    while let leftNode = currentLeft, let rightNode = currentRight {
      // 2 - Much like before, you do a comparison on the nodes to find out which node to connect to tail.
        if leftNode.value < rightNode.value {
            tail?.next = leftNode
            currentLeft = leftNode.next
        } else {
            tail?.next = rightNode
            currentRight = rightNode.next
        }
        tail = tail?.next
    }
    
    // Since this loop depends on both currentLeft and currentRight, it will terminate even if there are nodes left on either list.
    if let leftNodes = currentLeft {
        tail?.next = leftNodes
    }
    
    if let rightNodes = currentRight {
        tail?.next = rightNodes
    }
    
    // To wrap things up, you instantiate a new list. Instead of using using the append or insert methods to insert elements to the list, you’ll simply set the reference of the head and tail of the list directly:
    var list = LinkedList<T>()
    list.head = newHead
    list.tail = {
        while let next = tail?.next {
            tail = next
        }
        return tail
    }()
    return list
}
// This algorithm has a time complexity of O(m + n), where m is the # of nodes in the first list, and n is the # of nodes in the second list.

example(of: "merging two lists") {
    var list = LinkedList<Int>()
    list.push(3)
    list.push(2)
    list.push(1)
    var anotherList = LinkedList<Int>()
    anotherList.push(-1)
    anotherList.push(-2)
    anotherList.push(-3)
    print("First list: \(list)")
    print("Second list: \(anotherList)")
    let mergedList = mergeSorted(left: list, right: anotherList)
    print("Merged list: \(mergedList)")
}

//=========== Remove all occurences
// The goal of this solution is to traverse down the list, removing all nodes that matches the element you want to remove. Each time you perform a removal, you need to reconnect the predecessor node with the successor node. While this can get complicated, it’s well worth it to practice this technique. Many data structures and algorithms will rely on clever uses of pointer arithmetic to build.
extension LinkedList {
    mutating func removeAllOccurences(of value: Value) {
        // Trimming the head
        // The first case to consider is when the head of the list contains the value that you want to remove.
        // You first deal with the case where the head of the list contains the value you want to remove. Since it’s possible to have a sequence of nodes with the same value, you use a while loop to ensure that you remove them all.
        while let currentHead = head, currentHead.value == value {
            head = currentHead.next
        }
        
        // Unlinking the nodes
        // Like many of the algorithms associated with the linked list, you’ll be leveraging your pointer arithmetic skills to unlink the nodes.
        // You’ll need to traverse the list using two pointers. The else block of the guard statement will trigger if it’s necessary to remove the node.
        var prev = head
        var current = head?.next
        while let currentNode = current {
            guard currentNode.value != value else {
                prev?.next = currentNode.next
                current = prev?.next
                continue
            }
            // Keep traveling…
            // Can you tell what’s missing? As it is right now, the while statement may never terminate. You need to move the prev and current pointers along.
            prev = current
            current = current?.next
        }
        
        // Finally, you’ll update the tail of the linked list. This is necessary in the case where the original tail is a node containing the value you wanted to remove.
        tail = prev
    }
}

example(of: "deleting duplicate nodes") {
    var list = LinkedList<Int>()
    list.push(3)
    list.push(4)
    list.push(4)
    list.push(3)
    list.push(2)
    list.push(2)
    list.push(1)
    list.push(1)
    
    list.removeAllOccurences(of: 3)
    print(list)
}
