import UIKit

public class SomePublicClass {}
internal class SomeInternalClass {}
fileprivate class SomeFilePrivateClass {}
private class SomePrivateClass {}

public var somePublicVariable = 0
internal let someInternalConstant = 0
fileprivate func someFilePrivateFunction() {}
private func somePrivateFunction() {}

class SomeInternalClassByDefault {}              // implicitly internal
let someInternalConstantByDefault = 0            // implicitly internal



// Value type vs Reference types

// Value type example
struct S { var data: Int = -1 }
var a = S()
var b = a                        // a is copied to b
a.data = 42                        // Changes a, not b
print("\(a.data), \(b.data)")    // prints "42, -1"

// Reference type example
class C { var data: Int = -1 }
var x = C()
var y = x                        // x is copied to y
x.data = 42                        // changes the instance referred to by x (and y)
print("\(x.data), \(y.data)")    // prints "42, 42"


// Value semantics
struct Position {
    var x: Int
    var y: Int
}
var p1 = Position(x: 1, y: 2)
var p2 = p1
p1.x = 2
print("\(p1.x), \(p2.x)")

let p3 = Position(x: 3, y: 4)
//p3.x = 5 // compiler throws error

struct AnotherPosition {
    let x: Double
    let y: Double
}
var p4 = AnotherPosition(x: 4, y: 6)
//p4.x = 5 // compiler error
p4 = AnotherPosition(x: 3, y: 1) // valid statement


// protocols
protocol Protocol: AnyObject {
    func protocolFunction()
}

extension Protocol {
    func protocolFunction() {
        print("default function")
    }
}

class Class: Protocol {
    func classFunction() {
        protocolFunction()
    }
}

class Subclass: Class {
    override func classFunction() {
        protocolFunction()
    }
    func protocolFunction() {
        print("subclass function")
    }
}

let sub = Subclass()
sub.protocolFunction()
sub.classFunction()
