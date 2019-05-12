// The decorator pattern is used to extend or alter the functionality of objects at run- time by wrapping them in an object of a decorator class. This provides a flexible alternative to using inheritance to modify behaviour.
// Decorator is a structural pattern to add new functions to class or instance at runtime. Compared to inheritance, it has more advantages in flexibility and scalability.
// Among iOS app patterns, there also is the one called Decorator. It adds the necessary behavior and responsibilities to the object without modifying its code. It can be useful when, for example, we use third-party libraries and don’t have access to the source code. In Swift, there are two common implementations of this pattern: extensions and delegation.
// The Decorator pattern is a structural design pattern that allows you to dynamically attach new functionalities to an object by wrapping them in useful wrappers.
// No wonder this design pattern is also called the Wrapper design pattern. This name describes more precisely the core idea behind this pattern: you place a target object inside another wrapper object that triggers the basic behavior of the target object and adds its own behavior to the result.
// Both objects share the same interface, so it doesn’t matter for a user which of the objects they interact with − clean or wrapped. You can use several wrappers simultaneously and get the combined behavior of all these wrappers.
// You should use the Decorator design pattern
// - when you want to add responsibilities to objects dynamically and conceal those objects from the code that uses them;
// - when it’s impossible to extend responsibilities of an object through inheritance.

enum Unit {
    case inche
    case feet
    case yard
    case micrometer
    case millimeter
    case centimeter
    case meter
    case kilometer
    case mile
}
protocol Measurment {
    var length: Double { get }
    var pointA: Double { get set }
    var pointB: Double { get set }
    mutating func measure(from pointA: Double, to pointB: Double)
}
protocol Converter {
    var unit: Unit { get set }
    mutating func convert(to unit: Unit)
}

typealias RulerDecorator = Measurment & Converter

struct Ruler: RulerDecorator {
    var unit: Unit
    var pointA: Double
    var pointB: Double
    let diamentions: (Unit, Double) = (Unit.centimeter, 32.0)
    init() {
        self.unit = diamentions.0
        self.pointA = 0
        self.pointB = diamentions.1
    }
    mutating func measure(from pointA: Double, to pointB: Double) {
        self.pointA = pointA > pointB ? pointB : pointA
        self.pointB = pointB > diamentions.1 ? diamentions.1 : pointB
    }
    mutating func convert(to unit: Unit) {
        self.unit = unit
    }
    
}

extension Ruler {
    var length: Double {
        let distance = self.pointB - self.pointA
        switch self.unit {
        case .micrometer:
            return distance * 10000
        case .millimeter:
            return distance * 10
        case .centimeter:
            return distance
        case .meter:
            return distance / 100
        case .kilometer:
            return distance / 1000
        case .mile:
            return distance / 160934.4
        case .yard:
            return distance / 91.44
        case .feet:
            return distance / 30.48
        case .inche:
            return distance / 2.54
        }
    }
}

var ruler = Ruler()
ruler.measure(from: 0, to: 23)
print(ruler.length)
ruler.convert(to: .kilometer)
print(ruler.length)
ruler.convert(to: .mile)
print(ruler.length)
ruler.convert(to: .micrometer)
print(ruler.length)
ruler.measure(from: 2, to: 27)
print(ruler.length)
