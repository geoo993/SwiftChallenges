import Foundation

// Here, we are inheriting the Dog subclass from the Animal superclass.

// define a superclass
class Animal {
    // properties and method of the parent class
    var name: String = ""
    private let age: Int
    
    init(age: Int) {
        self.age = age
    }

    func eat() {
        print("I can eat")
    }
    
    func jump() {
        print("I am jumping")
    }
    
    func sit() {
        print("I am sitting")
    }
    
    func whatsYourAge() {
        print("\(name) age is \(age)")
    }
    
    // Preventing Property Override, this prevents the property from being overridden.
    final func run() {
        print("running to target")
    }
}

// inheritance - inherit from Animal
class Dog: Animal {

    // new method in subclass
    func display() {
        // access name property of superclass
        print("\nMy name is ", name);
    }
    
    // Method Overriding in Swift Inheritance
    override func jump() {
        print("\(name) jumped")
    }
    
    // Super Keyword in Swift Inheritance
    override func sit() {
        super.sit()// Super keyword, allow us to access the superclass method from the subclass,
        print("still sitting")
    }
}

// create an object of the subclass
var labrador = Dog(age: 5)

// access superclass property and method
labrador.name = "Rohu"
labrador.eat()

// call subclass method
labrador.display()
labrador.sit()
labrador.whatsYourAge()

let chiwawa = Dog(age: 6)
chiwawa.name = "Chis"
chiwawa.display()

// call oveeriding method jump()
chiwawa.jump()
chiwawa.whatsYourAge()


// Sub-typing
class Cat: Animal {
    func display() {
        // access name property of superclass
        print("\nMy name is ", name);
    }
}

var meow = Cat(age: 2)
meow.name = "Meow"
meow.display()
meow.run()

var animal: Animal = meow
animal.whatsYourAge()
