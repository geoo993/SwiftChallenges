import UIKit

// Constants -  properties that cannot change
let name = "George"
//name = "Alex"

// Variables - are properties that can change,
var greeting = "Hello, playground"


// Custom Object
struct Person {
    var name: String
}

struct House {
    var person: Person
}

var person = Person(name: "Geo")
person.name = "etr"

var house1 = House(person: Person(name: "Gepo"))
house1.person.name = "Hamms"
house1.person = Person(name: "Goe")

