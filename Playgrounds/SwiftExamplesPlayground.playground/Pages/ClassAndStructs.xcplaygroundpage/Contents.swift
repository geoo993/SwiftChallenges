import Foundation

func example(of description: String, action: () -> Void) {
  print("\n--- Example of:", description, "---")
  action()
}


// Both class and structure can do:
// - Define properties to store values
// - Define methods to provide functionality
// - Be extended
// - Conform to protocols
// - Define initializers
// - Define Subscripts to provide access to their variables

//The only things that class can do:
// - Inheritance
// - Typecasting
// - Define deinitialisers
// - Allow reference counting for multiple references.


// Here's an example with a class.
// Note how when the name is changed, the instance referenced by both variables is updated.
// Class are part of reference types. Copying a reference, implicitly creates a shared instance.
// After a copy, two variables then refer to a single instance of the data, so modifying data in the second variable also affects the original.


class SomeClass {
    var name: String
    init(name: String) {
        self.name = name
    }
}

example(of: "Class") {
    // Tom is now Sam, everywhere that Tom was ever referenced.
    var aClass = SomeClass(name: "Tom")
    var bClass = aClass // aClass and bClass now reference the same instance!
    bClass.name = "Sam"
    
    print(aClass.name) // "Sam"
    print(bClass.name) // "Sam"
}


// And now with a struct we see that the values are copied and each variable keeps its own set of values.
// Structs are part of value types meaning each instance keeps a unique copy of its data. Enums and tuples are similar.
// The most basic distinguishing feature of a value type is that copying the effect of assignment, initialization, and argument passing, to create an independent instance with its own unique copy of its data.
struct SomeStruct {
    var name: String
    init(name: String) {
        self.name = name
    }
}

example(of: "Struct") {
    // When we set the name to Sue, the Bob struct in aStruct does not get changed.
    var aStruct = SomeStruct(name: "Bob")
    var bStruct = aStruct // aStruct and bStruct are two structs with the same value!
    bStruct.name = "Sue"
    
    print(aStruct.name) // "Bob"
    print(bStruct.name) // "Sue"
}

// Equatable operator
// You can use value types when comparing instance data with == makes sense which you will also need to conform to Equatable protocol, which is good practice for all value types.
// Enums benefit from automatically synthesized implementations as long as their associated values are comparable.
// You can compare objects if they implement the Equatable protocol or if a global comparison method exists for both types.
// You can rely on automatically synthesized conformance or go for more flexibility by implementing custom comparing logic.

struct Author: Equatable {
    let name: String
}

enum Genre {
    case drama, thriller
}

struct Content: Equatable {
    let id = UUID()
    let title: String
    let author: Author
    let genre: Genre
}


example(of: "Equatable Operator") {
    // You will be able to compare two instances using the ==, or != operator:
    let contentA = Content(title: "The Best Of SwiftUI", author: .init(name: "Admm"), genre: .drama)
    let contentB = Content(title: "Becoming more productive", author: .init(name: "Wmak"), genre: .thriller)
    print("Both Contents are equal? ", contentA == contentB)
}

func ==(left: SomeStruct, right: SomeStruct) -> Bool {
    left.name == right.name
}

example(of: "Compane instance with struct") {
    // since structs are value types, comparing instance data with == makes sense
    var aStruct = SomeStruct(name: "Bob")
    var bStruct = aStruct
    bStruct.name = "Sue"
    print("Both Bob and Sue are equal? ", aStruct == bStruct)
    
    bStruct.name = "Bob"
    print("Both Bon and Bon are equal? ", aStruct == bStruct)
}

// Since class are reference types, you can use a it when comparing instance identity with ===.
example(of: "Class Identity check") {
    // This === checks if two objects are exactly identical, right down to the memory address that stores the data.
    var aClass = SomeClass(name: "Tom")
    var bClass = aClass // aClass and bClass now reference the same instance!
    bClass.name = "Sam"
    print("Both aClass and bClass classes are the same? ", aClass === bClass)
    
    var cClass = SomeClass(name: "Ronny")
    print("But now Both aClass and cClass classes are the same? ", aClass === cClass)
}


