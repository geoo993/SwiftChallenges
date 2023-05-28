import Foundation

func example(of description: String, action: () -> Void) {
  print("\n--- Example of:", description, "---")
  action()
}

// We explored how graphs can be used to capture relationships between objects.
// Remember that objects are just VERTICES, and the relationships between them are represented by EDGES.

// Several algorithms exist to traverse or search through a graph’s vertices. One such algorithm is the breadth-first search (BFS) algorithm.
// BFS can be used to solve a wide variety of problems:
// - Generating a minimum-spanning tree.
// - Finding potential paths between vertices.
// - Finding the shortest path between two vertices.

// BFS starts off by selecting any vertex in a graph.
// The algorithm then explores all neighbors of this vertex before traversing the neighbors of said neighbors and so forth.
// As the name suggests, this algorithm takes a breadth-first approach.

protocol Queue {
    associatedtype Element
    mutating func enqueue(_ element: Element) -> Bool
    mutating func dequeue() -> Element?
    var isEmpty: Bool { get }
    var peek: Element? { get }
}

struct QueueStack<T> : Queue {
    private var leftStack: [T] = []
    private var rightStack: [T] = []
    init() {}
    
    var isEmpty: Bool {
        leftStack.isEmpty && rightStack.isEmpty
    }
    
    var peek: T? {
        !leftStack.isEmpty ? leftStack.last : rightStack.first
    }
    
    mutating func enqueue(_ element: T) -> Bool {
        rightStack.append(element)
        return true
    }
    
    mutating func dequeue() -> T? {
        if leftStack.isEmpty {
            leftStack = rightStack.reversed()
            rightStack.removeAll()
        }
        return leftStack.popLast()
    }
}

extension QueueStack: CustomStringConvertible {
    var description: String {
        let printList = leftStack.reversed() + rightStack
        return String(describing: printList)
    }
}

enum EdgeType {
    case directed
    case undirected
}

struct Vertex<T> {
    let index: Int
    let data: T
}

extension Vertex: Hashable where T: Hashable {}
extension Vertex: Equatable where T: Equatable {}

extension Vertex: CustomStringConvertible {
    var description: String {
        "\(index): \(data)"
    }
}

struct Edge<T> {
    let source: Vertex<T>
    let destination: Vertex<T>
    let weight: Double?
}

protocol Graph {
    associatedtype Element: Hashable
    var allVertices: Set<Vertex<Element>> { get }
    func createVertex(data: Element) -> Vertex<Element>
    func addDirectedEdge(from source: Vertex<Element>, to destination: Vertex<Element>, weight: Double?)
    func addUndirectedEdge(between source: Vertex<Element>, and destination: Vertex<Element>, weight: Double?)
    func add(_ edge: EdgeType, from source: Vertex<Element>, to destination: Vertex<Element>, weight: Double?)
    func edges(from source: Vertex<Element>) -> [Edge<Element>]
    func weight(from source: Vertex<Element>, to destination: Vertex<Element>) -> Double?
}

extension Graph {
    func addUndirectedEdge(between source: Vertex<Element>, and destination: Vertex<Element>, weight: Double?) {
        addDirectedEdge(from: source, to: destination, weight: weight)
        addDirectedEdge(from: destination, to: source, weight: weight)
    }
    
    func add(_ edge: EdgeType, from source: Vertex<Element>, to destination: Vertex<Element>, weight: Double?) {
        switch edge {
        case .directed:
            addDirectedEdge(from: source, to: destination, weight: weight)
        case .undirected:
            addUndirectedEdge(between: source, and: destination, weight: weight)
        }
    }
}

final class AdjacencyList<T: Hashable>: Graph {
    var allVertices: Set<Vertex<T>> {
        Set(adjacencies.keys)
    }
    
    private var adjacencies: [Vertex<T>: [Edge<T>]] = [:]
    
    init() {}
    
    func createVertex(data: T) -> Vertex<T> {
        let vertex = Vertex(index: adjacencies.count, data: data)
        adjacencies[vertex] = []
        return vertex
    }
    
    func addDirectedEdge(from source: Vertex<T>, to destination: Vertex<T>, weight: Double?) {
        let edge = Edge(source: source, destination: destination, weight: weight)
        adjacencies[source]?.append(edge)
    }
    
    func edges(from source: Vertex<T>) -> [Edge<T>] {
        adjacencies[source] ?? []
    }
    
    func weight(from source: Vertex<T>, to destination: Vertex<T>) -> Double? {
        edges(from: source).first { $0.destination == destination }?.weight
    }
}

extension AdjacencyList: CustomStringConvertible {
    var description: String {
        var result = ""
        for (vertex, edges) in adjacencies {
            var edgeString = ""
            for (index, edge) in edges.enumerated() {
                if index != edges.count - 1 {
                    edgeString.append("\(edge.destination), ")
                } else {
                    edgeString.append("\(edge.destination)")
                }
            }
            result.append("\(vertex) ---> [ \(edgeString) ]\n")
        }
        return result
    }
}


// You will use a queue to keep track of which vertices to visit next.
// The first-in-first-out approach of the queue guarantees that all of a vertex’s neighbors are visited before you traverse one level deeper.

// Note: It’s important to note that you only add a vertex to the queue when it has not yet been visited and is not already in the queue.

// When exploring the vertices, you can construct a tree-like structure, showing the vertices at each level: first the vertex you started from, then its neighbors, then its neighbors’ neighbors and so on.

extension Graph where Element: Hashable {
    
    // This takes in a starting vertex.
    func breadthFirstSearch(from source: Vertex<Element>) -> [Vertex<Element>] {
        // queue keeps track of the neighboring vertices to visit next.
        var queue = QueueStack<Vertex<Element>>()
        
        // enqueued remembers which vertices have been enqueued before so you don’t enqueue the same vertex twice.
        // You use a Set type here so that lookup is cheap and only takes O(1).
        var enqueued: Set<Vertex<Element>> = []
        
        // visited is an array that stores the order in which the vertices were explored.
        var visited: [Vertex<Element>] = []
        
        queue.enqueue(source) // 1 - You initiate the BFS algorithm by first enqueuing the source vertex.
        enqueued.insert(source)
        
        var itemInQueue = 1
        
        while let vertex = queue.dequeue() { // 2 - You continue to dequeue a vertex from the queue until the queue is empty.
            itemInQueue -= 1
            visited.append(vertex) // 3 - Every time you dequeue a vertex from the queue, you add it to the list of visited vertices.
            let neighborEdges = edges(from: vertex) // 4 - Then, you find all edges that start from the current vertex and iterate over them.
            neighborEdges.forEach { edge in
                if !enqueued.contains(edge.destination) { // 5 - For each edge, you check to see if its destination vertex has been enqueued before, and, if not, you add it to the code.
                    queue.enqueue(edge.destination)
                    enqueued.insert(edge.destination)
                    itemInQueue += 1
                }
            }
            print("Max Items in Queue", itemInQueue)
        }
        // That’s all there is to implementing BFS
        return visited
    }
}

example(of: "Breadth-First letters search") {
    let graph = AdjacencyList<String>()
    let a = graph.createVertex(data: "A")
    let b = graph.createVertex(data: "B")
    let c = graph.createVertex(data: "C")
    let d = graph.createVertex(data: "D")
    let e = graph.createVertex(data: "E")
    let f = graph.createVertex(data: "F")
    let g = graph.createVertex(data: "G")
    let h = graph.createVertex(data: "H")

    graph.add(.undirected, from: a, to: b, weight: nil)
    graph.add(.undirected, from: a, to: c, weight: nil)
    graph.add(.undirected, from: a, to: d, weight: nil)
    graph.add(.undirected, from: b, to: g, weight: nil)
    graph.add(.undirected, from: c, to: f, weight: nil)
    graph.add(.undirected, from: c, to: g, weight: nil)
    graph.add(.undirected, from: e, to: h, weight: nil)
    graph.add(.undirected, from: e, to: f, weight: nil)
    graph.add(.undirected, from: f, to: e, weight: nil)

    // One thing to keep in mind with neighboring vertices is that the order in which you visit them is determined by how you construct your graph.
    // You could have added an edge between A and C before adding one between A and B. In this case, the output would list C before B.
    let vertices = graph.breadthFirstSearch(from: a)
    vertices.forEach { vertex in
        print(vertex)
    }
}

//== Performance
// When traversing a graph using BFS, each vertex is enqueued once.
// This has a time complexity of O(V). During this traversal, you also visit all the the edges.
// The time it takes to visit all edges is O(E).
// This means that the overall time complexity for breadth-first search is O(V + E).

// The space complexity of BFS is O(V), since you have to store the vertices in three separate structures: queue, enqueued and visited.

//== Key points
// - Breadth-first search (BFS) is an algorithm for traversing or searching a graph.
// - BFS explores all the current vertex’s neighbors before traversing the next level of vertices.
// - It’s generally good to use this algorithm when your graph structure has a lot of neighboring vertices or when you need to find out every possible outcome.
// - The queue data structure is used to prioritize traversing a vertex’s neighboring edges before diving down a level deeper.

// Challenge 1: Maximum queue size
// For the following undirected graph, list the maximum number of items ever in the queue.
// Assume that the starting vertex is A.



// Challenge 2: Iterative BFS
// In this chapter, you went over an iterative implementation of breadth-first search. Now write a recursive implementation.

extension Graph where Element: Hashable  {
    // Overall time complexity for breadth-first search is O(V + E).
    func bfs(from source: Vertex<Element>) -> [Vertex<Element>] {
        var queue = QueueStack<Vertex<Element>>() // 1 - queue keeps track of the neighboring vertices to visit next.
        var enqueued: Set<Vertex<Element>> = [] // 2 - enqueued remembers which vertices have been added to the queue. You can use a Set for O(1) lookup. An array is O(n).
        var visited: [Vertex<Element>] = [] // 3 - visited is an array that stores the order in which the vertices were explored.
        
        // 4 - Initiate the algorithm by inserting the source vertex.
        queue.enqueue(source)
        enqueued.insert(source)
        // 5 - Perform bfs recursively on the graph by calling a helper function.
        bfs(queue: &queue, enqueued: &enqueued, visited: &visited)
        // 6 - Return the vertices visited in order.
        return visited
    }
    
    private func bfs(
        queue: inout QueueStack<Vertex<Element>>,
        enqueued: inout Set<Vertex<Element>>,
        visited: inout [Vertex<Element>]
    ) {
        guard let vertex = queue.dequeue() else { // 1 - Base case, recursively continue to dequeue a vertex from the queue till it is empty.
            return
        }
        visited.append(vertex) // 2 - Mark the vertex as visited.
        let neighborEdges = edges(from: vertex) // 3 - For every neighboring edge from the current vertex.
        neighborEdges.forEach { edge in
            if !enqueued.contains(edge.destination) { // 4 - Check to see if the adjacent vertices have been visited before inserting into the queue.
                queue.enqueue(edge.destination)
                enqueued.insert(edge.destination)
            }
        }
        // 5 - Recursively perform bfs till the queue is empty.
        bfs(queue: &queue, enqueued: &enqueued, visited: &visited)
    }
}

example(of: "Breadth-First iterative search") {
    let graph = AdjacencyList<String>()
    let a = graph.createVertex(data: "A")
    let b = graph.createVertex(data: "B")
    let c = graph.createVertex(data: "C")
    let d = graph.createVertex(data: "D")
    let e = graph.createVertex(data: "E")
    let f = graph.createVertex(data: "F")
    let g = graph.createVertex(data: "G")
    let h = graph.createVertex(data: "H")

    graph.add(.undirected, from: a, to: b, weight: nil)
    graph.add(.undirected, from: a, to: c, weight: nil)
    graph.add(.undirected, from: a, to: d, weight: nil)
    graph.add(.undirected, from: b, to: g, weight: nil)
    graph.add(.undirected, from: c, to: f, weight: nil)
    graph.add(.undirected, from: c, to: g, weight: nil)
    graph.add(.undirected, from: e, to: h, weight: nil)
    graph.add(.undirected, from: e, to: f, weight: nil)
    graph.add(.undirected, from: f, to: e, weight: nil)

    let vertices = graph.bfs(from: a)
    vertices.forEach { vertex in
        print(vertex)
    }
}


// Challenge 3: Disconnected Graph
// Add a method to Graph to detect if a graph is disconnected. An example of a disconnected graph is shown below:

// A graph is said to be disconnected if no path exists between two nodes.
extension Graph where Element: Hashable {
    func isDisconnected() -> Bool {
        guard let firstVertex = allVertices.first else { // 1 - If there are no vertices, treat the graph as connected.
            return false
        }
        let visited = breadthFirstSearch(from: firstVertex) // 2 - Perform a breadth-first search starting from the first vertex. This will return all the visited nodes.
        for vertex in allVertices { // 3 - Go through every vertex in the graph and check to see if it has been visited before.
            if !visited.contains(vertex) {
                return true
            }
        }
        return false
    }
}

example(of: "Breadth-First search idsconnected graph") {
    let graph = AdjacencyList<String>()
    let a = graph.createVertex(data: "A")
    let b = graph.createVertex(data: "B")
    let c = graph.createVertex(data: "C")
    let d = graph.createVertex(data: "D")
    let e = graph.createVertex(data: "E")
    let f = graph.createVertex(data: "F")
    let g = graph.createVertex(data: "G")
    let h = graph.createVertex(data: "H")

    graph.add(.undirected, from: a, to: b, weight: nil)
    graph.add(.undirected, from: a, to: c, weight: nil)
    graph.add(.undirected, from: a, to: d, weight: nil)
    graph.add(.undirected, from: h, to: e, weight: nil)
    graph.add(.undirected, from: e, to: f, weight: nil)
    graph.add(.undirected, from: f, to: g, weight: nil)

    print("Is graph disconnected", graph.isDisconnected())
}
