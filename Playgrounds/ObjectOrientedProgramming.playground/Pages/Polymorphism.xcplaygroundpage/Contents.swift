import Foundation

/*
 
 Polymorphism: is about provisioning a single interface to entities of different types. 
 It is one of the most important aspects of OOP whereby it demostrates the different behaviors of objects. Objects of the same class can behave independently within the same interface.
 
 It is one of the most powerful concepts in software engineering that lets you define different behaviours for different objects while you are still using a shared interface among them.
 
 Polymorphism is derived from the ability to inherit object where sub/child classes can inherit from base/parent classes and be used wherever based classes are required, then calling the parent function will perform the child’s overridden one. This approach is called called dynamic dispatch, which is the process of selecting which implementation of a polymorphic operation (method or function) to call at run time.
 
    1) Dynamic dispatch of polymorphism is a big part of the Liskov substitution principle — where we are able to use inherited type wherever base type can be used.
    2) Protocols: are one of the most powerful Swift concepts making the programming even easier than before. Protocols describe methods, properties and other requirements that are needed for a specific task.
    3) Protocols are also allows us to perform polymorphism without inheritance. you don’t need to have any inheritance (although you can have inheritance for your Protocols). Any object can conform to multiple Protocols at the same time, which means it can hold different behaviours at the same time without any additional inheritance.
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
        super.play(instrument: instrument) // Liskov subtitution principle
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

// Dynamic dispatching, calling alex first then the parent
anyPerson?.play(instrument: "Violin")


// Protocol inheritance and dynamic dispatching
protocol People {
    var name: String { get }
    var age: Int { get }
    func play(instrument: String)
}

extension People {
    // shared implementation
    func something() {
        print("name: \(name), and age: \(age)")
    }
}

// conformance to protocol
struct Dad: People {
    let name: String
    let age: Int
    
    init(name: String, age: Int) {
        self.name = name
        self.age = age
    }
    
    func play(instrument: String) {
        print("instrument", instrument)
        print("dad happened")
    }
}

struct DummyDad: People {
    var name: String = "dummy name"
    var age: Int = 673
    
    func play(instrument: String) {
        print("dummy instrument", instrument)
        print("dummy dad happened")
    }
}

// Sub-typing
var dad = Dad(name: "Alex", age: 2)
var dummyDad = DummyDad(name: "Alex", age: 2)
var anyPeople: People? = dummyDad

// Dynamic dispatching, calling dad only
anyPeople?.play(instrument: "Guitar")



// Write a function to add two numbers and check if the sum is even or odd.
