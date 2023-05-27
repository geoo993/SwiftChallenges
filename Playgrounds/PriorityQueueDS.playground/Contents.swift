import Foundation

func example(of description: String, action: () -> Void) {
  print("\n--- Example of:", description, "---")
  action()
}

// Priority Queue

// Queues are simply lists that maintain the order of elements using first-in-first-out (FIFO) ordering.
// A priority queue is another version of a queue in which, instead of using FIFO ordering, elements are dequeued in priority order. For example, a priority queue can either be:
// - Max-priority, in which the element at the front is always the largest.
// - Min-priority, in which the element at the front is always the smallest.

// A priority queue is especially useful when you need to identify the maximum or minimum value given a list of elements.

// Applications
// Some useful applications of a priority queue include:
// - Dijkstra’s algorithm, which uses a priority queue to calculate the minimum cost.
// - A* pathfinding algorithm, which uses a priority queue to track the unexplored routes that will produce the path with the shortest length.
// - Heap sort, which can be implemented using a priority queue.
// - Huffman coding that builds a compression tree. A min-priority queue is used to repeatedly find two nodes with the smallest frequency that do not yet have a parent node.

// These are just some of the use cases, but priority queues have many more applications as well.
// A priority queue has the same operations as a normal queue, so only the implementation will differ.
protocol Queue {
    // The priority queue will conform to the Queue protocol and implement the common operations:
    // - enqueue: Inserts an element into the queue. Returns true if the operation was successful.
    // - dequeue: Removes the element with the highest priority and returns it. Returns nil if the queue was empty.
    // - isEmpty: Checks if the queue is empty.
    // - peek: Returns the element with the highest priority without removing it. Returns nil if the queue was empty.
    associatedtype Element
    mutating func enqueue(_ element: Element) -> Bool
    mutating func dequeue() -> Element?
    var isEmpty: Bool { get }
    var peek: Element? { get }
}


// Implementation
// You can create a priority queue in the following ways:
// 1- Sorted array: This is useful to obtain the maximum or minimum value of an element in O(1) time. However, insertion is slow and will require O(n) since you have to insert it in order.
// 2- Balanced binary search tree: This is useful in creating a double-ended priority queue, which features getting both the minimum and maximum value in O(log n) time. Insertion is better than a sorted array, also in O(log n).
// 3- Heap: This is a natural choice for a priority queue. A heap is more efficient than a sorted array because a heap only needs to be partially sorted. All heap operations are O(log n) except extracting the min value from a min priority heap is a lightning fast O(1). Likewise, extracting the max value from a max priority heap is also O(1).


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

// 1 - PriorityQueue will conform to the Queue protocol.
// The generic parameter Element must conform to Comparable as you need to be able to compare elements.
struct PriorityQueue<Element: Comparable>: Queue {
    private var heap: Heap<Element> // 2 - You will use this heap to implement the priority queue.
    
    // 3 - By passing an appropriate function into this initializer, PriorityQueue can be used to create both min and max priority queues.
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
    
    // The heap is a perfect candidate for a priority queue. You simply need to call various methods of a heap to implement the operations of a priority queue!
    // By calling enqueue(_:), you simply insert into the heap and the heap will sift up to validate itself. The overall complexity of enqueue(_:) is O(log n)
    mutating func enqueue(_ element: Element) -> Bool {
        heap.insert(element)
        return true
    }
    
    // By calling dequeue(_:), you remove the root element from the heap by replacing it with the last element in the heap and then sift down to validate the heap. The overall complexity of dequeue() is O(log n)
    mutating func dequeue() -> Element? {
        heap.remove()
    }
}

extension PriorityQueue: CustomStringConvertible {
    var description: String {
        diagram(for: self)
    }
    
    // diagram will recursively create a string representing the binary tree.
    private func diagram(for queue: PriorityQueue?) -> String {
        guard let queue = queue else {
            return "\(peek)nil\n"
        }
        return "\(queue.heap.elements)"
    }
}


example(of: "Priority queue - dequeue") {
    var priorityQueue = PriorityQueue(sort: >, elements: [1, 12, 3, 5, 4, 1, 6, 8, 7])
    while !priorityQueue.isEmpty {
        print(priorityQueue.dequeue()!, priorityQueue)
    }
}

// Key points
// - A priority queue is often used to find the element in priority order.
// - It creates a layer of abstraction by focusing on key operations of a queue and leaving out additional functionality provided by the heap data structure.
// - This makes the priority queue’s intent clear and concise. Its only job is to enqueue and dequeue elements, nothing else!
// - Composition for the win!


// Challenge 1: Array-based priority queue
// You have learned to use a heap to construct a priority queue by conforming to the Queue protocol. Now, construct a priority queue using an Array.
struct ArrayPriorityQueue<Element: Comparable>: Queue {
    private var elements: [Element]
    let sort: (Element, Element) -> Bool
    
    // The initializer takes a sort function, and an array of elements. Within the init method, you leverage the array’s sort function. Accord to Apple the sort function takes O(n log n) time.
    init(
        sort: @escaping (Element, Element) -> Bool,
        elements: [Element] = []
    ) {
        self.sort = sort
        self.elements = elements.sorted(by: sort)
    }

    var isEmpty: Bool {
        elements.isEmpty
    }
    
    var peek: Element? {
        elements.first
    }
    
    // To enqueue an element into an array-based priority queue do the following:
    mutating func enqueue(_ element: Element) -> Bool {
        for (index, otherElement) in elements.enumerated() { // 1 - For every element in the queue.
            if sort(element, otherElement) { // 2 - Check to see if the element you are adding has a higher priority.
                elements.insert(element, at: index) // 3 - If it does, insert it at the current index.
                return true
            }
        }
        elements.append(element) // 4 - If the element does not have a higher priority than any element in the queue, simply append the element to the end.
        return true
        // This has overall O(n) time complexity, since you have to go through every element to check the priority against the new element you are adding. Also if you are inserting in between elements in the array, you have to shift elements to the right by one.
    }
    
    mutating func dequeue() -> Element? {
        isEmpty ? nil : elements.removeFirst()
        // Here you simply check to see if the queue is empty before removing the first element from the array. This is an O(n) operation, since you have to shift the existing elements to the left by one.
    }
}

example(of: "Array Priority queue - dequeue") {
    var priorityQueue = ArrayPriorityQueue(sort: >, elements: [1,12,3,4,1,6,8,7])
    priorityQueue.enqueue(5)
    priorityQueue.enqueue(0)
    priorityQueue.enqueue(10)
    while !priorityQueue.isEmpty {
        print(priorityQueue.dequeue()!, priorityQueue)
    }
}

// Challenge 2: Prioritize a waitlist
// Your favorite T-Swift concert was sold out.
// Fortunately there is a waitlist for people who still want to go!
// However the ticket sales will first prioritize someone with a military background, followed by seniority.
// Write a sort function that will return the list of people on the waitlist by the priority mentioned.
// The Person struct is provided below:

struct Person {
    let name: String
    let age: Int
    let isMilitary: Bool
}

extension Person: Comparable, CustomStringConvertible {
    var description: String {
        isMilitary ? "\(name) - \(age) - veteran" : "\(name) - \(age)"
    }

    // Given a list of people on the waitlist, you would like to prioritize the people in the following order:
    // - Military background
    // - Seniority, by age
    static func <(lhs: Person, rhs: Person) -> Bool {
        if lhs.age < rhs.age && rhs.isMilitary {
            return true
        } else if rhs.isMilitary && !lhs.isMilitary {
            return true
        } else if lhs.age < rhs.age && !lhs.isMilitary {
            return true
        } else {
            return false
        }
    }
}

extension Array where Element == Person {
    func sorted() -> [Person] {
        return self.sorted(by: >)
    }
}

// option 2 - tswiftSort takes two people and checks to see if both of them have or don’t have a military background. If so, you check their age, if not, you give priority to whoever has a military background.
func tswiftSort(person1: Person, person2: Person) -> Bool {
    if person1.isMilitary == person2.isMilitary {
        return person1.age > person2.age
    }
    
    return person1.isMilitary
}

example(of: "Person sorted") {
    let waitlist: [Person] = [
        .init(name: "Dom", age: 43, isMilitary: true),
        .init(name: "Dalton", age: 24, isMilitary: false),
        .init(name: "Steve", age: 36, isMilitary: true),
        .init(name: "Amanda", age: 38, isMilitary: true),
        .init(name: "George", age: 56, isMilitary: true),
        .init(name: "Tom", age: 29, isMilitary: false),
        .init(name: "Sam", age: 42, isMilitary: false),
        .init(name: "Rodri", age: 62, isMilitary: true),
        .init(name: "Alex", age: 51, isMilitary: false)
    ]
    let result = waitlist.sorted()
    result.forEach { print($0) }
}

example(of: "Person sorted with tswiftSort") {
    let waitlist: [Person] = [
        .init(name: "Dom", age: 43, isMilitary: true),
        .init(name: "Dalton", age: 24, isMilitary: false),
        .init(name: "Steve", age: 36, isMilitary: true),
        .init(name: "Amanda", age: 38, isMilitary: true),
        .init(name: "George", age: 56, isMilitary: true),
        .init(name: "Tom", age: 29, isMilitary: false),
        .init(name: "Sam", age: 42, isMilitary: false),
        .init(name: "Rodri", age: 62, isMilitary: true),
        .init(name: "Alex", age: 51, isMilitary: false)
    ]

    var priorityQueue = PriorityQueue(sort: tswiftSort, elements: waitlist)
    while !priorityQueue.isEmpty {
        print(priorityQueue.dequeue()!)
    }
}

// Challenge 3: Minimize recharge stops
// Swift-la is a new electric car company that is looking to add a new feature into their vehicles.
// They want to add the ability for their customers to check if the car can reach a given destination.
// Since the journey to the destination may be far, there are charging stations that the car can recharge at.
// The company wants to find the minimum number of charging stops needed for the vehicle to reach its destination.

// The first is ChargingStation:
struct ChargingStation {
    /// Distance from start location.
    let distance: Int
    /// The amount of electricity the station has to charge a car.
    /// 1 capacity = 1 mile
    let chargeCapacity: Int
}

// The second is DestinationResult:
enum DestinationResult: CustomStringConvertible {
    /// Able to reach your destination with the minimum number of stops.
    case reachable(rechargeStops: Int)
    /// Unable to reach your destination.
    case unreachable
    
    var description: String {
        switch self {
        case let .reachable(rechargeStops):
            return "Reachable with \(rechargeStops) recharge stops"
        case .unreachable:
            return "Unreachable"
        }
    }
}

// DestinationResult describes whether it is possible for the vehicle to complete its journey.
// Lastly the question provides a minRechargeStops(_:) function with three parameters.
// - target: the distance in miles the vehicle needs to travel.
// - startCharge: the starting charge you have to start the journey.
// - stations: the ChargingStations along the way, sorted by distance.

// In order to find the minimum number of charging stations to stop at, one solution is to leverage a priority queue.

func minRechargeStops(
    target: Int,
    startCharge: Int,
    stations: [ChargingStation]
) -> DestinationResult {
    // 1 - If the starting charge of the electric vehicle is greater than or equal to the target destination, it is .reachable with zero stops.
    guard startCharge <= target else {
        return .reachable(rechargeStops: 0)
    }
    
    // 2 - minStops keeps track of the minimum number of stops needed to reach target.
    var minStops = -1
    
    // 3 - currentCharge keeps track of the vehicle’s current charge on the journey.
    var currentCharge = 0
    
    // 4 - currentStation tracks the number of stations passed.
    var currentStation = 0

    // 5 - chargePriority is a priority queue that holds all the reachable charging stations. It is responsible for providing the station with the highest charging capacity. The priority queue is also initialized with the vehicle’s startCharge.
    var chargePriority = PriorityQueue(sort: >, elements: [startCharge])
    
    // 1 - If the chargePriority queue is not empty, this means that there are reachable charging stations the car can charge at.
    while !chargePriority.isEmpty {
        // 2 - chargePriority queue removes the station with the highest charge capacity.
        guard let charge = chargePriority.dequeue() else {
            return .unreachable
        }
        // 3 - Charge the vehicle by adding the charge to currentCharge.
        currentCharge += charge

        // 4 - Every time you dequeue from the priority queue, you must increment minStops, since you’ve stopped at a station.
        minStops += 1
        
        // 5 - Check to see if the currentCharge can reach the target. If it can reach the target, simply return .reachable with the minimum stops.
        if currentCharge >= target {
            return .reachable(rechargeStops: minStops)
        }
        
        // 6 - Our current charge can’t reach our destination but we have not exhausted all charging stations, and the car’s currentCharge can reach the next currentStation.
        // Let’s add the station’s chargeCapacity to the chargePriority queue.
        while currentStation < stations.count
                && currentCharge >= stations[currentStation].distance {
            let distance = stations[currentStation].chargeCapacity
            _ = chargePriority.enqueue(distance)
            currentStation += 1
        }
    }

    // 7 - We are unable to reach the destination.
    return .unreachable
}

example(of: "Charging stations") {
    let stations = [
        ChargingStation(distance: 10, chargeCapacity: 60),
        ChargingStation(distance: 20, chargeCapacity: 30),
        ChargingStation(distance: 30, chargeCapacity: 30),
        ChargingStation(distance: 60, chargeCapacity: 40)
    ]
    print(minRechargeStops(target: 100, startCharge: 10, stations: stations))
}
