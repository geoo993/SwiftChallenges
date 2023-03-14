import Foundation

func example(of description: String, action: () -> Void) {
  print("\n--- Example of:", description, "---")
  action()
}

//- Value and reference types
example(of: "Value and reference types") {
    // Reference Types
    // Reference types consist of shared instances that can be passed around and referenced by multiple variables. This is best illustrated with an example.

    class Dog {
      var wasFed = false
    }

    //The above class represents a pet dog and whether or not the dog has been fed.

    let dog = Dog() // Create a new instance of your Dog class. This simply points to a location in memory that stores dog.

    let puppy = dog // here we addd another object to hold a reference to the same dog. Because dog is a reference to a memory address, puppy points to the exact same data in memory.

    puppy.wasFed = true

    print("Dog was fed", dog.wasFed)            // true
    print("Puppy was fed", puppy.wasFed)        // true
    
    
    // Value Types
    // Value types are referenced completely differently than reference types.

    var a = 42
    var b = a
    b += 1
    
    // What would you expect a and b to equal?
    // Clearly, a equals 42 and b equals 43. If you’d declared them as reference types instead, both a and b would equal 43 since both would point to the same memory address.
    
    print(a)    // 42
    print(b)    // 43
    
    // What Type Does Swift Favor?
    // It may surprise you that the Swift standard library uses value types almost exclusively. The results of a quick search through the Swift Standard Library for public instances of enum, struct, and class in Swift 1.2, 2.0, and 3.0 show a bias in the direction of value types:

    // Swift 1.2:
    // - struct: 81
    // - enum: 8
    // - class: 3
    
    //Swift 2.0:
    // - struct: 87
    // - enum: 8
    // - class: 4
    
    //Swift 3.0:
    // - struct: 124
    // - enum: 19
    // - class: 3
    
    // This includes types like String, Array, and Dictionary, which are all implemented as structs.
}

example(of: "Arc reference counting and memory leak") {

//An Object’s Lifetime
// The lifetime of a Swift object consists of five stages:

// 1- Allocation: Takes memory from a stack or heap.
// 2- Initialization: init code runs.
// 3- Usage.
// 4- Deinitialization: deinit code runs.
// 5- Deallocation: Returns memory to a stack or heap.

class User {
  let name: String
  
  init(name: String) {
    self.name = name
    print("User \(name) was initialized")
  }

  deinit {
    print("Deallocating user named: \(name)")
  }
}

class Book {
    var author: User?
}

let book = Book()
book.author = User(name: "The Run")

let cofounder = book.author // here reference count of book is 1, this is also a memory leak since cofounder now hold reference to user
    
// Reference counts, also known as usage counts, determine when an object is no longer needed. This count indicates how many “things” reference the object. The object is no longer needed when its usage count reaches zero and no clients of the object remain. The object then deinitializes and deallocates.

book.author = nil

}

//- weak and strong references
example(of: "Weak and strong references") {

// Strong vs Weak vs Unowned – Quick Facts
// - Usually, when a property is being created, the reference is strong unless they are declared weak or unowned.
// - With the property labelled as weak, it will not increment the reference count
// - An unowned reference falls in between, they are neither strong nor or type optional. Compiler will assume that object is not deallocated as the reference itself remain allocated.
    
    class Person {
        let name: String
        init(name: String) {
            self.name = name
            print("\(name) is being initialized")
        }
        var gadget: Gadget?
        deinit {
            print("\(name) is being deinitialized")
        }
    }
     
    class Gadget {
        let model: String
        init(model: String) {
            self.model = model
            print("\(model) is being initialized")
        }
        var owner: Person?
        deinit {
            print("\(model) is being deinitialized")
        }
    }

    // Strong reference
    // Let’s take a look at the following example. We have a variable of Person type with the reference of “Kelvin” and a variable of Gadget type with the reference of “iPhone 8 Plus”.

    var kelvin: Person?
    var iphone: Gadget?

    kelvin = Person(name: "Kelvin")
    iphone = Gadget(model: "iPhone 8 Plus")
    
    kelvin?.gadget = iphone // strong reference
    iphone?.owner = kelvin // strong reference
    
    kelvin = nil
    iphone = nil
    
    
    // Weak reference
    // Weak reference are always declared as optional types because the value of the variable can be set to nil.
    class Device {
        let model: String
        init(model: String) {
            self.model = model
            print("\n\(model) is being initialized")
        }
        weak var owner: Person?
        deinit {
            print("\(model) is being deinitialized")
        }
    }
    
    var sam: Person?
    var iPad: Device?

    sam = Person(name: "Sam")
    iPad = Device(model: "iPad Air")
    
    iPad?.owner = sam // strong reference
    
    sam = nil
    iphone = nil
    
    
    // unowned
    // An unowned reference is very similar to a weak reference that it can be used to resolve the strong reference cycle. The big difference is that an unowned reference always have a value. ARC will not set unowned reference’s value to nil.
    class Tech {
        let model: String
        unowned var owner: Person
            
        init(model: String, owner: Person) {
            self.model = model
            self.owner = owner
            print("\n\(model) is being initialized")
        }
        
        deinit {
            print("\(model) is being deinitialized")
        }
    }
    var denis: Person?
    var tech: Tech?
    
    denis = Person(name: "Denis") // if you remove this you will get error
    tech = Tech(model: "Tech Device", owner: denis!)
    
    denis = nil
    tech = nil
}
