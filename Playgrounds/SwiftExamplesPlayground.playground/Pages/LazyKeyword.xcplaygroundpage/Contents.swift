import Foundation

class MyClass {
    lazy var myProperty: Int = {
        // This closure is only executed when `myProperty` is first accessed
        print("Calculating initial value of myProperty")
        return 42
    }()
}

let myObject = MyClass()

// The closure to initialize `myProperty` has not been executed yet
print("Before accessing myProperty")

// Accessing `myProperty` for the first time triggers the initialization closure
print("myProperty = \(myObject.myProperty)")

// The closure is not executed again on subsequent access to `myProperty`
print("Accessing myProperty again")
print("myProperty = \(myObject.myProperty)")
