//: [Previous](@previous)

import Foundation

// - function notation

// func notation | func name | func parameters | no return type
func calculate(a value1: Int, b value2: Int) {
    // in a fuction you can declare as many values you want, they stay visible within the fuction
    let value = value1 + value2
    print(value)
}

//print(value)

// - function return type
// - function parameters
// func notation | func name | func parameters | with return type
func result(_ value1: Int, _ b: Int) -> Int {
    let value = value1 + b
    return value// the return value is require when theres a return type
}

let value = result(2, 4)

// function usage

calculate(a: 3, b: 4)

class Person {
    let name: String
    var calculateIncome: (Int, Int) -> Int
    lazy var something: Int = calculateIncome(4, 10)
    
    // dependency injection of function
    init(name: String, calculateIncome: @escaping (Int, Int) -> Int) {
        self.name = name
        self.calculateIncome = calculateIncome
    }
    
    func doCaluclation() {
        let stuff = calculateIncome(4, 5)
        print(stuff)
        
        print("something before", something)
        something = 40
        print("something after", something)
    }
}

let person = Person(name: "George", calculateIncome: result)
person.doCaluclation()
person.calculation2()

extension Person {
    
    // computed property
    var something2: String {
        name + " Profile"
    }
    
    func calculation2() {
        let stuff = calculateIncome(4, 5)
        print(stuff)
    }
}

// high order functions
// - map
// - reduce
// - filter
// - compactMap
// - flatMap

let names = ["George", "Alex", "Tom"]

