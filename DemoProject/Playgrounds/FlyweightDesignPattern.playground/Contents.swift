/*
 The Flyweight design pattern is used to minimize memory usage or computational expenses by sharing as much as possible with other similar objects. Flyweight is all about sharing. It holds a pool to store objects. The client will reuse existing objects in the pool.
 Again, it is a memory-saving pattern used when there are many objects to be instantiated that share similarities. he goal of the flyweight pattern is to share reusable objects instead of needlessly duplicating them, allowing our codebase to be lightweight.
 We reuse objects by first dividing the object into two parts: extrinsic and intrinsic state. Extrinsic refers to the part of the object that changes based on context, and therefore cannot be shared. For example, a object maybe colored, or change in dimensions or size. This sort of data is not reusable, since we don’t want all instances of a given object to share these attributes.
 On the other hand, intrinsic data represents what remains the same across characters. An example of intrinsic data would be the shape of a given object, just like all letter characters within a text all are have a particular rendered shape which does not change from one occurrence to the next.
 To summarize, Intrinsic data is immutable, identical, context-free, and as a result, reusable. whilst Extrinsic data is mutable and contextual, and as a result, not reusable across all cases. It is through this separation of intrinsic and extrinsic data that we are able to identify what we can reuse in our objects.
 */
import UIKit
enum Type {
    case audi
    case bmw
}

// here, we have a general interface for car and a specific AUDI class as following.
protocol Car {
    var price: Double { get }
    var year: Int { get }
    var color: UIColor { get }
    func drive()
}
struct AudiR8: Car {
    var price: Double = 150000.0
    var year: Int = 2019
    var color: UIColor
    init(color: UIColor) {
        self.color = color
    }
    func drive() {
        print("driving an AUDI R8")
    }
}

struct BMW3Series: Car {
    var price: Double = 50000.0
    var year: Int = 2018
    var color: UIColor
    init(color: UIColor) {
        self.color = color
    }
    func drive() {
        print("driving a BMW 3-Series")
    }
}

// we also have built our German factory which produces AUDI.
// Generally, we have AUDI in different colors in stock.
// When there are orders, we look up in our stock first and reuse it.
class GermanFactory {
    // making cars Flyweight by each having their own color
    var cars: [UIColor: Car] = [UIColor: Car]()
    func getCar(type: Type, color: UIColor) -> Car {
        if let car = cars[color] {
            return car
        } else {
            switch type {
            case .audi:
                let car = AudiR8(color: color)
                cars[color] = car
                return car
            case .bmw:
                let car = BMW3Series(color: color)
                cars[color] = car
                return car
            }
        }
    }
}

// Let’s get cars from factory.
let factory = GermanFactory()
let redBmw = factory.getCar(type: .bmw, color: .red)
redBmw.drive()
