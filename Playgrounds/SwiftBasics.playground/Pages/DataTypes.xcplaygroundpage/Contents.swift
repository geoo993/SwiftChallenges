import Foundation

// Interger
let age: Int = 23

// Floating point number
let double: Double = 23.0003749839 // - Double - Can hold large values

let float: Float = 23.89595 // - Double - Can hold less values than double

// Type inference
let age2 = 399

// booleans represent condition statements
let areYouAnAdult: Bool = age > 18

// String
let name: String = "George"

let agePlaceholder = "\(age)"

// string concatenation
let message = "My name is" + name + ", I am " + agePlaceholder + " years old"

// string interpolation
let message2 = "My name is \(name), I am \(agePlaceholder) years old"

// Characters
let character1: Character = "a"
let character2: Character = "b"

let rsultOfChar = "character1"

for char in rsultOfChar {
    let vale = char
}

// Custom data type, some times we call them Models, object
struct Person {
    let name: String
    let age: Int
}
