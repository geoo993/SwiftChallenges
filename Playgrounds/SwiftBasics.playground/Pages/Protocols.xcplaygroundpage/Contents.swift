//: [Previous](@previous)

import Foundation

var greeting = "Hello, playground"

//: [Next](@next)

// protocol inheritance
protocol AbtractionStuff {
    var name: String { get set }
}

struct ObjectOne: AbtractionStuff {
    var name: String = "dgag"
}

struct ObjectTwo: AbtractionStuff {
    var name: String = "hdh"
}
