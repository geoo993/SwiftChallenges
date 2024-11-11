import Foundation
/*
 
 Inheritance: This allows creating new objects based on existing objects, inheriting properties and behaviour. It is a process by which you inherit the properties of your parent. Technically, Inheritance is a process by which a child class inherits the properties of its parent class.
 Inheritance in Swift not only allows using existing objects to create new, it is also subtyping mechanism.
 Subtyping allows using inherited type where the basetype can be use. substituting with subtype is a concept related to the Liskov Substitution Principle which states that basetypes should be substitutable with object of their subtypes without breaking any functionality from a consumer point of view.
 Other parts of inheritance include:
    1) Method Overriding: you can override methods in order to provide custom behaviour. This is a process where a methods in the base-class and the other in the sub-class use the override keyword before the method declaration to take over the method of the base class. you can also use the super keyword to call any method from the superclass.
    2) Method Overloading: is the process by which a class has two or more methods with same name but with different parameters or with different arguments.
 */

class Person {
    let name: String
    let age: Int
    
    init(name: String, age: Int) {
        self.name = name
        self.age = age
    }
    
    func play(instrument: String) {
        print("instrument:", instrument)
    }
}

// Inheritance
class Alex: Person {
    
    // Overriding
    override func play(instrument: String) {
        super.play(instrument: instrument)
        print("Alex happened")
    }
    
    // Overloading
    func play(gameName: String) {
        print("game:", gameName)
    }
}

// Sub-typing
var alex = Alex(name: "yes", age: 2)
var anyPerson: Person? = alex
anyPerson?.play(instrument: "Violin")
