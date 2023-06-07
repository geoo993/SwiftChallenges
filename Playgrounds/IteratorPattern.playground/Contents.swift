import Foundation

func example(of description: String, action: () -> Void) {
  print("\n--- Example of:", description, "---")
  action()
}

//The iterator pattern is a behavioral pattern that provides a standard way to loop through a collection.
// This pattern involves two types:

// 1) The Swift IteratorProtocol defines a type that can be iterated using a for in loop.
// 2) The iterator object is the type you want to make iterable. Instead of conforming to IteratorProtocol directly, however, you can conform to Sequence, which itself conforms to IteratorProtocol. By doing so, you’ll get many higher-order functions, including map, filter and more, for free.

// What does “for free” mean? It means these useful built-in functions can be used on any object that conforms to Sequence, which can save you from writing your own sorting, splitting and comparing algorithms.

// MARK: - When should you use it?
// - Use the iterator pattern when you have a type that holds onto a group of objects, and you want to make them iterable using a standard for in syntax.

// MARK: - Queue iterator

// lets create a queue containing an array.
// 1 - We define that Queue will contain an array of any type.
struct Queue<T> {
    private var array: [T?] = []
    
    // 2 - The head of the queue will be the index of the first element in the array.
    private var head = 0
    
    // 3 - There is an isEmpty bool to check if the queue is empty or not.
    var isEmpty: Bool {
        count == 0
    }
    
    // 4 - We give the Queue a count.
    var count: Int {
        array.count - head
    }
    
    // 5 - We create an enqueue function for adding elements to the queue.
    mutating func enqueue(_ element: T) {
        array.append(element)
    }
    
    // 6 - The dequeue function is for removing the first element of the queue.
    // This function’s logic is set up to help keep you from having nil objects in your array.
    mutating func dequeue() -> T? {
        guard head < array.count,
              let element = array[head] else {
            return nil
        }
        
        array[head] = nil
        head += 1
        
        let percentage = Double(head)/Double(array.count)
        if array.count > 50,
           percentage > 0.25 {
            array.removeFirst(head)
            head = 0
        }
        
        return element
    }
}

struct Ticket {
    var description: String
    var priority: PriorityType
    
    enum PriorityType {
        case low
        case medium
        case high
    }
    
    init(description: String, priority: PriorityType) {
        self.description = description
        self.priority = priority
    }
}

extension Ticket {
    // Before we use a sequence-specific sort function, we need this.
    // Assigning numeric values to the priority levels will make sorting easier.
    // Sorting the tickets using their sortIndex as reference.
    var sortIndex : Int {
        switch self.priority {
        case .low:
            return 0
        case .medium:
            return 1
        case .high:
            return 2
        }
    }
}


// In a real use-case scenario, we will definitely want to be able to sort these tickets by priority.
// With the way things are now, we would need to write a sorting function with a lot of if statements.
// To save ourself some time and instead use one of Swift’s built-in sorting functions.

// We need to make your Queue struct conform to the Sequence protocol.
extension Queue: Sequence {
    
    // There are two required parts when conforming the Sequence protocol.
    // - The first is the associated type, which is the Iterator. In this code bellow, IndexingIterator is the associated type, which is the default iterator for any collection that doesn’t declare its own.
    // - The second part is the Iterator protocol, which is the required makeIterator function. It constructs an iterator for the class or struct
    func makeIterator() -> IndexingIterator<ArraySlice<T?>> {
        let nonEmptyValues = array[head ..< array.count]
        return nonEmptyValues.makeIterator()
    }
}

example(of: "Iterator using Queue") {
    // Here, the queue has four items, which becomes three once you’ve successfully dequeued the first ticket.
    var queue = Queue<Ticket>()
    queue.enqueue(Ticket(
      description: "Wireframe Tinder for dogs app",
      priority: .low)
    )
    queue.enqueue(Ticket(
      description: "Set up 4k monitor for Josh",
      priority: .medium)
    )
    queue.enqueue(Ticket(
      description: "There is smoke coming out of my laptop",
      priority: .high)
    )
    queue.enqueue(Ticket(
      description: "Put googly eyes on the Roomba",
      priority: .low)
    )
    queue.dequeue()
    
    // This iterates through your tickets and prints them.
    print("List of Tickets in queue:")
    for ticket in queue {
        print(ticket?.description ?? "No Description")
    }
    
    let sortedTickets = queue.sorted {
      $0!.sortIndex > ($1?.sortIndex)!
    }
    var sortedQueue = Queue<Ticket>()
    for ticket in sortedTickets {
        // The sorting function returns a regular array, so to have a sorted queue, you enqueue each array item into a new queue.
        // The ability to sort through groups so easily is a powerful feature, and becomes more valuable as your lists and queues get larger.
        sortedQueue.enqueue(ticket!)
    }

    print("\n")
    print("Tickets sorted by priority:")
    for ticket in sortedQueue {
        print("\(ticket?.sortIndex):", ticket?.description ?? "No Description")
    }
}


// MARK: - What should you be careful about?
// - There is a protocol named IteratorProtocol, which allows you to customize how your object is iterated. You simply implement a next() method that returns the next object in the iteration. However, you’ll probably never need to conform to IteratorProtocol directly.
// - Even if you need a custom iterator, it’s almost always better to conform to Sequence and provide custom next() logic, instead of conforming to IteratorProtocol directly.
// - You can find more information about IteratorProtocol and how it works with Sequence at http://bit.ly/iterator-protocol.

// MARK: - Here are its key points:
// - The iterator pattern provides a standard way to loop through a collection using a for in syntax.
// - It’s better to make your custom objects conform to Sequence, instead of IteratorProtocol directly.
// - By conforming to Sequence, you will get higher-order functions like map and filter for free.
