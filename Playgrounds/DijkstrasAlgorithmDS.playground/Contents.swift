import Foundation

func example(of description: String, action: () -> Void) {
  print("\n--- Example of:", description, "---")
  action()
}

// Have you ever used the Google or Apple Maps app to find the shortest distance or fastest time from one place to another?
// Dijkstra’s algorithm is particularly useful in GPS networks to help find the shortest path between two places.

// Dijkstra’s algorithm is a greedy algorithm. A greedy algorithm constructs a solution step-by-step, and it picks the most optimal path at every step.
// In particular, Dijkstra’s algorithm finds the shortest paths between vertices in either directed or undirected graphs. Given a vertex in a graph, the algorithm will find all shortest paths from the starting vertex.

// Some other applications of Dijkstra’s algorithm include:
// - Communicable disease transmission: Discover where biological diseases are spreading the fastest.
// - Telephone networks: Routing calls to highest-bandwidth paths available in the network.
// - Mapping: Finding the shortest and fastest paths for travelers.

// Using directed graph! Imagine the directed graph below represents a GPS network:
//
//                                     8
//    "**G**"----------------->"**C**"<------
//    /\   /\         3            |        |
//    |    |1                      |       1|
//    |5   |                       |3      \/       2
//    |   "**A**"                  |     "**E**"---------->"**D**"
//    |    /\  |                   |        /\
//  "*H*"  |2  --------------------|        |1
//    |    |             8         |        |
//    |    |                       |        |
//   2|    |                       |        |
//    |   9|                       |        |
//    |    \/            3         \/     1 |
//    -->"**F**"<----------------"**B**"<----
//
// The vertices represent physical locations, and the edges between the vertices represent one way paths of a given cost between locations.
// In Dijkstra’s algorithm, you first choose a starting vertex, since the algorithm needs a starting point to find a path to the rest of the nodes in the graph.
// Assume the starting vertex you pick is vertex A.
// The output tells you the cost to get to D is 7. To find the path, you simply backtrack.
// From The previous vertex to the current vertex and if it is connected to. You should get from D to E to C to G and finally back to A.

// Implementation
// The priority queue is used to store vertices that have not been visited.
// It’s a min-priority queue so that, every time you dequeue a vertex, it gives you vertex with the current tentative shortest path.
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

extension Edge: CustomStringConvertible {
    var description: String {
        "source: \(source) and destination \(destination) ---> \(weight)"
    }
}

protocol Graph {
    associatedtype Element: Hashable
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

final class AdjacencyList<T: Hashable>: Graph {
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

// ==
enum Visit<T: Hashable> {
    case start // 1 - The vertex is the starting vertex.
    case edge(Edge<T>) // 2 - The vertex has an associated edge that leads to a path back to the starting vertex.
}

// Graph is defined as a type alias for AdjacencyList. You could in the future replace this with an adjacency matrix if needed.
final class Dijkstra<T: Hashable> {
    typealias Graph = AdjacencyList<T>
    let graph: Graph
    
    init(graph: Graph) {
        self.graph = graph
    }
    
    func shortestPath(
        to destination: Vertex<T>,
        paths: [Vertex<T> : Visit<T>]
    ) -> [Edge<T>] {
        return route(to: destination, with: paths)
    }
}

// Before building Dijkstra, let’s create some helper methods that will help create the algorithm.
// You need a mechanism to keep track of the total weight from the current vertex back to the start vertex.
// To do this, you will keep track of a dictionary named paths that stores a Visit state for every vertex.
extension Dijkstra {
    // This method takes in the destination vertex along with a dictionary of existing paths, and it constructs a path that leads to the destination vertex.
    private func route(
        to destination: Vertex<T>,
        with paths: [Vertex<T>: Visit<T>]
    ) -> [Edge<T>] {
        var vertex = destination // 1 - Start at the destination vertex.
        var path: [Edge<T>] = [] // 2 - Create an array of edges to store the path.
        
        // 3 - As long as you have not reached the start case, continue to extract the next edge.
        while let visit = paths[vertex], case .edge(let edge) = visit {
            path = [edge] + path // 4 - Add this edge to the path.
            vertex = edge.source // 5 - Set the current vertex to the edge’s source vertex. This moves you closer to the start vertex.
        }
        return path // 6 - Once the while loop reaches the start case, you have completed the path and return it.
    }
    
    // Once you have the ability to construct a path from the destination back to the start vertex, you need a way to calculate the total weight for that path.
    // This method takes in the destination vertex and a dictionary of existing paths, and it returns the total weight.
    private func distance(
        to destination: Vertex<T>,
        with paths: [Vertex<T> : Visit<T>]
    ) -> Double {
        let path = route(to: destination, with: paths) // 1 - Construct the path to the destination vertex.
        let distances = path.compactMap { $0.weight } // 2 - compactMap removes all the nil weights values from the paths.
        return distances.reduce(0.0, +) // 3 - reduce sums the weights of all the edges.
    }
    
    // To get the shortest path, we take in a start vertex and returns a dictionary of all the paths
    func shortestPath(
        from start: Vertex<T>
    ) -> [Vertex<T> : Visit<T>] {
        var paths: [Vertex<T> : Visit<T>] = [start: .start] // 1 - Define paths and initialize it with the start vertex.
        
        // 2 - Create a min-priority queue to store the vertices that must be visited.
        // The sort closure uses the distance method you created to sort the vertices by their distance from the start vertex.
        var priorityQueue = PriorityQueue<Vertex<T>>(sort: {
            self.distance(to: $0, with: paths) < self.distance(to: $1, with: paths)
        })
        priorityQueue.enqueue(start) // 3 - Enqueue the start vertex as the first vertex to visit.
        
        while let vertex = priorityQueue.dequeue() { // 1 - You continue Dijkstra’s algorithm to find the shortest paths until all the vertices have been visited. This happens once the priority queue is empty.
            for edge in graph.edges(from: vertex) { // 2 - For the current vertex, you go through all its neighboring edges.
                guard let weight = edge.weight else { // 3 - You make sure the edge has a weight. If not, you move on to the next edge.
                    continue
                }
                if paths[edge.destination] == nil
                    || distance(to: vertex, with: paths) + weight
                    < distance(to: edge.destination, with: paths) { // 4 - If the destination vertex has not been visited before or you’ve found a cheaper path, you update the path and add the neighboring vertex to the priority queue.
                    paths[edge.destination] = .edge(edge)
                    priorityQueue.enqueue(edge.destination)
                }
            }
        }
        return paths
    }
}


// Testing
example(of: "Dijkstra algorithm shortest path") {
    let graph = AdjacencyList<String>()
    let a = graph.createVertex(data: "A")
    let b = graph.createVertex(data: "B")
    let c = graph.createVertex(data: "C")
    let d = graph.createVertex(data: "D")
    let e = graph.createVertex(data: "E")
    let f = graph.createVertex(data: "F")
    let g = graph.createVertex(data: "G")
    let h = graph.createVertex(data: "H")

    graph.add(.directed, from: a, to: b, weight: 8)
    graph.add(.directed, from: a, to: f, weight: 9)
    graph.add(.directed, from: a, to: g, weight: 1)
    graph.add(.directed, from: b, to: f, weight: 3)
    graph.add(.directed, from: b, to: e, weight: 1)
    graph.add(.directed, from: f, to: a, weight: 2)
    graph.add(.directed, from: h, to: f, weight: 2)
    graph.add(.directed, from: h, to: g, weight: 5)
    graph.add(.directed, from: g, to: c, weight: 3)
    graph.add(.directed, from: c, to: e, weight: 1)
    graph.add(.directed, from: c, to: b, weight: 3)
    graph.add(.undirected, from: e, to: c, weight: 8)
    graph.add(.directed, from: e, to: b, weight: 1)
    graph.add(.directed, from: e, to: d, weight: 2)
    
    let dijkstra = Dijkstra(graph: graph)
    let pathsFromA = dijkstra.shortestPath(from: a) // 1 - Calculate the shortest paths to all the vertices from the start vertex A.
    print("Shortest paths from vertex A")
    pathsFromA.forEach { print($0.key, $0.value)}
    let path = dijkstra.shortestPath(to: d, paths: pathsFromA) // 2 - Get the shortest path to D.

    print("Shortest path to D")
    for edge in path { // 3
      print("\(edge.source) --|\(edge.weight ?? 0.0)|--> \(edge.destination)")
    }
    let cost = path.reduce(into: 0.0) { partialResult, edge in
        partialResult = partialResult + (edge.weight ?? 0.0)
    }
    print("Cost is \(cost)")
}

// Performance
// In Dijkstra’s algorithm, you constructed your graph using an adjacency list. You used a min-priority queue to store vertices and extract the vertex with the minimum path. This has an overall performance of O(log V). This is because the heap operations of extracting the minimum element or inserting an element both take O(log V).
// If you recall from the breadth-first search chapter, it takes O(V + E) to traverse all the vertices and edges.
// Dijkstra’s algorithm is somewhat similar to breadth-first search, because you have to explore all neighboring edges.
// This time, instead of going down to the next level, you use a min-priority queue to select a single vertex with the shortest distance to traverse down. That means it is O(1 + E) or simply O(E). So, combining the traversal with operations on the min-priority queue, it takes O(E log V) to perform Dijkstra’s algorithm.

// Key points
// - Dijkstra’s algorithm finds a path to the rest of the nodes given a starting vertex.
// - This algorithm is useful for finding the shortest paths between different endpoints.
// - Visit state is used to track the edges back to the start vertex.
// - The priority queue data structure helps to always return the vertex with the shortest path.
// - Hence, it is a greedy algorithm!


// Challenge: Find all the shortest paths
// Given a graph, step through Dijkstra’s algorithm to produce the shortest path to every other vertex starting from vertex A.
//                    9
//    "**B**"----------------->"**D**"-------
//    /\   |                                |2
//    |    |8                               |
//    |    \/              2                \/
//    |   "**C**"------------------------>"**E**"
//    |    /\                               /\
//    |    |                                |
//    |    |12                              |
//    |    |                                |
//   1|    |                                |
//    |    |                                |
//    |    |             21                 |
//    ---"**A**"----------------------------
//
// Add a method to class Dijkstra that returns a dictionary of all the shortest paths to all vertices given a starting vertex.

extension Dijkstra {
    func getAllShortestPath(
        from source: Vertex<T>
    ) -> [Vertex<T> : [Edge<T>]] {
        var pathsDict = [Vertex<T> : [Edge<T>]]() // 1 - The dictionary stores the path to every vertex from the source vertex.
        let pathsFromSource = shortestPath(from: source) // 2 - Perform Dijkstra’s algorithm to find all the paths from the source vertex.
        // 3 - For every vertex in the graph, generate the list of edges between the source vertex to every vertex in the graph.
        for vertex in graph.vertices {
            let path = shortestPath(to: vertex, paths: pathsFromSource)
            pathsDict[vertex] = path
        }
        return pathsDict // 4 - Return the dictionary of paths.
    }
}

example(of: "Dijkstra algorithm all shortestPaths from each vertex") {
    let graph = AdjacencyList<String>()
    let a = graph.createVertex(data: "A")
    let b = graph.createVertex(data: "B")
    let c = graph.createVertex(data: "C")
    let d = graph.createVertex(data: "D")
    let e = graph.createVertex(data: "E")

    graph.add(.directed, from: a, to: b, weight: 1)
    graph.add(.directed, from: a, to: c, weight: 12)
    graph.add(.directed, from: a, to: e, weight: 21)
    graph.add(.directed, from: b, to: d, weight: 9)
    graph.add(.directed, from: b, to: c, weight: 8)
    graph.add(.directed, from: c, to: e, weight: 2)
    graph.add(.directed, from: d, to: e, weight: 2)
    
    let dijkstra = Dijkstra(graph: graph)
    let path = dijkstra.getAllShortestPath(from: a)
    for (vertex, edges) in path { // 3
        print("Vertex from A is", vertex)
        edges.forEach { edge in
            print("\(edge.source) --|\(edge.weight ?? 0.0)|--> \(edge.destination)")
        }
        let cost = edges.reduce(into: 0.0) { partialResult, edge in
            partialResult = partialResult + (edge.weight ?? 0.0)
        }
        print("And total cost is \(cost)\n")
    }
}
