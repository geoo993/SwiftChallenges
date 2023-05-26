import Foundation

func example(of description: String, action: () -> Void) {
  print("\n--- Example of:", description, "---")
  action()
}

// The trie (pronounced as try) is a tree that specializes in storing data that can be represented as a collection, such as English words.

// Each character in a string is mapped to a node. The last node in each string is marked as a terminating node (a dot in the image above).
// The benefits of a trie are best illustrated by looking at it in the context of prefix matching.

// You are given a collection of strings. How would you build a component that handles prefix matching?
// Here’s one way:

final class EnglishDictionary {
    private var words: [String] = []
    
    // words(matching:) will go through the collection of strings and return the strings that match the prefix.
    // If the number of elements in the words array is small, this is a reasonable strategy.
    // But if you’re dealing with more than a few thousand words, the time it takes to go through the words array will be unacceptable.
    // The time complexity of words(matching:) is O(k*n), where k is the longest string in the collection, and n is the number of words you need to check.
    func words(matching prefix: String) -> [String] {
        words.filter { $0.hasPrefix(prefix) }
    }
}

// The trie data structure has excellent performance characteristics for this type of problem; as a tree with nodes that support multiple children, each node can represent a single character.
// You form a word by tracing the collection of characters from the root to a node with a special indicator — a terminator — represented by a black dot. An interesting characteristic of the trie is that multiple words can share the same characters.

// To illustrate the performance benefits of the trie, consider the following example in which you need to find the words with the prefix CU.

// First, you travel to the node containing C. That quickly excludes other branches of the trie from the search operation
// Next, you need to find the words that have the next letter U.
// You traverse to the U node:

// Since that’s the end of your prefix, the trie would return all collections formed by the chain of nodes from the U node. In this case, the words CUT and CUTE would be returned. Imagine if this trie contained hundreds of thousands of words.
// The number of comparisons you can avoid by employing a trie is substantial.


// TrieNode

class TrieNode<Key: Hashable> {
    // 1 - key holds the data for the node. This is optional because the root node of the trie has no key.
    var key: Key?
    
    // 2 - A TrieNode holds a weak reference to its parent. This reference simplifies the remove method later on.
    weak var parent: TrieNode?
    
    // 3 - In binary search trees, nodes have a left and right child. In a trie, a node needs to hold multiple different elements. You’ve declared a children dictionary to help with that.
    var children: [Key: TrieNode] = [:]
    
    // 4 - As discussed earlier, isTerminating acts as an indicator for the end of a collection.
    var isTerminating = false
    
    init(key: Key?, parent: TrieNode?) {
        self.key = key
        self.parent = parent
    }
}


// The Trie class is built for all types that adopt the Collection protocol, including String.
// In addition to this requirement, each element inside the collection must be Hashable.
// This is required because you’ll use the collection’s elements as keys for the children dictionary in TrieNode.

final class Trie<CollectionType: Collection & Hashable>
    where CollectionType.Element: Hashable {
  
    typealias Node = TrieNode<CollectionType.Element>
  
    private let root = Node(key: nil, parent: nil)
    private(set) var collections: Set<CollectionType> = []
    
    var count: Int {
        collections.count
    }

    var isEmpty: Bool {
        collections.isEmpty
    }
  
    init() {}
    
    // Tries work with any type that conforms to Collection. The trie will take the collection and represent it as a series of nodes in which each node maps to an element in the collection.
    // The time complexity for this algorithm is O(k), where k is the number of elements in the collection you’re trying to insert. This is because you need to traverse through or create each node that represents each element of the new collection.
    func insert(_ collection: CollectionType) {
        // 1 - current keeps track of your traversal progress, which starts with the root node.
        var current = root
        
        // 2 - A trie stores each element of a collection in separate nodes. For each element of the collection, you first check if the node currently exists in the children dictionary. If it doesn’t, you create a new node. During each loop, you move current to the next node.
        for element in collection {
            if current.children[element] == nil {
                current.children[element] = Node(key: element, parent: current)
            }
            if let value = current.children[element] {
                current = value
            }
        }
        
        // 3 - After iterating through the for loop, current should be referencing the node representing the end of the collection. You mark that node as the terminating node.
        if current.isTerminating {
            return
        } else {
            current.isTerminating = true
            collections.insert(collection)
        }
    }
    
    // contains is very similar to insert.
    // Here, you traverse the trie in a way similar to insert. You check every element of the collection to see if it’s in the tree. When you reach the last element of the collection, it must be a terminating element. If not, the collection was not added to the tree and what you’ve found is merely a subset of a larger collection.
    // The time complexity of contains is O(k), where k is the number of elements in the collection that you’re looking for. This is because you need to traverse through k nodes to find out whether or not the collection is in the trie.
    func contains(_ collection: CollectionType) -> Bool {
        var current = root
        for element in collection {
            guard let child = current.children[element] else {
                return false
            }
            current = child
        }
        return current.isTerminating
    }
}

// test out insert and contains,
example(of: "insert and contains") {
    let trie = Trie<String>()
    trie.insert("cute")
    if trie.contains("cute") {
        print("cute is in the trie")
    }
    
    trie.insert("hammer")
    trie.insert("ham")
    if trie.contains("ham") {
        print("ham is in the trie")
    }
}

// Removing a node in the trie is a bit more tricky. You need to be particularly careful when removing each node, since nodes can be shared between two different collections

extension Trie {
    // The time complexity of this algorithm is O(k), where k represents the number of elements of the collection that you’re trying to remove.
    func remove(_ collection: CollectionType) {
        // 1 - This part should look familiar, as it’s basically the implementation of contains. You use it here to check if the collection is part of the trie and to point current to the last node of the collection.
        var current = root
        for element in collection {
            guard let child = current.children[element] else {
                return
            }
            current = child
        }
        guard current.isTerminating else {
            return
        }
        // 2 - You set isTerminating to false so the current node can be removed by the loop in the next step.
        current.isTerminating = false
        collections.remove(collection)

        // 3 - This is the tricky part. Since nodes can be shared, you don’t want to carelessly remove elements that belong to another collection. If there are no other children in the current node, it means that other collections do not depend on the current node. You also check to see if the current node is a terminating node. If it is, then it belongs to another collection. As long as current satisfies these conditions, you continually backtrack through the parent property and remove the nodes.
        while let parent = current.parent,
              current.children.isEmpty && !current.isTerminating {
            parent.children[current.key!] = nil
            current = parent
        }
    }
}

example(of: "remove") {
    let trie = Trie<String>()
    trie.insert("cut")
    trie.insert("cute")
    
    print("\n*** Before removing ***")
    assert(trie.contains("cut"))
    print("\"cut\" is in the trie")
    assert(trie.contains("cute"))
    print("\"cute\" is in the trie")
    
    print("\n*** After removing cut ***")
    trie.remove("cut")
    assert(!trie.contains("cut"))
    assert(trie.contains("cute"))
    print("\"cute\" is still in the trie")
    
    print("\n*** Adding cup and cutter ***")
    trie.insert("cutter")
    trie.insert("cup")
    assert(trie.contains("cutter"))
    assert(trie.contains("cup"))
    print("\"cutter\" is in the trie")
    
    print("\n*** Removing cutter ***")
    trie.remove("cutter")
    assert(!trie.contains("cutter"))
    print("\"cutter\" is removed from trie")
}


// The most iconic algorithm for the trie is the prefix-matching algorithm.
extension Trie where CollectionType: RangeReplaceableCollection {
    // Your prefix-matching algorithm will sit inside this extension, where CollectionType is constrained to RangeReplaceableCollection. This is required because the algorithm will need access to the append method of RangeReplaceableCollection types.
    func collections(
        startingWith prefix: CollectionType
    ) -> [CollectionType] {
        // 1 - You start by verifying that the trie contains the prefix. If not, you return an empty array.
        var current = root
        for element in prefix {
            guard let child = current.children[element] else {
                return []
            }
            current = child
        }
        
        // 2 - After you’ve found the node that marks the end of the prefix, you call a recursive helper method collections(startingWith:after:) to find all the sequences after the current node.
        return collections(startingWith: prefix, after: current)
    }
    
    // collection(startingWith:) has a time complexity of O(k*m), where k represents the longest collection matching the prefix and m represents the number of collections that match the prefix.
    // Recall that arrays have a time complexity of O(k*n), where n is the number of elements in the collection.
    private func collections(
        startingWith prefix: CollectionType,
        after node: Node
    ) -> [CollectionType] {
        // 1 - You create an array to hold the results. If the current node is a terminating node, you add it to the results.
        var results: [CollectionType] = []
        
        if node.isTerminating {
            results.append(prefix)
        }
        
        // 2 - Next, you need to check the current node’s children.
        // For every child node, you recursively call collections(startingWith:after:) to seek out other terminating nodes.
        for child in node.children.values {
            var prefix = prefix
            if let key = child.key {
                prefix.append(key)
                results.append(contentsOf: collections(
                    startingWith: prefix,
                    after: child)
                )
            }
        }
        
        return results
    }
}

example(of: "prefix matching") {
    let trie = Trie<String>()
    trie.insert("car")
    trie.insert("card")
    trie.insert("care")
    trie.insert("cared")
    trie.insert("cars")
    trie.insert("carbs")
    trie.insert("carapace")
    trie.insert("cargo")
    
    print("\nCollections starting with \"car\"")
    let prefixedWithCar = trie.collections(startingWith: "car")
    print(prefixedWithCar)
    
    print("\nCollections starting with \"care\"")
    let prefixedWithCare = trie.collections(startingWith: "care")
    print(prefixedWithCare)
}

// Key points
// - Tries provide great performance metrics in regards to prefix matching.
// - Tries are relatively memory efficient since individual nodes can be shared between many different values. For example, “car,” “carbs,” and “care” can share the first three letters of the word.

// Challenge 1: How much faster?
// Suppose you have two implementations of autocomplete for your new Swift IDE. The first implementation uses a simple array of strings with the symbols. The second implementation uses a trie of strings.
// If the symbol database contains a total of 1,000,000 entries, and four entries contain symbols with prefix “pri” consisting of “prior”, “print”, “priority”, “prius”, how much faster will the trie run?

// 1,000,000 * 3 * O(1) / 4 * 8 * O(1) = 93,750 times faster

// Challenge 2: Additional properties
// The current implementation of the trie is missing some notable operations. Your task for this challenge is to augment the current implementation of the trie by adding the following:
// - A collections property that returns all the collections in the trie.
// - A count property that tells you how many collections are currently in the trie.
// - A isEmpty property that returns true if the trie is empty, false otherwise.

example(of: "collections in tries") {
    let trie = Trie<String>()
    print("\n*** Before adding elements ***")
    print("\nCollections count:", trie.collections.count)
    trie.insert("ram")
    trie.insert("car")
    trie.insert("card")
    trie.insert("care")
    trie.insert("cared")
    trie.insert("cars")
    trie.insert("carbs")
    trie.insert("carapace")
    trie.insert("cargo")
    trie.insert("tim")
    trie.insert("ransom")
    trie.insert("timer")
    
    print("\n*** After adding elements ***")
    print("\nCollections in Tries")
    let collections = trie.collections
    print(collections)
    print("\nCollections count:", collections.count)
    print("\nCollections isEmpty:", collections.isEmpty)
}
