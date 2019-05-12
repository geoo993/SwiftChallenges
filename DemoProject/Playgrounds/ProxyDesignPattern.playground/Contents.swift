/*
 The Proxy design pattern is used to provide a surrogate or placeholder object, which references an underlying object. The Protection proxy is restricting access. In this pattern, proxy is an object that helps us to access another object. It simply delegates that object or change its behavior. Proxy pattern is popularly used in Cocoa which even has a specific NSProxy class in it. Another example is UIApperance protocol and other relevant types.
 Proxies delegate all of the real work to some other object. Each proxy method should in the end refer to a service object unless the proxy is a subclass of a service.
 The objective of the proxy pattern is to substitute an object (the subject) with another one that will control its access. The object that substitutes the subject shares the same interface, so it is transparent from the consumer's perspective. The proxy is often a small (public) object that stands in for a more complex (private) object that is activated once certain circumstances are clear. The proxy adds a level of indirection by accepting requests from a client object and passing them to the real subject as necessary.
 */
import UIKit

enum Type {
    case audi
    case bmw
}
enum Body {
    case fullbody
    case couped
}
enum Fuel {
    case petrol
    case desiel
    case electric
}
enum Transmission {
    case automatic
    case manual
    case semiautomatic
    case selfdriving
}

protocol Control {
    func drive() -> String
}
// here, we have a general interface for car and a specific AUDI class as following.
protocol Car: Control {
    var body: Body { get }
    var fuel: Fuel { get }
    var transmission: Transmission { get }
    var price: Double { get }
    var year: Int { get }
    var color: UIColor { get }
}
struct AudiR8: Car {
    var body: Body
    var fuel: Fuel
    var transmission: Transmission
    var price: Double = 150000.0
    var year: Int = 2019
    var color: UIColor
    init(body: Body, fuel: Fuel, transmission: Transmission, color: UIColor) {
        self.body = body
        self.fuel = fuel
        self.transmission = transmission
        self.color = color
    }
    func drive() -> String {
        return "driving $\(price) AUDI R8 with \nbody: \(body) \nfuel: \(fuel) \ntransmision: \(transmission)"
    }
}
struct BMW3Series: Car {
    var body: Body
    var fuel: Fuel
    var transmission: Transmission
    var price: Double = 50000.0
    var year: Int = 2018
    var color: UIColor
    init(body: Body, fuel: Fuel, transmission: Transmission, color: UIColor) {
        self.body = body
        self.fuel = fuel
        self.transmission = transmission
        self.color = color
    }
    func drive() -> String {
        return "driving $\(price) BMW 3-Series with \nbody: \(body) \nfuel: \(fuel) \ntransmision: \(transmission)"
    }
}
final class AutonomousCar: Control {
    // proxy object car
    private var car: Car!
    init(car: Car) {
        guard car.fuel == .electric && car.transmission == .selfdriving else {
            return
        }
        self.car = car
    }
    func drive() -> String {
        guard car != nil else {
            return "Access Denied. This car does not have a self-driving system."
        }
        car.drive()
        return "autonomous self-driving system is actvated"
    }
}

//usage
let bmw = BMW3Series(body: .couped, fuel: .electric, transmission: .semiautomatic, color: .blue)
print(AutonomousCar(car: bmw).drive())

let audi = BMW3Series(body: .fullbody, fuel: .electric, transmission: .selfdriving, color: .orange)
print(AutonomousCar(car: audi).drive())
