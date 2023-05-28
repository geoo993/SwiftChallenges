import Foundation

func example(of description: String, action: () -> Void) {
  print("\n--- Example of:", description, "---")
  action()
}

// What do social networks have in common with booking cheap flights around the world? You can represent both of these real-world models as graphs!

// A graph is a data structure that captures relationships between objects. It is made up of VERTICES connected by EDGES.
// In the graph below, the vertices are represented by circles, and the edges are the lines that connect them.

// Weighted graphs
// In a weighted graph, every edge has a weight associated with it that represents the cost of using this edge. This lets you choose the cheapest or shortest path between two vertices.

// Take the airline industry as an example and think of a network with varying flight paths:
// ["Hong Kong", "Singapore", "Tokyo", "Detroit", "Texas", "Seatle", "London"]
//
//       "Singapore"------|                 "Seatle"---------
//        |               |$60                 |            |
//        |$45            |                    |$30         |
//        |               |         $45        |            |
// "Hong Kong"---------"London"----------"San Francisco"-|  |
//   |           $40      |                              |  |$60
//   |$30                 |$45                       $50 |  |
//   |                    |                              |  |
//  "Tokyo"---------------|-------"Detroit"-------------"Texas"
//                $65                            $40
//
// In this example, the vertices represent a state or country, while the edges represent a route from one place to another. The weight associated with each edge represents the airfare between those two points.
// Using this network, you can determine the cheapest flights from San Francisco to Singapore for all those budget-minded digital nomads out there!


// Directed graphs
// As well as assigning a weight to an edge, your graphs can also have direction.
// Directed graphs are more restrictive to traverse, as an edge may only permit traversal in one direction.
// The diagram below represents a directed graph.

//       "Singapore"<-----|                 "Texas"
//        /\              |                    /\
//        |               |                    |
//        |               |                    |
//        \/              \/                   |
// "Hong Kong"<-------->"Tokyo"---------->"London"
//   /\
//   |
//   |
//   |
//  "San Francisco"

// You can tell a lot from this diagram:
// - There is a flight from Hong Kong to Tokyo.
// - There is no direct flight from San Francisco to Tokyo.
// - You can buy a roundtrip ticket between Singapore and Tokyo.
// - There is no way to get from Tokyo to San Francisco.

// Undirected graphs
// You can think of an undirected graph as a directed graph where all edges are bi-directional.
// In an undirected graph:
// - Two connected vertices have edges going back and forth.
// - The weight of an edge applies to both directions.

//       "Singapore"------|                 "Texas"
//        |               |                    |
//        |               |                    |
//        |               |                    |
//        |               |                    |
// "Hong Kong"---------"Tokyo"-----------"London"
//   |
//   |
//   |
//   |
//  "San Francisco"

// Common Operations

enum EdgeType {
    case directed
    case undirected
}

// This protocol describes the common operations for a graph:
protocol Graph {
    associatedtype Element
    
    // Creates a vertex and adds it to the graph.
    func createVertex(data: Element) -> Vertex<Element>
    
    // Adds a directed edge between two vertices.
    func addDirectedEdge(
        from source: Vertex<Element>,
        to destination: Vertex<Element>,
        weight: Double?
    )
    // Adds an undirected (or bi-directional) edge between two vertices.
    func addUndirectedEdge(
        between source: Vertex<Element>,
        and destination: Vertex<Element>,
        weight: Double?
    )
    // Uses EdgeType to add either a directed or undirected edge between two vertices.
    func add(
        _ edge: EdgeType,
        from source: Vertex<Element>,
        to destination: Vertex<Element>,
        weight: Double?
    )
    // Returns a list of outgoing edges from a specific vertex.
    func edges(from source: Vertex<Element>) -> [Edge<Element>]
    // Returns the weight of the edge between two vertices.
    func weight(
        from source: Vertex<Element>,
        to destination: Vertex<Element>
    ) -> Double?
}

// Defining a vertex
// A vertex has a unique index within its graph and holds a piece of data. i.e City like Tokyo
// This Vertex represents vertices that will make up a graph
struct Vertex<T> {
    let index: Int
    let data: T
}

// You’ll use Vertex as the key type for a dictionary, so you need to conform to Hashable.
// The Hashable protocol inherits from Equatable, so you must also satisfy this protocol’s requirement.
// The compiler can synthesize conformance to both protocols, which is why the extensions above are empty.
extension Vertex: Hashable where T: Hashable {}
extension Vertex: Equatable where T: Equatable {}

extension Vertex: CustomStringConvertible {
    var description: String {
        "\(index): \(data)"
    }
}

// Defining an edge
// To connect two vertices, there must be an edge between them!
// Edges added to the collection of vertices
struct Edge<T> {
    let source: Vertex<T>
    let destination: Vertex<T>
    
    // An Edge connects two vertices and has an optional weight.
    let weight: Double?
}


// Adjacency list
// The first graph implementation that you’ll learn uses an adjacency list.
// For every vertex in the graph, the graph stores a list of outgoing edges.
// Take as an example the following network:
//
//       "Singapore"--------------|
//        |                       |
//        |                       |
//        |                       |
//        |                       |
// "Hong Kong"------------------"Tokyo"-----------"Detroit"
//   |                            |
//   |                            |
//   |                            |
//   |                            |
//  "San Francisco"--------------"London"
//
// The adjacency list below describes the network of flights depicted above:

//    Vertices                Adjacency List
// - "Singapore" ----------> "Tokyo" "Hong Kong"
// - "Hong Kong"-----------> "Tokyo" "Singapore"
// - "Tokyo"---------------> "Singapore" "Hong Kong" "Detroit" "London"
// - "Detroit"-------------> "Tokyo"
// - "London"--------------> "Tokyo" "San Francisco"
// - "San Francisco"-------> "Hong Kong" "London"

// There is a lot you can learn from this adjacency list:

// 1) Singapore’s vertex has two outgoing edges. There is a flight from Singapore to Tokyo and Hong Kong.
// 2) Detroit has the smallest number of outgoing traffic.
// 3) Tokyo is the busiest airport, with the most outgoing flights.

// Here we define an AdjacencyList that uses a dictionary to store the edges.
// Notice that the generic parameter T must be Hashable, because it is used as a key in a dictionary.
final class AdjacencyList<T: Hashable>: Graph {
    private var adjacencies: [Vertex<T>: [Edge<T>]] = [:]
    
    init() {}
    
    // We create a new vertex and return it. In the adjacency list, you store an empty array of edges for this new vertex.
    func createVertex(data: T) -> Vertex<T> {
        let vertex = Vertex(index: adjacencies.count, data: data)
        adjacencies[vertex] = []
        return vertex
    }
    
    // This method creates a new edge and stores it in the adjacency list.
    func addDirectedEdge(
        from source: Vertex<T>,
        to destination: Vertex<T>,
        weight: Double?
    ) {
        let edge = Edge(
            source: source,
            destination: destination,
            weight: weight
        )
        adjacencies[source]?.append(edge)
    }
    
}

// An undirected graph can be viewed as a bidirectional graph.
// Every edge in an undirected graph can be traversed in both directions.
// This is why we implement addUndirectedEdge on top of addDirectedEdge.
// Because this implementation is reusable, you’ll add it as a protocol extension on Graph.
extension Graph {
    func addUndirectedEdge(
        between source: Vertex<Element>,
        and destination: Vertex<Element>,
        weight: Double?
    ) {
        // Adding an undirected edge is the same as adding two directed edges.
        addDirectedEdge(from: source, to: destination, weight: weight)
        addDirectedEdge(from: destination, to: source, weight: weight)
    }
    
    // The add method is a convenient helper method that creates either a directed or undirected edge.
    // This is where protocols can become very powerful!
    func add(
        _ edge: EdgeType,
        from source: Vertex<Element>,
        to destination: Vertex<Element>,
        weight: Double?
    ) {
        switch edge {
        case .directed:
            addDirectedEdge(from: source, to: destination, weight: weight)
        case .undirected:
            addUndirectedEdge(between: source, and: destination, weight: weight)
        }
    }
}

// Retrieving the outgoing edges from a vertex
extension AdjacencyList {
    // This is a straightforward implementation: You either return the stored edges or an empty array if the source vertex is unknown.
    func edges(from source: Vertex<T>) -> [Edge<T>] {
        adjacencies[source] ?? []
    }
}

// Retrieving the weight of an edge
// How much is the flight from Singapore to Tokyo?
extension AdjacencyList {
    // here we find the first edge from source to destination; if there is one, you return its weight.
    func weight(
        from source: Vertex<T>,
        to destination: Vertex<T>
    ) -> Double? {
        edges(from: source)
             .first { $0.destination == destination }?
             .weight
    }
}

// Visualizing the adjacency list
extension AdjacencyList: CustomStringConvertible {
    var description: String {
        var result = ""
        for (vertex, edges) in adjacencies { // 1 - You loop through every key-value pair in adjacencies.
            var edgeString = ""
            for (index, edge) in edges.enumerated() { // 2 - For every vertex, you loop through all its outgoing edges and add an appropriate string to the output.
                if index != edges.count - 1 {
                    edgeString.append("\(edge.destination), ")
                } else {
                    edgeString.append("\(edge.destination)")
                }
            }
            result.append("\(vertex) ---> [ \(edgeString) ]\n") // 3 - Finally, for every vertex you print both the vertex itself and its outgoing edges.
        }
        return result
    }
}


// Build a flight network
example(of: "Flight network using Adjacency List") {
    let graph = AdjacencyList<String>()

    let singapore = graph.createVertex(data: "Singapore")
    let tokyo = graph.createVertex(data: "Tokyo")
    let hongKong = graph.createVertex(data: "Hong Kong")
    let detroit = graph.createVertex(data: "Detroit")
    let sanFrancisco = graph.createVertex(data: "San Francisco")
    let london = graph.createVertex(data: "London")
    let austinTexas = graph.createVertex(data: "Austin Texas")
    let seattle = graph.createVertex(data: "Seattle")

    graph.add(.undirected, from: singapore, to: hongKong, weight: 300)
    graph.add(.undirected, from: singapore, to: tokyo, weight: 500)
    graph.add(.undirected, from: hongKong, to: tokyo, weight: 250)
    graph.add(.undirected, from: tokyo, to: detroit, weight: 450)
    graph.add(.undirected, from: tokyo, to: london, weight: 300)
    graph.add(.undirected, from: hongKong, to: sanFrancisco, weight: 600)
    graph.add(.undirected, from: detroit, to: austinTexas, weight: 50)
    graph.add(.undirected, from: austinTexas, to: london, weight: 292)
    graph.add(.undirected, from: sanFrancisco, to: london, weight: 337)
    graph.add(.undirected, from: london, to: seattle, weight: 277)
    graph.add(.undirected, from: sanFrancisco, to: seattle, weight: 218)
    graph.add(.undirected, from: austinTexas, to: sanFrancisco, weight: 297)

    print(graph)
    
    print("Price of singapore to tokyo", graph.weight(from: singapore, to: tokyo))
    
    print("San Francisco Outgoing Flights:")
    print("--------------------------------")
    for edge in graph.edges(from: sanFrancisco) {
        print("from: \(edge.source) to: \(edge.destination)")
    }
}

// Adjacency matrix

// An adjacency matrix uses a square matrix to represent a graph. This matrix is a two-dimensional array wherein the value of matrix[row][column] is the weight of the edge between the vertices at row and column.

// In an adjaceny matrix, edges that don’t exist have a weight of 0.
// Compared to an adjacency list, this matrix is a little harder to read.
// Using the array of vertices on the left, you can learn a lot from the matrix. For example:
// - [0][1] is 300, so there is a flight from Singapore to Hong Kong for $300.
// - [2][1] is 0, so there is no flight from Tokyo to Hong Kong.
// - [1][2] is 250, so there is a flight from Hong Kong to Tokyo for $250.
// - [2][2] is 0, so there is no flight from Tokyo to Tokyo!

// Here, we define an AdjacencyMatrix that contains an array of vertices and an adjacency matrix to keep track of the edges and their weights.
class AdjacencyMatrix<T>: Graph {
    private var vertices: [Vertex<T>] = []
    private var weights: [[Double?]] = []
    
    init() {}
    
    // To create a vertex in an adjacency matrix, you:
    func createVertex(data: T) -> Vertex<T> {
        let vertex = Vertex(index: vertices.count, data: data)
        vertices.append(vertex) // 1 - Add a new vertex to the array.
        for i in 0..<weights.count { // 2 - Append a nil weight to every row in the matrix, as none of the current vertices have an edge to the new vertex.
            weights[i].append(nil)
        }
        let row = [Double?](repeating: nil, count: vertices.count) // 3 - Add a new row to the matrix. This row holds the outgoing edges for the new vertex.
        weights.append(row)
        return vertex
    }
    
    // Creating edges is as simple as filling in the matrix.
    func addDirectedEdge(
        from source: Vertex<T>,
        to destination: Vertex<T>,
        weight: Double?
    ) {
        // Remember that addUndirectedEdge and add have a default implementation in the protocol extension, so this is all you need to do!
        weights[source.index][destination.index] = weight
    }
}

// Retrieving the outgoing edges from a vertex
extension AdjacencyMatrix {
    // To retrieve the outgoing edges for a vertex, you search the row for this vertex in the matrix for weights that are not nil.
    func edges(from source: Vertex<T>) -> [Edge<T>] {
        var edges: [Edge<T>] = []
        for column in 0..<weights.count {
            if let weight = weights[source.index][column] {
                // Every non-nil weight corresponds with an outgoing edge.
                // The destination is the vertex that corresponds with the column in which the weight was found.
                edges.append(
                    Edge(
                        source: source,
                        destination: vertices[column],
                        weight: weight
                    )
                )
            }
        }
        return edges
    }
}

// Retrieving the weight of an edge
extension AdjacencyMatrix {
    // It is very easy to get the weight of an edge; simply look up the value in the adjacency matrix.
    func weight(
        from source: Vertex<T>,
        to destination: Vertex<T>
    ) -> Double? {
        weights[source.index][destination.index]
    }
}

// Visualize an adjacency matrix
extension AdjacencyMatrix: CustomStringConvertible {
    var description: String {
        // 1 - You first create a list of the vertices.
        let verticesDescription = vertices.map { "\($0)" }.joined(separator: "\n")
        // 2 - Then you build up a grid of weights, row by row.
        var grid: [String] = []
        for i in 0..<weights.count {
            var row = ""
            for j in 0..<weights.count {
                if let value = weights[i][j] {
                    row += "\(value)\t"
                } else {
                    row += "ø\t\t"
                }
            }
            grid.append(row)
        }
        let edgesDescription = grid.joined(separator: "\n")
        // 3 - Finally, you join both descriptions together and return them.
        return "\(verticesDescription)\n\n\(edgesDescription)"
    }
}

// Build a flight network
example(of: "Flight network using Adjacency Matrix") {
    let graph = AdjacencyMatrix<String>()

    let singapore = graph.createVertex(data: "Singapore")
    let tokyo = graph.createVertex(data: "Tokyo")
    let hongKong = graph.createVertex(data: "Hong Kong")
    let detroit = graph.createVertex(data: "Detroit")
    let sanFrancisco = graph.createVertex(data: "San Francisco")
    let london = graph.createVertex(data: "London")
    let austinTexas = graph.createVertex(data: "Austin Texas")
    let seattle = graph.createVertex(data: "Seattle")

    graph.add(.undirected, from: singapore, to: hongKong, weight: 300)
    graph.add(.undirected, from: singapore, to: tokyo, weight: 500)
    graph.add(.undirected, from: hongKong, to: tokyo, weight: 250)
    graph.add(.undirected, from: tokyo, to: detroit, weight: 450)
    graph.add(.undirected, from: tokyo, to: london, weight: 300)
    graph.add(.undirected, from: hongKong, to: sanFrancisco, weight: 600)
    graph.add(.undirected, from: detroit, to: austinTexas, weight: 50)
    graph.add(.undirected, from: austinTexas, to: london, weight: 292)
    graph.add(.undirected, from: sanFrancisco, to: london, weight: 337)
    graph.add(.undirected, from: london, to: seattle, weight: 277)
    graph.add(.undirected, from: sanFrancisco, to: seattle, weight: 218)
    graph.add(.undirected, from: austinTexas, to: sanFrancisco, weight: 297)

    print(graph)
}

// Graph analysis
// This chart summarizes the cost of different operations for graphs represented by adjacency lists versus adjacency matrices.

// |     Operations    |  Adjacency List  |  Adjacency Matrix  |
// |___________________|__________________|____________________|
// |   Storage space   |        O(V+E)    |         O(V²)      |
// |___________________|__________________|____________________|
// |     Add vertex    |        O(1)      |         O(V²)      |
// |___________________|_______________________________________|
// |     Add edge      |        O(1)      |         O(1)       |
// |___________________|_______________________________________|
// | finding edg & wei |        O(V)      |         O(1)       |
// |___________________|__________________|____________________|

// V represents vertices, and E represents edges.

// 1) An adjacency list takes less storage space than an adjacency matrix.
// An adjacency list simply stores the number of vertices and edges needed.
// As for an adjacency matrix, recall that the number of rows and columns is equal to the number of vertices.
// This explains the quadratic space complexity of O(V²).

// 2) Adding a vertex is efficient in an adjacency list: Simply create a vertex and set its key-value pair in the dictionary. It is amortized as O(1).
// When adding a vertex to an adjacency matrix, you are required to add a column to every row, and create a new row for the new vertex. This is at least O(V) and if you choose to represent your matrix with a contiguous block of memory, can be O(V²).

// 3) Adding an edge is efficient in both data structures, as they are both constant time.
// The adjacency list appends to the array of outgoing edges. The adjacency matrix simply sets the value in the two-dimensional array.

// 4) Adjacency list loses out when trying to find a particular edge or weight.
// To find an edge in an adjacency list, you must obtain the list of outgoing edges and loop through every edge to find a matching destination. This happens in O(V) time. With an adjacency matrix, finding an edge or weight is a constant time access to retrieve the value from the two-dimensional array.


// = Which data structure should you choose to construct your graph?
// - If there are few edges in your graph, it is considered a sparse graph, and an adjacency list would be a good fit. An adjacency matrix would be a bad choice for a sparse graph, because a lot of memory will be wasted since there aren’t many edges.
// - If your graph has lots of edges, it’s considered a dense graph, and an adjacency matrix would be a better fit as you’d be able to access your weights and edges far more quickly.

// Key points
// - You can represent real-world relationships through vertices and edges.
// - Think of vertices as objects and edges as the relationship between the objects.
// - Weighted graphs associate a weight with every edge.
// - Directed graphs have edges that traverse in one direction.
// - Undirected graphs have edges that point both ways.
// - Adjacency list stores a list of outgoing edges for every vertex.
// - Adjacency matrix uses a square matrix to represent a graph.
// - Adjacency list is generally good for sparse graphs, when your graph has the least amount of edges.
// - Adjacency matrix is generally good for dense graphs, when your graph has lots of edges.


// Challenge 1: Count the number of paths
// Write a method to count the number of paths between two vertices in a directed graph. The example graph below has 5 paths from A to E:

extension Graph where Element: Hashable {
    func numberOfPaths(
        from source: Vertex<Element>,
        to destination: Vertex<Element>
    ) -> Int {
        var numberOfPaths = 0 // 1 - keeps track of the number of paths found between the source and destination.
        var visited: Set<Vertex<Element>> = [] // 2 - visited is a Set that keeps track of all the vertices visited.
        
        // 3 - is a recursive helper function that takes in four parameters. The first two parameters are the source, and destination vertex. The last two parameters, visited tracks the vertices visited, and numberOfPaths tracks the number of paths found. The last two parameters is modified within paths.
        paths(
            from: source,
            to: destination,
            visited: &visited,
            pathCount: &numberOfPaths
        )
        return numberOfPaths
    }
    
    // To get the paths from the source to destination:
    func paths(
        from source: Vertex<Element>,
        to destination: Vertex<Element>,
        visited: inout Set<Vertex<Element>>,
        pathCount: inout Int
    ) {
        visited.insert(source) // 1 - Initiate the algorithm by marking the source vertex as visited.
        if source == destination { // 2 - Check to see if the source is the destination. If it is, you have found a path, increment the count by one.
            pathCount += 1
        } else {
            let neighbors = edges(from: source) // 3 - If it is not, get all the edges adjacent to the source vertex.
            // 4 - For every edge, if it has not been visited before, recursively traverse the neighboring vertices to find a path to the destination vertex.
            for edge in neighbors {
                if !visited.contains(edge.destination) {
                    paths(
                        from: edge.destination,
                        to: destination,
                        visited: &visited,
                        pathCount: &pathCount
                    )
                }
            }
        }
        // 5 - Remove the source vertex from the visited set, so you can continue to find other paths to that node.
        visited.remove(source)
        
        // You are doing a depth-first graph traversal. You recursively dive down one path till you reach the destination, and back-track by popping off the stack. The time-complexity is O(V + E).
    }
}

example(of: "Flight network of direct graph using Adjacency Matrix") {
    let graph = AdjacencyList<String>()

    let singapore = graph.createVertex(data: "Singapore")
    let tokyo = graph.createVertex(data: "Tokyo")
    let hongKong = graph.createVertex(data: "Hong Kong")
    let sanFrancisco = graph.createVertex(data: "San Francisco")
    let london = graph.createVertex(data: "London")
    let austinTexas = graph.createVertex(data: "Austin Texas")

    graph.add(.directed, from: singapore, to: hongKong, weight: nil)
    graph.add(.directed, from: tokyo, to: singapore, weight: nil)
    graph.add(.directed, from: singapore, to: hongKong, weight: nil)
    graph.add(.directed, from: hongKong, to: singapore, weight: nil)
    graph.add(.directed, from: tokyo, to: hongKong, weight: nil)
    graph.add(.directed, from: hongKong, to: tokyo, weight: nil)
    graph.add(.directed, from: sanFrancisco, to: hongKong, weight: nil)
    graph.add(.directed, from: tokyo, to: london, weight: nil)
    graph.add(.directed, from: london, to: austinTexas, weight: nil)
    print(graph)
    
    print("Hong Kong paths to Texas", graph.numberOfPaths(from: hongKong, to: austinTexas))
    print("Tokyo paths to Singapore", graph.numberOfPaths(from: tokyo, to: singapore))
}

// Challenge 2: Graph your friends
// Vincent has three friends, Chesley, Ruiz and Patrick.
// Ruiz has friends as well: Ray, Sun, and a mutual friend of Vincent’s.
// Patrick is friends with Cole and Kerry.
// Cole is friends with Ruiz and Vincent.
// Create an adjacency list that represents this friendship graph. Which mutual friend do Ruiz and Vincent share?


//    "Patrick"------------------"Kerry"
//    |      |
//    |      |
//    |  "Vincent"-------------------------"Chesley"
//    |   |    |
//    |   |    -------------------|
//    |   |                       |
//    |   |                       |
//   "Cole"----------------------"Ruiz"-----------"Ray"
//                                 |
//                                 |
//                                 |
//                                 |
//                               "Sun"

example(of: "Vincent Friends") {
    let graph = AdjacencyList<String>()

    let vincent = graph.createVertex(data: "vincent")
    let chesley = graph.createVertex(data: "chesley")
    let ruiz = graph.createVertex(data: "ruiz")
    let patrick = graph.createVertex(data: "patrick")
    let ray = graph.createVertex(data: "ray")
    let sun = graph.createVertex(data: "sun")
    let cole = graph.createVertex(data: "cole")
    let kerry = graph.createVertex(data: "kerry")

    graph.add(.undirected, from: vincent, to: chesley, weight: 1)
    graph.add(.undirected, from: vincent, to: ruiz, weight: 1)
    graph.add(.undirected, from: vincent, to: patrick, weight: 1)
    graph.add(.undirected, from: ruiz, to: ray, weight: 1)
    graph.add(.undirected, from: ruiz, to: sun, weight: 1)
    graph.add(.undirected, from: patrick, to: cole, weight: 1)
    graph.add(.undirected, from: patrick, to: kerry, weight: 1)
    graph.add(.undirected, from: cole, to: ruiz, weight: 1)
    graph.add(.undirected, from: cole, to: vincent, weight: 1)
    print(graph)
    
    // You can simply look at the graph to find the common friend.
    print("Ruiz and Vincent both share a friend name Cole")
    let vincentsFriends = Set(graph.edges(from: vincent).map { $0.destination.data })
    let mutual = vincentsFriends.intersection(graph.edges(from: ruiz).map { $0.destination.data })
    print(mutual)
}
