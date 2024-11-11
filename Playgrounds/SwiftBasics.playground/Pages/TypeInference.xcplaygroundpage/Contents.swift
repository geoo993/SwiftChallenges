import Foundation

// Interger
let age = 23

// Double
let double = 23.0003749839 // - Double - Can hold large values
let float = Float(23.89595) // - Double - Can hold less values than double

// booleans represent condition statements
let areYouAnAdult = age > 18
let areYouAnAdult2 = age > 18 ? "Yep" : "Nope"
let dmfm = String(areYouAnAdult)

// String
let name = "George"
let agePlaceholder = "\(age)"

// string concatenation
let message = "My name is" + name + ", I am " + agePlaceholder + " years old"

// string interpolation
let message2 = "My name is \(name), I am \(agePlaceholder) years old"

// Characters
let character1 = "a" as Character
let number = Int("37374")
