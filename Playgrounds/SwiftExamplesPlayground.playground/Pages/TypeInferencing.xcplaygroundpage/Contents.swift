import Foundation

// Type Safety
// Swift is a type-safe language. A type safe language encourages you to be clear about the types of values your code can work with. If part of your code expects a String, you can’t pass it an Int by mistake.

var welcomeMessage: String
//welcomeMessage = 22 // this would create an error because you already specified that it's going to be a String

// Type Inference
// If you don’t specify the type of value you need, Swift uses type inference to work out the appropriate type. Type inference enables a compiler to deduce the type of a particular expression automatically when it compiles your code, simply by examining the values you provide.
var meaningOfLife = 42 // meaningOfLife is inferred to be of type Int
meaningOfLife = 55 // it Works, because 55 is an Int

// Type Safety & Type Inference together
var newMeaningOfLife = 42 // 'Type inference' happened here, we didn't specify that this an Int, the compiler itself found out.
newMeaningOfLife = 55 // it Works, because 55 is an Int
//newMeaningOfLife = "SomeString" // Because of 'Type Safety' ability you will get an
//error message: 'cannot assign value of type 'String' to type 'Int''


// Tricky example for protocols with associated types:
// Imagine the following protocol
protocol Identifiable {
    associatedtype ID
    var id: ID { get set }

}

// You would adopt it like this:
struct Person: Identifiable {
    typealias ID = String
    var id: String
}

// However you can also adopt it like this:
struct Website: Identifiable {
    var id: URL
}
// You can remove the typealias. The compiler will still infer the type.


// Pro tip to optimize compiler performance:
// The less type inference your code has to do the faster it compiles. Hence it's recommended to avoid collection literals. And the longer a collection gets, the slower its type inference becomes...

// not bad
let names = ["John", "Ali", "Jane", " Taika"]

// good
// let names : [String] = ["John", "Ali", "Jane", " Taika"]
