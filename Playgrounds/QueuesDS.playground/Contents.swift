import Foundation

func example(of description: String, action: () -> Void) {
  print("\n--- Example of:", description, "---")
  action()
}

// We are all familiar with waiting in line. Whether you are in line to buy tickets to your favorite movie or waiting for a printer to print a file, these real-life scenarios mimic the queue data structure.
// Queues use FIFO or first-in first-out ordering, meaning the first element that was added will always be the first to be removed.
// Queues are handy when you need to maintain the order of your elements to process later.

// Let’s establish a protocol for queues:

public protocol Queue {
    associatedtype Element
    mutating func enqueue(_ element: Element) -> Bool
    mutating func dequeue() -> Element?
    var isEmpty: Bool { get }
    var peek: Element? { get }
}

// The protocol describes the core operations for a queue:
// - enqueue: Insert an element at the back of the queue. Returns true if the operation was successful.
// - dequeue: Remove the element at the front of the queue and return it.
// isEmpty: Check if the queue is empty.
// peek: Return the element at the front of the queue without removing it.

// Notice that the queue only cares about removal from the front and insertion at the back. You don’t really need to know what the contents are in between. If you did, you would probably just use an array.

//      _________________________________
//     |                                 |
// Ray |  <--------- | Brian | Sam | Mic |  <-----  Vicki
//     |                                 |
//     |_________________________________|

// The queue currently holds Ray, Brian, Sam and Mic.
// Once Ray has received his ticket, he moves out of the line. By calling dequeue(),
// Ray is removed from the front of the queue.
// Calling peek will return Brian since he is now at the front of the line.
// Now comes Vicki, who just joined the line to buy a ticket. By calling enqueue("Vicki"), Vicki gets added to the back of the queue.

//================= Array-based implementation
// The Swift standard library comes with a core set of highly optimized, primitive data structures that you can use to build higher-level abstractions with.
// One of them is Array, a data structure that stores a contiguous, ordered list of elements.

struct QueueArray<T>: Queue {
    private var array: [T] = []
    init() {}
    
    var isEmpty: Bool {
        array.isEmpty // 1 - Check if the queue is empty.
    }

    var peek: T? {
        array.first // 2 - Return the element at the front of the queue.
    }
    // These operations are all O(1).
    
    // - Enqueue
    // Adding an element to the back of the queue is easy. Just append an element to the array. Add the following:
    mutating func enqueue(_ element: T) -> Bool {
        array.append(element)
        return true
    }
    // Enqueueing an element is, on average, an O(1) operation. This is because the array has empty space at the back.
    // You might find it surprising that enqueueing is an O(1) operation even though sizing is an O(n) operation.
    // Resizing, after all, requires the array to allocate new memory and copy all existing data over to the new array.
    // The key is that this doesn’t happen very often. This is because the capacity doubles each time it runs out of space.
    // As a result, if you work out the amortized cost of the operation (the average cost), enqueueing is only O(1). That said, the worst case performance is O(n) when the copy is performed.
    
    
    // Dequeue
    // Removing an item from the front requires a bit more work.
    public mutating func dequeue() -> T? {
        isEmpty ? nil : array.removeFirst()
    }
    // If the queue is empty, dequeue simply returns nil. If not, it removes the element from the front of the array and returns it.
    // Removing an element from the front of the queue is an O(n) operation. To dequeue, you remove the element from the beginning of the array.
    // This is always a linear time operation, because it requires all the remaining elements in the array to be shifted in memory.
}


extension QueueArray: CustomStringConvertible {
    public var description: String {
        String(describing: array)
    }
}

example(of: "QueueArray") {
    var queue = QueueArray<String>()
    queue.enqueue("Ray")
    queue.enqueue("Brian")
    queue.enqueue("Eric")
    queue.enqueue("Raymon")
    
    print("Added names in queue")
    print(queue)
    print("Dequeue name in queue")
    queue.dequeue()
    print(queue)
    print("Peek is", queue.peek)
    print("This shows queue is first-in is first-out")
}

// Here is a summary of the algorithmic and storage complexity of the array-based queue implementation.
// Most of the operations are constant time except for dequeue(), which takes linear time.
// Storage space is also linear.

// |     Operations    | Average case | Worst case |
// |___________________|______________|____________|
// |     enqueue       |    O(1)      |     O(n)   |
// |___________________|______________|____________|
// |     enqueue       |    O(n)      |     O(n)   |
// |___________________|___________________________|
// |  Space complexity |    O(n)      |     O(n)   |
// |___________________|______________|____________|

// You have seen how easy it is to implement an array-based queue by leveraging a Swift Array. Enqueue is on average, very fast, thanks to an O(1) append operation.


//======================== Doubly linked list implementation

// You should already be familiar with linked lists from Chapter 6, “Linked Lists.”
class Node<T> {
    var value: T
    var next: Node<T>?
    var previous: Node<T>?
    
    init(value: T) {
        self.value = value
    }
}

extension Node: CustomStringConvertible {
    var description: String {
        String(describing: value)
    }
}

class DoublyLinkedList<T> {
    
    private var head: Node<T>?
    private var tail: Node<T>?
    
    init() { }
    
    var isEmpty: Bool {
        head == nil
    }
    
    var first: Node<T>? {
        head
    }
    
    func append(_ value: T) {
        let newNode = Node(value: value)
        
        guard let tailNode = tail else {
            head = newNode
            tail = newNode
            return
        }
        
        newNode.previous = tailNode
        tailNode.next = newNode
        tail = newNode
    }
    
    func remove(_ node: Node<T>) -> T {
        let prev = node.previous
        let next = node.next
        
        if let prev = prev {
            prev.next = next
        } else {
            head = next
        }
        
        next?.previous = prev
        
        if next == nil {
            tail = prev
        }
        
        node.previous = nil
        node.next = nil
        
        return node.value
    }
}

extension DoublyLinkedList: CustomStringConvertible {
    var description: String {
        var string = ""
        var current = head
        while let node = current {
            string.append("\(node.value) -> ")
            current = node.next
        }
        return string + "end"
    }
}

class LinkedListIterator<T>: IteratorProtocol {
    
    private var current: Node<T>?
    
    init(node: Node<T>?) {
        current = node
    }
    
    func next() -> Node<T>? {
        defer { current = current?.next }
        return current
    }
}

extension DoublyLinkedList: Sequence {
    func makeIterator() -> LinkedListIterator<T> {
        LinkedListIterator(node: head)
    }
}

// A doubly linked list is simply a linked list in which nodes also contain a reference to the previous node.

class QueueLinkedList<T>: Queue {
    private var list = DoublyLinkedList<T>()
    init() {}
    
    // To add an element to the back of the queue, simply add the following:
    func enqueue(_ element: T) -> Bool {
        list.append(element)
        return true
    }
    
    // To remove an element from the queue, add the following:
    func dequeue() -> T? {
        guard !list.isEmpty, let element = list.first else {
            return nil
        }
        return list.remove(element)
    }
    
    // Similar to the array implementation, you can implement peek and isEmpty using the properties of the DoublyLinkedList. Add the following:
    var peek: T? {
        list.first?.value
    }
    
    var isEmpty: Bool {
        list.isEmpty
    }
}

// This implementation is similar to QueueArray, but instead of an array, you create a DoublyLinkedList.
// Behind the scenes, the doubly linked list will update its tail node’s previous and next references to the new node. This is an O(1) operation.

extension QueueLinkedList: CustomStringConvertible {
    var description: String {
        String(describing: list)
    }
}


example(of: "Queue Linked List") {
    var queue = QueueLinkedList<String>()
    queue.enqueue("Ray")
    queue.enqueue("Brian")
    queue.enqueue("Eric")
    
    print("Added names in queue")
    print(queue)
    print("Dequeue name in queue")
    queue.dequeue()
    print(queue)
    print("Peek")
    print(queue.peek)
}

// Let’s summarize the algorithmic and storage complexity of the doubly linked-list-based queue implementation

// |     Operations    | Average case | Worst case |
// |___________________|______________|____________|
// |     enqueue       |    O(1)      |     O(1)   |
// |___________________|______________|____________|
// |     enqueue       |    O(1)      |     O(1)   |
// |___________________|___________________________|
// |  Space complexity |    O(n)      |     O(n)   |
// |___________________|______________|____________|

// One of the main problems with QueueArray is that dequeuing an item takes linear time. With the linked list implementation, you reduced it to a constant operation, O(1).
// All you needed to do was update the node’s previous and next pointers.
// The main weakness with QueueLinkedList is not apparent from the table. Despite O(1) performance, it suffers from high overhead. Each element has to have extra storage for the forward and back reference. Moreover, every time you create a new element, it requires a relatively expensive dynamic allocation. By contrast QueueArray does bulk allocation, which is faster.

//======================== Ring buffer implementation

// A ring buffer, also known as a circular buffer, is a fixed-size array.
// This data structure strategically wraps around to the beginning when there are no more items to remove at the end.
// Going over a simple example of how a queue can be implemented using a ring buffer.
// You first create a ring buffer that has a fixed size. The ring buffer has two pointers that keep track of two things:
// - The read pointer keeps track of the front of the queue.
// - The write pointer keeps track of the next available slot so that you can override existing elements that have already been read.

// implement the RingBuffer class


struct RingBuffer<T> {
    private var array: [T?]
    private var readIndex = 0
    private var writeIndex = 0
    
    init(count: Int) {
        array = Array<T?>(repeating: nil, count: count)
    }
    
    var first: T? {
        array[readIndex]
    }
    
    mutating func write(_ element: T) -> Bool {
        if !isFull {
            array[writeIndex % array.count] = element
            writeIndex += 1
            return true
        } else {
            return false
        }
    }
    
    mutating func read() -> T? {
        if !isEmpty {
            let element = array[readIndex % array.count]
            readIndex += 1
            return element
        } else {
            return nil
        }
    }
    
    private var availableSpaceForReading: Int {
        writeIndex - readIndex
    }
    
    var isEmpty: Bool {
        availableSpaceForReading == 0
    }
    
    private var availableSpaceForWriting: Int {
        array.count - availableSpaceForReading
    }
    
    var isFull: Bool {
        availableSpaceForWriting == 0
    }
}

extension RingBuffer: CustomStringConvertible {
    var description: String {
        let values = (0..<availableSpaceForReading).map {
            String(describing: array[($0 + readIndex) % array.count]!)
        }
        return "[" + values.joined(separator: ", ") + "]"
    }
}

struct QueueRingBuffer<T>: Queue {
    private var ringBuffer: RingBuffer<T>
    
    // you defined a generic QueueRingBuffer. Note that you must include a count parameter since the ring buffer has a fixed size.
    init(count: Int) {
        ringBuffer = RingBuffer<T>(count: count)
    }
    
    var isEmpty: Bool {
        ringBuffer.isEmpty
    }
    
    var peek: T? {
        ringBuffer.first
    }
    
    // To append an element to the queue, you simply call write(_:) on the ringBuffer. This increments the write pointer by one.
    mutating func enqueue(_ element: T) -> Bool {
        ringBuffer.write(element)
    }
    
    // To remove an item from the front of the queue, you simply call read() on the ringBuffer. Behind the scenes, it checks if the ringBuffer is empty and, if so, returns nil. If not, it returns an item from the front of the buffer and increments the read pointer by one.
    mutating func dequeue() -> T? {
        ringBuffer.read()
    }
}

extension QueueRingBuffer: CustomStringConvertible {
    public var description: String {
        String(describing: ringBuffer)
    }
}

example(of: "Ring Buffer List") {
    var queue = QueueRingBuffer<String>(count: 10)
    queue.enqueue("Ray")
    queue.enqueue("Brian")
    queue.enqueue("Eric")
    
    print("Added names in queue")
    print(queue)
    print("Dequeue name in queue")
    queue.dequeue()
    print(queue)
    print("Peek")
    print(queue.peek)
}

// How does the ring-buffer implementation compare with the other queues? Let’s look at a summary of the algorithmic and storage complexity.

// |     Operations    | Average case | Worst case |
// |___________________|______________|____________|
// |     enqueue       |    O(1)      |     O(1)   |
// |___________________|______________|____________|
// |     enqueue       |    O(1)      |     O(1)   |
// |___________________|___________________________|
// |  Space complexity |    O(n)      |     O(n)   |
// |___________________|______________|____________|

// The ring-buffer-based queue has the same time complexity for enqueue and dequeue as the linked-list implementation.
// The only difference is the space complexity. The ring buffer has a fixed size, which means that enqueue can fail.

// So far, you have seen three implementations: a simple array, a doubly linked-list and a ring-buffer.
// Although they appear to be eminently useful, you’ll next look at a queue implemented using two stacks. You will see how its spacial locality is far superior to the linked list. It also doesn’t need a fixed size like a ring buffer.


//========================== Double-stack implementation
// The idea behind using two stacks is simple.
// Whenever you enqueue an element, it goes in the right stack.
// When you need to dequeue an element, you reverse the right stack and place it in the left stack so that you can retrieve the elements using FIFO order.
struct QueueStack<T>: Queue {
    private var leftStack: [T] = []
    private var rightStack: [T] = []
    
    init() {}
    
    // To check if the queue is empty, simply check that both the left and right stack are empty.
    // This means that there are no elements left to dequeue and no new elements have been enqueued.
    var isEmpty: Bool {
        leftStack.isEmpty && rightStack.isEmpty
    }
    
    // You know that peeking looks at the top element.
    // If the left stack is not empty, the element on top of this stack is at the front of the queue.
    // If the left stack is empty, the right stack will be reversed and placed in the left stack.
    // In this case, the element at the bottom of the right stack is next in the queue.
    // Note that the two properties isEmpty and peek are still O(1) operations.
    var peek: T? {
        !leftStack.isEmpty ? leftStack.last : rightStack.first
    }

    // Recall that the right stack is used to enqueue elements.
    // You simply push to the stack by appending to the array.
    // Previously, from implementing the QueueArray, you know that appending an element is an O(1) operation.
    mutating func enqueue(_ element: T) -> Bool {
        rightStack.append(element)
        return true
    }
    
    // Removing an item from a two-stack-based implementation of a queue is tricky.
    mutating func dequeue() -> T? {
        if leftStack.isEmpty { // 1 - Check to see if the left stack is empty.
            leftStack = rightStack.reversed() // 2 - If the left stack is empty, set it as the reverse of the right stack.
            rightStack.removeAll() // 3 - Invalidate your right stack. Since you have transferred everything to the left, just clear it.
        }
        return leftStack.popLast() // 4 - Remove the last element from the left stack.
    }
    
    // NOTE: Yes, reversing the contents of an array is an O(n) operation. The overall dequeue cost is still amortized O(1). Imagine having a large number of items in both the left and right stack. If you dequeue all of the elements, first it will remove all of the elements from the left stack, then reverse-copy the right stack only once, and then continue removing elements off the left stack.
}

extension QueueStack: CustomStringConvertible {
    var description: String {
        String(describing: leftStack.reversed() + rightStack)
    }
}

example(of: "Queue Stacks") {
    var queue = QueueStack<String>()
    queue.enqueue("Ray")
    queue.enqueue("Brian")
    queue.enqueue("Eric")
    
    print("Added names in queue")
    print(queue)
    print("Dequeue name in queue")
    queue.dequeue()
    print(queue)
    print("Peek")
    print(queue.peek)
}

// Let’s look at a summary of the algorithmic and storage complexity of your two-stack-based implementation.
// |     Operations    | Average case | Worst case |
// |___________________|______________|____________|
// |     enqueue       |    O(1)      |     O(n)   |
// |___________________|______________|____________|
// |     enqueue       |    O(1)      |     O(n)   |
// |___________________|___________________________|
// |  Space complexity |    O(n)      |     O(n)   |
// |___________________|______________|____________|

// Compared to the array-based implementation, by leveraging two stacks, you were able to transform dequeue(_:) into an amortized O(1) operation.
// Moreover, your two-stack implementation is fully dynamic and doesn’t have the fixed size restriction that your ring-buffer-based queue implementation has. Worst case performance is O(n) when the right queue needs to be reversed or runs out of capacity. Running out of capacity doesn’t happen very often thanks to the fact that Swift doubles it every time it happens.

// Finally, it beats the linked list in terms of spacial locality. This is because array elements are next to each other in memory blocks. So a large number of elements will be loaded in a cache on first access. Even though arrays require O(n), for simple copy operations it is a very fast O(n) happening close to memory bandwidth.

// Key points
// - Queue takes a FIFO strategy, an element added first must also be removed first.
// - Enqueue inserts an element to the back of the queue.
// - Dequeue removes the element at the front of the queue.
// - Elements in an array are laid out in contiguous memory blocks, whereas elements in a linked list are more scattered with potential for cache misses.
// - Ring-buffer-queue based implementation is good for queues with a fixed size.
// - Compared to other data structures, leveraging two stacks improves the dequeue(_:) time complexity to amortized O(1) operation.
// - Double-stack implementation beats out Linked-list in terms of spacial locality.


// ============== Stack vs. Queue

// Queues have a behavior of first-in-first-out. What comes in first must come out first. Items in the queue are inserted from the rear, and removed from the front.
// Queue Examples:
// - Line in a movie theatre: You would hate for people to cut the line at the movie theatre when buying tickets!
// - Printer: Multiple people could print documents from a printer, in a similar first-come-first-serve manner.

// Stacks have a behavior of last-in-first-out. Items on the stack are inserted at the top, and removed from the top.
// Stack Examples:
// - Stack of plates: Placing plates on top of each other, and removing the top plate every time you use a plate. Isn’t this easier than grabbing the one at the bottom?
// - Undo functionality: Imagine typing words on a keyboard. Clicking Ctrl-Z will undo the most recent text you typed.

// =================== Whose turn is it?
// Imagine that you are playing a game of Monopoly with your friends.
// The problem is that everyone always forget whose turn it is!
// Create a Monopoly organizer that always tells you whose turn it is. Below is a protocol that you can conform to:

protocol BoardGameManager {

  associatedtype Player
  mutating func nextPlayer() -> Player?
}

// Creating a board game manager is straightforward.
// All you care about is whose turn it is.
// A queue data structure is the perfect choice to adopt the BoardGameManager protocol!

extension QueueArray: BoardGameManager {
    // There are two requirements to adopt this protocol. You first set the typealias equal to the parameter type T.
    typealias Player = T
    
    mutating func nextPlayer() -> T? {
        guard let person = dequeue() else { // 1 - Get the next player by calling dequeue. If the queue is empty, simply return nil.
            return nil
        }
        enqueue(person) // 2 - enqueue the same person, this puts the player at the end of the queue.
        return person // 3 - Return the next player.
    }
}

example(of: "Who's turn is it?") {
    var queue = QueueArray<String>()
    queue.enqueue("Vincent")
    queue.enqueue("Remel")
    queue.enqueue("Lukiih")
    queue.enqueue("Allison")
    print(queue)

    print("===== boardgame =======")
    queue.nextPlayer()
    print(queue)
    queue.nextPlayer()
    print(queue)
    queue.nextPlayer()
    print(queue)
    queue.nextPlayer()
    print(queue)
}

// ================= Reverse queue
// A queue uses first-in-first-out whereas a stack uses last-in-first-out.
// You can use a stack to help reverse the contents of a queue. By inserting all the contents of the queue into a stack you basically reverse the order once you pop every single element off the stack!
struct Stack<Element> {
    private var storage: [Element] = []
    
    init() { }
    
    init(_ elements: [Element]) {
        storage = elements
    }
    
    mutating func push(_ element: Element) {
        storage.append(element)
    }
    
    @discardableResult
    mutating func pop() -> Element? {
        storage.popLast()
    }
    
    func peek() -> Element? {
        storage.last
    }
    
    var isEmpty: Bool {
        peek() == nil
    }
}

extension Stack: CustomStringConvertible {
  public var description: String {
    let topDivider = "----top----\n"
    let bottomDivider = "\n-----------"
    
    let stackElements = storage
      .map { "\($0)" }
      .reversed()
      .joined(separator: "\n")
    return topDivider + stackElements + bottomDivider
  }
}

extension Stack: ExpressibleByArrayLiteral {
    public init(arrayLiteral elements: Element...) {
        storage = elements
    }
}

// For this solution you extended QueueArray by added a reversed function.
extension QueueArray {
    func reversed() -> QueueArray {
        var queue = self // 1 - Create a copy of the queue.
        var stack = Stack<T>() // 2 - Create a stack.
        while let element = queue.dequeue() { // 3 - dequeue all the elements in the queue onto the stack.
            stack.push(element)
        }
        while let element = stack.pop() { // 4 - pop all the elements off the stack and insert them into the queue.
            queue.enqueue(element)
        }
        return queue // 5 - Return your reversed queue!
    }
    // The time complexity is overall O(n). You loop through the elements twice.
    // - Once for removing the elements off the queue, and
    // - once for removing the elements off the stack.
}

example(of: "Reverse Queue") {
    var queue = QueueArray<String>()
    queue.enqueue("1")
    queue.enqueue("21")
    queue.enqueue("18")
    queue.enqueue("42")

    print("before: \(queue)")
    print("after: \(queue.reversed())")
}
