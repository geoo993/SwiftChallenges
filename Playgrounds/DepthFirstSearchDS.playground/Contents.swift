import Foundation

func example(of description: String, action: () -> Void) {
  print("\n--- Example of:", description, "---")
  action()
}

// We looked at breadth-first search (BFS) in which you had to explore every neighbor of a vertex before going to the next level.
// Now we will look at depth-first search (DFS), another algorithm for traversing or searching a graph.

// There are a lot of applications for DFS:
// - Topological sorting.
// - Detecting a cycle.
// - Path finding, such as in maze puzzles.
// - Finding connected components in a sparse graph.

// To perform a DFS, you start with a given source vertex and attempt to explore a branch as far as possible until you reach the end.
// At this point, you would backtrack (move a step back) and explore the next available branch until you find what you are looking for or until you’ve visited all the vertices.

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

// You will use a stack to keep track of the levels you move through.
// The stack’s last-in-first-out approach helps with backtracking.
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

extension Stack: ExpressibleByArrayLiteral {
    init(arrayLiteral elements: Element...) {
        storage = elements
    }
}

extension Stack: CustomStringConvertible {
    public var description: String {
    """
    ----top----
    \(storage.map { "\($0)" }.reversed().joined(separator: "\n"))
    -----------
    """
    }
}

// Every push on the stack means that you move one level deeper. You can pop to return to a previous level if you reach a dead end.
// As long as the stack is not empty, you visit the top vertex on the stack and push the first neighboring vertex that has yet to be visited.
// Recall from the previous chapter that the order in which you add edges influences the result of a search.
// Note that, every time you push on the stack, you advance farther down a branch. Instead of visiting every adjacent vertex, you simply continue down a path until you reach the end and then backtrack.
// When exploring the vertices, you can construct a tree-like structure, showing the branches you’ve visited. You can see how deep DFS went, compared to BFS.


extension Graph where Element: Hashable {
    // This takes in a starting vertex and returns a list of vertices in the order they were visited.
    func depthFirstSearch(
        from source: Vertex<Element>
    ) -> [Vertex<Element>] {
        var stack: Stack<Vertex<Element>> = [] // stack is used to store your path through the graph.
        
        // pushed remembers which vertices have been pushed before so that you don’t visit the same vertex twice. It is a Set to ensure fast O(1) lookup.
        var pushed: Set<Vertex<Element>> = []
        
        // visited is an array that stores the order in which the vertices were visited.
        var visited: [Vertex<Element>] = []
        
        stack.push(source)
        pushed.insert(source)
        visited.append(source)
        
        // 1 - We continue to check the top of the stack for a vertex until the stack is empty. You have labeled this loop outer so that you have a way to continue to the next vertex, even within nested loops.
        outer: while let vertex = stack.peek() {
            let neighbors = edges(from: vertex) // 2 - You find all the neighboring edges for the current vertex.
            guard !neighbors.isEmpty else { // 3 - If there are no edges, you pop the vertex off the stack and continue to the next one.
                stack.pop()
                continue
            }
            
            // 4 - Here, you loop through every edge connected to the current vertex and check to see if the neighboring vertex has been seen. If not, you push it onto the stack and add it to the visited array. It may seem a bit premature to mark this vertex as visited (you haven’t peeked at it yet) but, since vertices are visited in the order in which they are added to the stack, it results in the correct order.
            for edge in neighbors {
                if !pushed.contains(edge.destination) {
                    stack.push(edge.destination)
                    pushed.insert(edge.destination)
                    visited.append(edge.destination)
                    continue outer // 5 - Now that you’ve found a neighbor to visit, you continue the outer loop and move to the newly pushed neighbor.
                }
            }
            stack.pop() // 6 - If the current vertex did not have any unvisited neighbors, you know you’ve reached a dead end and can pop it off the stack.
        }
        // Once the stack is empty, the DFS algorithm is complete! All you have to do is return the visited vertices in the order you visited them.
        return visited
    }
}

example(of: "Depth-First letters search") {
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
    graph.add(.undirected, from: b, to: e, weight: nil)
    graph.add(.undirected, from: e, to: f, weight: nil)
    graph.add(.undirected, from: f, to: c, weight: nil)
    graph.add(.undirected, from: c, to: g, weight: nil)
    graph.add(.undirected, from: g, to: f, weight: nil)
    graph.add(.undirected, from: e, to: h, weight: nil)

    // One thing to keep in mind with neighboring vertices is that the order in which you visit them is determined by how you construct your graph.
    // You could have added an edge between A and C before adding one between A and B. In this case, the output would list C before B.
    let vertices = graph.depthFirstSearch(from: a)
    vertices.forEach { vertex in
        print(vertex)
    }
}

//== Performance
// DFS will visit every single vertex at least once. This has a time complexity of O(V).
// When traversing a graph in DFS, you have to check all neighboring vertices to find one available to visit. The time complexity of this is O(E), because in the worst case, you have to visit every single edge in the graph.
// Overall, the time complexity for depth-first search is O(V + E).

// The space complexity of depth-first search is O(V) since you have to store vertices in three separate data structures: stack, pushed and visited.

// Key points
// - Depth-first search (DFS) is another algorithm to traverse or search a graph.
// - DFS explores a branch as far as possible until it reaches the end.
// - Leverage a stack data structure to keep track of how deep you are in the graph. Only pop off the stack when you reach a dead end.

// Challenge 1: BFS or DFS
// For each of the following two examples, which traversal (depth-first or breadth-first) is better for discovering if a path exists between the two nodes? Explain why.
// [A][B][C][D][F][H]
// [G]
// - Path from A to F: Use depth-first, because the path you are looking for is deeper in the graph.
// - Path from A to G: Use breadth-first, because the path you are looking for is near the root.


// Challenge 2: Recursive DFS
// In this chapter, you went over an iterative implementation of depth-first search. Now write a recursive implementation.

extension Graph where Element: Hashable  {
    // Overall time complexity for depth-first search is O(V + E).
    func dfs(from start: Vertex<Element>) -> [Vertex<Element>] {
        var pushed: Set<Vertex<Element>> = [] // pushed keeps tracks of which vertices have been visited.
        var visited: [Vertex<Element>] = [] // visited keeps track of the vertices visited in order.
        
        // Perform depth first search recursively by calling a helper function.
        dfs(from: start, pushed: &pushed, visited: &visited)

        return visited
    }
    
    private func dfs(
        from source: Vertex<Element>,
        pushed: inout Set<Vertex<Element>>,
        visited: inout [Vertex<Element>]
    ) {
        pushed.insert(source) // 1 - Insert the source vertex into the queue, and mark it as visited.
        visited.append(source)
        
        let neighborEdges = edges(from: source)
        neighborEdges.forEach { edge in // 2 - For every neighboring edge.
            if !pushed.contains(edge.destination) {
                // 3 - As long as the adjacent vertex has not been visited yet, continue to dive deeper down the branch recursively.
                dfs(from: edge.destination, pushed: &pushed, visited: &visited)
            }
        }
    }
}

example(of: "Depth-First iterative search") {
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
    graph.add(.undirected, from: b, to: e, weight: nil)
    graph.add(.undirected, from: e, to: f, weight: nil)
    graph.add(.undirected, from: f, to: c, weight: nil)
    graph.add(.undirected, from: c, to: g, weight: nil)
    graph.add(.undirected, from: g, to: f, weight: nil)
    graph.add(.undirected, from: e, to: h, weight: nil)

    let vertices = graph.dfs(from: a)
    vertices.forEach { vertex in
        print(vertex)
    }
}

// Challenge 3: Detect a cycle
// Add a method to Graph to detect if a directed graph has a cycle.

// A graph is said to have a cycle when there is a path of edges and vertices leading back to the same source.
extension Graph where Element: Hashable {
    func hasCycle(from source: Vertex<Element>) -> Bool  {
        var pushed: Set<Vertex<Element>> = [] // 1 - pushed is used to keep track of all the vertices visited.
        return hasCycle(from: source, pushed: &pushed) // 2 - Recursively check to see if there is a cycle in the graph by calling a helper function.
    }
    
    func hasCycle(
        from source: Vertex<Element>,
        pushed: inout Set<Vertex<Element>>
    ) -> Bool {
        pushed.insert(source) // 1 - To initiate the algorithm, first insert the source vertex.
        let neighbors = edges(from: source) // 2 - For every neighboring edge.
        for edge in neighbors {
            // 3 - If the adjacent vertex has not been visited before, recursively dive deeper down a branch to check for a cycle.
            if !pushed.contains(edge.destination) && hasCycle(from: edge.destination, pushed: &pushed) {
                return true
            } else if pushed.contains(edge.destination) { // 4 - If the adjacent vertex has been visited before, you have found a cycle.
                return true
            }
        }
        pushed.remove(source) // 5 - Remove the source vertex so you can continue to find other paths with a potential cycle.
        return false // 6 - No cycle has been found.
        // You are essentially performing a depth-first graph traversal. By recursively diving down one path till you find a cycle, and back-tracking by popping off the stack to find another path. The time-complexity is O(V + E).
    }
}

example(of: "Depth-First search has cycle") {
    let graph = AdjacencyList<String>()
    let a = graph.createVertex(data: "A")
    let b = graph.createVertex(data: "B")
    let c = graph.createVertex(data: "C")
    let d = graph.createVertex(data: "D")
    let e = graph.createVertex(data: "E")
    let f = graph.createVertex(data: "F")
    let g = graph.createVertex(data: "G")
    let h = graph.createVertex(data: "H")

    graph.add(.directed, from: a, to: b, weight: nil)
    graph.add(.directed, from: a, to: d, weight: nil)
    graph.add(.directed, from: b, to: e, weight: nil)
    graph.add(.directed, from: e, to: f, weight: nil)
    graph.add(.directed, from: e, to: h, weight: nil)
    graph.add(.directed, from: f, to: g, weight: nil)
    graph.add(.directed, from: g, to: c, weight: nil)
//    graph.add(.directed, from: c, to: f, weight: nil)

    print("Has cycle from A", graph.hasCycle(from: a))
    graph.add(.undirected, from: a, to: c, weight: nil)
    print("Has cycle from A again", graph.hasCycle(from: a))
}
