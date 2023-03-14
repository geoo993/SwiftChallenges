//: [Previous](@previous)

import Foundation

func example(of description: String, action: () -> Void) {
  print("\n--- Example of:", description, "---")
  action()
}

/*
// As discussed in the introduction to this section, collections are flexible “containers” that let you store any number of values together. Before discussing these collections, you need to understand the concept of mutable vs immutable collections.
// As part of exploring the differences between the collection types, you’ll also consider performance: how quickly the collections can perform certain operations, such as adding to the collection or searching through it.

// The usual way to talk about performance is with big-O notation. If you’re not familiar with it already, start reading the next chapter for a brief introduction.

// Big-O notation is a way to describe running time, or how long an operation takes to complete. The idea is that the exact time an operation takes isn’t important; it’s the relative difference in scale that matters.

// Imagine you have a list of names in some random order, and you have to look up the first name on the list. It doesn’t matter whether the list has a single name or a million names — glancing at the very first name always takes the same amount of time. That’s an example of a constant time operation, or O(1) in big-O notation.

// Now say you have to find a particular name on the list. You need to scan through the list and look at every single name until you either find a match or reach the end. Again, we’re not concerned with the exact amount of time this takes, just the relative time compared to other operations.

// To figure out the running time, think in terms of units of work. You need to look at every name, so consider there to be one “unit” of work per name. If you had 100 names, that’s 100 units of work. What if you double the number of names to 200? How does that change the amount of work?

// The answer is it also doubles the amount of work. Similarly, if you quadruple the number of names, that quadruples the amount of work.

// This increase in work is an example of a linear time operation, or O(N) in big-O notation. The input size is the variable N, which means the amount of time the process takes is also N. There’s a direct, linear relationship between the input size (the number of names in the list) and the time it will take to search for one name.

// You can see why constant time operations use the number one in O(1). They’re just a single unit of work, no matter what!

// You can read more about big-O notation by searching the Web. You’ll only need constant time and linear time in this book, but there are other such time complexities out there.

// Big-O notation is particularly important when dealing with collection types because collections can store vast amounts of data. You need to be aware of running times when you add, delete or edit values.

// For example, if collection type A has constant-time searching and collection type B has linear-time searching, which you choose to use will depend on how much searching you’re planning to do.
*/

/*
 Mutable versus immutable collections
 If the collection doesn’t need to change after you’ve created it, you should make it immutable by declaring it as a constant with let. Alternatively, if you need to add, remove or update values in the collection, then you should create a mutable collection by declaring it as a variable with var.
 */


example(of: "Array") {
    // Arrays are the most common collection type you’ll run into in Swift. Arrays are typed, just like regular variables and constants, and store multiple values like a simple list.
    
    // An array is an ordered collection of values of the same type. The elements in the array are zero-indexed, which means the index of the first element is 0, the index of the second element is 1, and so on. Knowing this, you can work out that the last element’s index is the number of values in the array minus one
    
    var players = ["Alice", "Bob", "Cindy", "Dan"]
    if players.count < 2 {
        print("We need at least two players!")
    } else {
        print("Let’s start!")
    }
    
    // downcasting
    var currentPlayer = players.first
    print(currentPlayer as Any)
    
    // Using subscripting
    var firstPlayer = players[0]
    print("First player is \(firstPlayer)")
    
    // appending
    players.append("Eli")
    print("appended", players)
    
    // appending
    players.append("Eli")
    print("appended", players)
    
    players += ["Gina"]
    print("appended again", players)
    
    // insert
    players.insert("Frank", at: 5)
    print("inserted", players)
    
    // remove
    var removedPlayer = players.removeLast()
    print("\(removedPlayer) was removed")
    
    removedPlayer = players.remove(at: 2)
    print("\(removedPlayer) was removed")
    
    // iterating through
    for player in players {
        print(player)
    }
}


example(of: "\nDictionary") {
    // A dictionary is an unordered collection of pairs, where each pair comprises a key and a value.
    // The easiest way to create a dictionary is by using a dictionary literal. This is a list of key-value pairs separated by commas, enclosed in square brackets.
    var namesAndScores = ["Anna": 2, "Brian": 2, "Craig": 8, "Donna": 6]
    print(namesAndScores)
    
    // While Dictionaries are disordered they can bring you some benefits here.
    // As keys are hashed and stored in a hash table any given operation will cost you 1 cycle.
    // Only exception can be finding an element with a given property.
    // It can cost you N/2 cycle in the worst case.
    // With clever design however you can assign property values as dictionary keys so the lookup will cost you 1 cycle only no matter how many elements are inside.
    
    // empty dictionary
    namesAndScores = [:]
    
    // reserve space in dictionary
    var pairs: [String: Int] = [:]
    pairs.reserveCapacity(20)
    print(pairs)
    
    // accessing values in dictioanry
    // As with arrays, there are several ways to access dictionary values.
    // Dictionaries support subscripting to access values.
    // Unlike arrays, you don’t access a value by its index but rather by its key. For example, if you want to get Anna’s score, you would type:
    namesAndScores = ["Anna": 2, "Brian": 2, "Craig": 8, "Donna": 6]
    print(namesAndScores["Anna"]!)
    
    
    // adding new pair
    namesAndScores["Greg"]
    namesAndScores["Sam"] = 9
    namesAndScores.updateValue(29, forKey: "Anna")
    print(namesAndScores)
    
    // Dictionaries, like arrays, conform to Swift’s Collection protocol. Because of that, they share many of the same properties. For example, both arrays and dictionaries have isEmpty and count properties:
    namesAndScores.isEmpty  //  false
    namesAndScores.count    //  4
    
    // removing pair
    namesAndScores.removeValue(forKey: "Anna")
    namesAndScores["Craig"] = nil
    print(namesAndScores)
    
    // iterating through a dictionary
    for (player, score) in namesAndScores {
        print("\(player) - \(score)")
    }
    
    for player in namesAndScores.keys {
      print("\(player), ", terminator: "") // no newline
    }
}


example(of: "\nSet") {
    // A set is an unordered collection of unique values of the same type. This can be extremely useful when you want to ensure that an item doesn’t appear more than once in your collection, and when the order of your items isn’t important.
    
    // Create a set
    
    let setOne: Set<Int> = [1]
    print(setOne)
    
    // Set literals
    //Sets don’t have their own literals. You use array literals to create a set with initial values. Consider this example:
    let someArray = [1, 2, 3, 1, 4]
    
    var explicitSet: Set<Int> = [1, 2, 3, 1]
    print(explicitSet)
    
    var someSet = Set([1, 2, 3, 1, 7, 8])
    print(someSet)
    
    let fromArray = Set(someArray)
    print(fromArray)
    
    
    // Accessing elements
    print(someSet.contains(1))
    print(someSet.contains(4))
    
    // Adding and removing elements
    someSet.insert(5)
    print(someSet)
    
    let removedElement = someSet.remove(1)
    print(removedElement!)
    print(someSet)
}
