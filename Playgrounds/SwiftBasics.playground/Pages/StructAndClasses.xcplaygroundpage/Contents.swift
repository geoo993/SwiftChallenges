//: [Previous](@previous)

import Foundation

// structs - value type, these are things can cannot change meaning you have unique copy of an instance all the time and we create a copy of this everytime we need a mutation
struct Person: Equatable {
    var name: String
}

// classes 
// - reference type, creates a reference to a particular object
// - can have inheritance
class Car {
    var name: String
    
    init(name: String) {
        self.name = name
    }
    
    func drive() {
        print("\(name) is driving")
    }
    
    // method overloading
    func drive(weight: String) {
        print("\(name) weight is \(weight)kg")
    }
}


var person = Person(name: "George")
print(person.name)
person.name = "Sam"

var person2 = person
person2.name = "Alex"

person == person2

person
person2


var car = Car(name: "Tesla")
print(car.name)
car.name = "BMW"
print(car.name)

var car2 = car
car2.name = "Volvo"

var car3 = car2
car3.name = "Honda"

car3 === car2

car
car2
car3


// structs - inheritance is not possible with struct unless its protocol
struct MyObject {
    
}

// classes can do inheritance
class WhatEver: Car {
    
    // method overriding
    override func drive() {
        super.drive()
        print("Drive again")
    }
}

let me = WhatEver(name: "tesla")
me.drive()

// metho
me.drive(weight: "333")
