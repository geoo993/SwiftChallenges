
/*
 The Strategy Design pattern is used to create an interchangeable family of algorithms from which the required process is chosen at run-time. Essentially,  it is a pattern that defines a family of algorithms, each one of them written in a separate class allowing us to select which algorithm to execute at runtime. Instead of implementing a single algorithm directly, code receives run-time instructions as to which in a family of algorithms to use. To simply put it, it encapsulates algorithms in classes, making them reusable and interchangeable at runtime.
 There are many cases when we can use this pattern and they are.
 When there are different ways to do the same thing: when you need to do the same thing in your code by different ways, it’s a clear example that you could use it.
 When you want an alternative to inheritance: If you need to extend the functionality of a class and for doing this, you need to create a new class who inherits from it.
 When you want an alternative to if/else blocks: Sometimes, if you look at a class, you can see that it has too much if/else or switch blocks, I mean, conditional blocks. This is a sign that this class has more responsibilities than it should. Using a Strategy pattern would help you distribute them.
 To implement a strategy, pattern you need to define the following three things:
 What: A protocol that defines the action that we want to encapsulate. In our example, the action would be convert number to a unit of length.
 Who: An object who contains an object who conforms the strategy. In our example, it could be an object who is using the convert to unit function.
 How: Specific implementations of the strategy. Each implementation is different. In our example, we would have four strategies of converting to units of length, one for each style (millimeter, centimeter, meter, kilometer).
 */
enum Unit {
    case millimeter
    case centimeter
    case meter
    case kilometer
}

// What
protocol Measument {
    func convert(number: Double, unit: Unit)
}

// Who
struct UnitLength {
    var measument: Measument
    var number: Double
    init(number: Double, measument: Measument) {
        self.number = number
        self.measument = measument
    }
    func convert(to unit: Unit) {
        self.measument.convert(number: number, unit: unit)
    }
}

// How
struct MilliMeterStrategy: Measument {
    func convert(number: Double, unit: Unit) {
        switch unit {
        case .millimeter: print("\(Double(number))")
        case .centimeter: print("\(Double(number / 100))")
        case .meter: print("\(Double(number / 1000))")
        case .kilometer: print("\(Double(number / 1000000))")
        }
    }
}

struct CentiMeterStrategy: Measument {
    func convert(number: Double, unit: Unit) {
        switch unit {
        case .millimeter: print("\(Double(number * 10))")
        case .centimeter: print("\(Double(number))")
        case .meter: print("\(Double(number / 100))")
        case .kilometer: print("\(Double(number / 100000))")
        }
    }
}
struct MeterStrategy: Measument {
    func convert(number: Double, unit: Unit) {
        switch unit {
        case .millimeter: print("\(Double(number * 1000))")
        case .centimeter: print("\(Double(number * 100))")
        case .meter: print("\(Double(number))")
        case .kilometer: print("\(Double(number / 1000))")
        }
    }
}
struct KiloMetersStrategy: Measument {
    func convert(number: Double, unit: Unit) {
        switch unit {
        case .millimeter: print("\(Double(number * 1000000))")
        case .centimeter: print("\(Double(number * 100000))")
        case .meter: print("\(Double(number * 1000))")
        case .kilometer: print("\(Double(number))")
        }
    }
}


var length = UnitLength(number: 30, measument: MilliMeterStrategy())
length.convert(to: .kilometer)
length.convert(to: .meter)
