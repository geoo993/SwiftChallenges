import Foundation

// Both class and structure can do:
// - Define properties to store values
// - Define methods to provide functionality
// - Be extended
// - Conform to protocols
// - Define initializers
// - Define Subscripts to provide access to their variables

//The only class can do:
// - Inheritance
// - Typecasting
// - Define deinitialisers
// - Allow reference counting for multiple references.


// Here's an example with a class.
// Note how when the name is changed, the instance referenced by both variables is updated.
// Bob is now Sue, everywhere that Bob was ever referenced.

class SomeClass {
    var name: String
    init(name: String) {
        self.name = name
    }
}
var aClass = SomeClass(name: "Bob")
var bClass = aClass // aClass and bClass now reference the same instance!
bClass.name = "Sue"

print(aClass.name) // "Sue"
print(bClass.name) // "Sue"


// And now with a struct we see that the values are copied and each variable keeps its own set of values.
// When we set the name to Sue, the Bob struct in aStruct does not get changed.

struct SomeStruct {
    var name: String
    init(name: String) {
        self.name = name
    }
}

var aStruct = SomeStruct(name: "Bob")
var bStruct = aStruct // aStruct and bStruct are two structs with the same value!
bStruct.name = "Sue"

print(aStruct.name) // "Bob"
print(bStruct.name) // "Sue"
