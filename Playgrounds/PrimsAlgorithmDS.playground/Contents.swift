import Foundation

func example(of description: String, action: () -> Void) {
  print("\n--- Example of:", description, "---")
  action()
}

// depth-first and breadth-first search algorithms form spanning trees.
// A spanning tree is a subgraph of an undirected graph, containing all of the graph’s vertices, connected with the fewest number of edges.
// A spanning tree cannot contain a cycle and cannot be disconnected.


// From this undirected graph that forms a triangle, you can generate three different spanning trees in which you require only two edges to connect all vertices.
// Here, we will look at Prim’s algorithm, a greedy algorithm used to construct a minimum spanning tree.
// A greedy algorithm constructs a solution step-by-step and picks the most optimal path at every step.

// A minimum spanning tree is a spanning tree that minimizes the total weight of the edges chosen. For example, you might want to find the cheapest way to lay out a network of water pipes.

// Here’s an example of a minimum spanning tree for a weighted undirected graph:
//      Graph G
//
//   "**A**"--------|8
//    |             |
//   1|         "**C**"
//    |             |
//    |        2    |
//   "**B**"---------
//
//                8
//   "**A**"-----------------"**C**"     "**C**"
//    |                                    |       total=3 ==> minimum spanning tree
//    |  total=9                           |2
//    |                                    |         1
//    |                                  "**B**"-----------"**A**"
//   1|                    8
//    |         "**A**"--------"**C**"
//    |                          |
//    |                          |
//    |                          |2     total=10
//    |                          |
//    |                          |
//   "**B**"                  "**B**"
//
// Notice that only the third subgraph forms a minimum spanning tree, since it has the minimum total cost of 3.
// Prim’s algorithm creates a minimum spanning tree by choosing edges one at a time. It’s greedy because, every time you pick an edge, you pick the smallest weighted edge that connects a pair of vertices.

// There are six steps to finding a minimum spanning tree with Prim’s algorithm:
// 1- Given a network.
// 2- Pick any vertex.
// 3- Choose the shortest weighted edge from this vertex.
// 4- Choose the nearest vertex thats not in the solution.
// 5- If the next nearest vertex has two edges with the same weight, pick any one.
// 6- Repeat step 1 - 5 till you have visited all vertices, forming a minimum spanning tree.

//== Implementation
// we will use an adjacency list graph and a priority queue to implement Prim’s algorithm.
// The priority queue is used to store the edges of the explored vertices.
// It’s a min-priority queue so that, every time you dequeue an edge, it gives you the edge with the smallest weight.
protocol Queue {
    associatedtype Element
    mutating func enqueue(_ element: Element) -> Bool
    mutating func dequeue() -> Element?
    var isEmpty: Bool { get }
    var peek: Element? { get }
}

struct Heap<Element: Hashable> {
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
    
    var isEmpty: Bool { elements.isEmpty }
    var count: Int { elements.count }
    func peek() -> Element? { elements.first }
    
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
}

struct PriorityQueue<Element: Hashable>: Queue {
    private var heap: Heap<Element>
    
    init(
        sort: @escaping (Element, Element) -> Bool,
        elements: [Element] = []
    ) {
        heap = Heap(sort: sort, elements: elements)
    }

    var isEmpty: Bool { heap.isEmpty }
    
    var peek: Element? { heap.peek() }
    
    mutating func enqueue(_ element: Element) -> Bool {
        heap.insert(element)
        return true
    }
    
    mutating func dequeue() -> Element? {
        heap.remove()
    }
}

enum EdgeType {
    case directed
    case undirected
}

struct Vertex<T: Comparable> {
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

struct Edge<T: Comparable> {
    let source: Vertex<T>
    let destination: Vertex<T>
    let weight: Double?
}

extension Edge: Hashable where T: Hashable {}
extension Edge: Equatable where T: Equatable {}

extension Edge: CustomStringConvertible {
    var description: String {
        "source: \(source) and destination \(destination) ---> \(weight)"
    }
}

protocol Graph {
    associatedtype Element: Hashable & Comparable
    var vertices: [Vertex<Element>] { get }
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

final class AdjacencyList<T: Hashable & Comparable>: Graph {
    var vertices: [Vertex<T>] {
        adjacencies.keys.map { $0 }
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

// Prims
final class Prim<T: Hashable & Comparable> {
    // Graph is defined as a type alias for AdjacencyList. In the future, you could replace this with an adjacency matrix, if needed.
    typealias Graph = AdjacencyList<T>
    let shouldPrioritizeAlphabetically: Bool

    init(shouldPrioritizeAlphabetically: Bool = false) {
        self.shouldPrioritizeAlphabetically = shouldPrioritizeAlphabetically
    }
}

extension AdjacencyList {
    // To create a minimum spanning tree, you must include all vertices from the original graph.
    // This copies all of a graph’s vertices into a new graph.
    func copyVertices(from graph: AdjacencyList) {
        for vertex in graph.vertices {
            adjacencies[vertex] = []
        }
    }
}

// Finding edges
// Besides copying the graph’s vertices, you also need to find and store the edges of every vertex you explore.
extension Prim {
    //This method takes in four parameters:
    // - The current vertex.
    // - The graph, wherein the current vertex is stored.
    // - The vertices that have already been visited.
    // - The priority queue to add all potential edges.
    func addAvailableEdges(
        for vertex: Vertex<T>,
        in graph: Graph,
        check visited: Set<Vertex<T>>,
        to priorityQueue: inout PriorityQueue<Edge<T>>
    ) {
        for edge in graph.edges(from: vertex) { // 1 - Look at every edge adjacent to the current vertex.
            if !visited.contains(edge.destination) { // 2 - Check to see if the destination vertex has already been visited.
                priorityQueue.enqueue(edge) // 3 - If it has not been visited, you add the edge to the priority queue.
            }
        }
    }
    
    // 1 - produceMinimumSpanningTree takes an undirected graph and returns a minimum spanning tree and its cost.
    func produceMinimumSpanningTree(for graph: Graph) -> (cost: Double, mst: Graph) {
        var cost = 0.0 // 2 - cost keeps track of the total weight of the edges in the minimum spanning tree.
        let mst = Graph() // 3 - This is a graph that will become your minimum spanning tree.
        var visited: Set<Vertex<T>> = [] // 4 - visited stores all vertices that have already been visited.
        var priorityQueue = PriorityQueue<Edge<T>>(sort: { // 5 - This is a min-priority queue to store edges.
            let firstWeight = $0.weight ?? 0.0
            let secondWeight = $1.weight ?? 0.0
            guard
                self.shouldPrioritizeAlphabetically,
                !firstWeight.isZero,
                !secondWeight.isZero,
                secondWeight == firstWeight
            else {
                return firstWeight < secondWeight
            }
            return $0.source.data < $1.source.data
        })
        mst.copyVertices(from: graph) // 6 - Copy all the vertices from the original graph to the minimum spanning tree.
        
        guard let start = graph.vertices.first else { // 7 - Get the starting vertex from the graph.
            return (cost: cost, mst: mst)
        }

        visited.insert(start) // 8 - Mark the starting vertex as visited.
        addAvailableEdges(
            for: start, // 9 - Add all potential edges from the start vertex into the priority queue
            in: graph,
            check: visited,
            to: &priorityQueue
        )
        
        // 10 - Continue Prim’s algorithm until the queue of edges is empty.
        while let smallestEdge = priorityQueue.dequeue() {
            let vertex = smallestEdge.destination // 2 - Get the destination vertex.
            guard !visited.contains(vertex) else { // 3 - If this vertex has been visited, restart the loop and get the next smallest edge.
                continue
            }
            
            visited.insert(vertex) // 4 - Mark the destination vertex as visited.
            cost += smallestEdge.weight ?? 0.0 // 5 - Add the edge’s weight to the total cost.
            
            mst.add(
                .undirected, // 6 - Add the smallest edge into the minimum spanning tree you are constructing.
                from: smallestEdge.source,
                to: smallestEdge.destination,
                weight: smallestEdge.weight
            )
            
            addAvailableEdges(
                for: vertex, // 7 - Add the available edges from the current vertex.
                in: graph,
                check: visited,
                to: &priorityQueue
            )
        }
        
        return (cost: cost, mst: mst) // 8 - Once the priorityQueue is empty, return the minimum cost, and minimum spanning tree.
    }
}

// Test the tree
//                    6
//   "**D**"------------------"**E**"-------
//    |    |           __________|          |5
//    |    |5          |      1             |
//    |    |           |                    |
//    |    --------"**A**"---------------"**F**"
//    |             |  |         5          |
//    |       6     |  |                    |
//    |    |--------   |                    |
//    |    |           |                    |
//   3|    |          4|                    |
//    |    |           |                    |
//    |    |     6     |             2      |
//    "**C**"--------"**B**"----------------
//

example(of: "Prim's algorith for minimum spanning tree") {
    var graph = AdjacencyList<String>()
    let a = graph.createVertex(data: "A")
    let b = graph.createVertex(data: "B")
    let c = graph.createVertex(data: "C")
    let d = graph.createVertex(data: "D")
    let e = graph.createVertex(data: "E")
    let f = graph.createVertex(data: "F")

    graph.add(.undirected, from: a, to: c, weight: 6)
    graph.add(.undirected, from: a, to: e, weight: 1)
    graph.add(.undirected, from: a, to: f, weight: 5)
    graph.add(.undirected, from: a, to: d, weight: 5)
    graph.add(.undirected, from: a, to: b, weight: 4)
    graph.add(.undirected, from: c, to: d, weight: 3)
    graph.add(.undirected, from: d, to: e, weight: 6)
    graph.add(.undirected, from: e, to: f, weight: 5)
    graph.add(.undirected, from: f, to: b, weight: 2)
    graph.add(.undirected, from: b, to: c, weight: 6)

    print(graph)

    let (cost,mst) = Prim().produceMinimumSpanningTree(for: graph)
    print("cost: \(cost)")
    print("mst:")
    print(mst)
}

// Performance
// In the algorithm above, you maintain three data structures:
// 1- An adjacency list graph to build a minimum spanning tree. Adding vertices and edges to an adjacency list is O(1) .
// 2- A Set to store all vertices you have visited. Adding a vertex to the set and checking if the set contains a vertex also have a time complexity of O(1).
// 3- A min-priority queue to store edges as you explore more vertices. The priority queue is built on top of a heap and insertion takes O(log E).

// The worst-case time complexity of Prim’s algorithm is O(E log E).
// This is because, each time you dequeue the smallest edge from the priority queue, you have to traverse all the edges of the destination vertex ( O(E) ) and insert the edge into the priority queue ( O(logE) ).

// Key points
// - A spanning tree is a subgraph of an undirected graph that contains all the vertices with the fewest number of edges.
// - Prim’s algorithm is a greedy algorithm that constructs a minimum spanning tree.
// - You can leverage three different data structures: Priority queue, set, and adjacency lists to construct Prim’s algorithm.

// Challenge 1: Minimum spanning tree of points
// Given a set of points, construct a minimum spanning tree connecting all of the points into a graph.

extension CGPoint: Equatable {
    public static func == (lhs: CGPoint, rhs: CGPoint) -> Bool {
        lhs.x == rhs.x && lhs.y == rhs.y
    }
}

extension CGPoint: Hashable & Comparable {
    public static func < (lhs: CGPoint, rhs: CGPoint) -> Bool {
        lhs.x < rhs.x && lhs.y < rhs.y
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(x)
        hasher.combine(y)
    }
}

extension CGPoint {
    func distanceSquared(to point: CGPoint) -> CGFloat {
        let xDistance = (x - point.x)
        let yDistance = (y - point.y)
        return xDistance * xDistance + yDistance * yDistance
    }
    
    // Now that you’ve established a way to calculate the distance between two points, you have all the information you need to form a minimum spanning tree!
    func distance(to point: CGPoint) -> CGFloat {
        distanceSquared(to: point).squareRoot()
    }
}

// To leverage Prim’s algorithm you must form a complete graph with the given set of points. A complete graph is a undirected graph where all pair of vertices are connected by a unique edge.
extension Prim where T == CGPoint {
    func createCompleteGraph(with points: [CGPoint]) -> Graph {
        let completeGraph = Graph() // 1 - Create an empty new graph.
        points.forEach { point in // 2 - Go through each point and create a vertex.
            _ = completeGraph.createVertex(data: point)
        }
        
        // 3 - Loop through each vertex, and for every other vertex as long as the vertex is not the same.
        completeGraph.vertices.forEach { currentVertex in
            completeGraph.vertices.forEach { vertex in
                if currentVertex != vertex {
                    let distance = Double(currentVertex.data.distance(to: vertex.data)) // 4 - Calculate the distance between the two vertices.
                    completeGraph.addDirectedEdge(
                        from: currentVertex,
                        to: vertex,
                        weight: distance
                    ) // 5 - Add a directed edge between the two vertices.
                }
            }
        }
        
        return completeGraph // 6 - Return the complete graph
    }
    
    func produceMinimumSpanningTree(
        with points: [CGPoint]
    ) -> (cost: Double, mst: Graph) {
        let completeGraph = createCompleteGraph(with: points)
        return produceMinimumSpanningTree(for: completeGraph)
    }
}

example(of: "Minimum spanning tree of points") {
    var points: [CGPoint] = [
        .init(x: 3, y: 17),
        .init(x: 6, y: 16),
        .init(x: 5, y: 14),
        .init(x: 18, y: 7),
        .init(x: 4, y: 0),
        .init(x: 10, y: 1)
    ]
    let prim = Prim<CGPoint>()
    let (cost, mst) = prim.produceMinimumSpanningTree(with: points)
    print("cost: \(cost)")
    print("mst:")
    print(mst)
}

// Challenge 3: Step-by-step Diagram
// Given the graph below, step through Prim’s algorithm to produce a minimum spanning tree, and provide the total cost.
// Start at vertex B. If two edges share the same weight, prioritize them alphabetically.

example(of: "Prim's algorithm step by step minimum spanning tree") {
    var graph = AdjacencyList<String>()
    let a = graph.createVertex(data: "A")
    let b = graph.createVertex(data: "B")
    let c = graph.createVertex(data: "C")
    let d = graph.createVertex(data: "D")
    let e = graph.createVertex(data: "E")

    graph.add(.undirected, from: b, to: a, weight: 2)
    graph.add(.undirected, from: a, to: d, weight: nil)
    graph.add(.undirected, from: a, to: c, weight: nil)
    graph.add(.undirected, from: b, to: d, weight: 8)
    graph.add(.undirected, from: b, to: c, weight: 6)
    graph.add(.undirected, from: c, to: e, weight: nil)
    graph.add(.undirected, from: b, to: e, weight: 2)
    graph.add(.undirected, from: e, to: d, weight: nil)

    print(graph)

    let (cost,mst) = Prim(shouldPrioritizeAlphabetically: true)
        .produceMinimumSpanningTree(for: graph)
    print("cost: \(cost)")
    print("mst:")
    print(mst)
}
