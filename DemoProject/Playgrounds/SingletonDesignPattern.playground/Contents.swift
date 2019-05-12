import Foundation


// Singleton is very popular in Cocoa. We can find different use cases. The following are two examples.

let defaultNotification = NotificationCenter.default
let standard = UserDefaults.standard

// The singleton pattern ensures that only one object of a particular class is ever created. All further references to objects of the singleton class refer to the same underlying instance.
// There are very few applications, but DO NOT overuse this pattern!

// a singleton can be
class Car {
    static let sharedInstance = Car()
}


// a complex singleton can be
// We can guarantee the codes only run once using the ‘static’ keywords. The static property will be lazily initialized once and only once.
// Then we make the initialsation private so that we are the only ones that can initialise this class.
// Lastly the singleton is a constant meaning that it is immutable and cannot be changed which means there will only be one intsance and the same instance throughout the app lifetime.
// We can also hide functions/implementations that we do not want our clients to see
class Truck {
    static let sharedInstance: Truck = {
        let instance = Truck()
        return instance
    }()
    
    private init() {
        // Private initialization to ensure just one instance is created.
    }
    
    public func canAccessThis() {
        print("can see")
    }
    
    private func doNotAllowAccessToThis() {
        print("cannot see")
    }
}

let truck = Truck.sharedInstance
truck.canAccessThis()
