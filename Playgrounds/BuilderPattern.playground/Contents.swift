import UIKit

func example(of description: String, action: () -> Void) {
  print("\n--- Example of:", description, "---")
  action()
}

// The builder pattern allows you to create complex objects by providing inputs step-by-step, instead of requiring all inputs upfront via an initializer.
// It is a Creational Pattern because this pattern is all about creating complex products.

// This pattern involves three main types:

// 1- The director accepts inputs and coordinates with the builder. This is usually a view controller or a helper class that’s used by a view controller.
// 2- The product is the complex object to be created. This can be either a struct or a class, depending on desired reference semantics. It’s usually a model, but it can be any type depending on your use case.
// 3- The builder accepts step-by-step inputs and handles the creation of the product. This is often a class, so it can be reused by reference.

// MARK: - When should you use it?
// - Use the builder pattern when you want to create a complex object using a series of steps.
// - This pattern works especially well when a product requires multiple inputs. The builder abstracts how these inputs are used to create the product, and it accepts them in whatever order the director wants to provide them.
// - For example, you can use this pattern to implement a “hamburger builder.” The product could be a hamburger model, which has inputs such as meat selection, toppings and sauces. The director could be an employee object, which knows how to build hamburgers, or it could be a view controller that accepts inputs from the user.
// The “hamburger builder” can thereby accept meat selection, toppings and sauces in any order and create a hamburger upon request.

// MARK: - Build Hamburger

// We will implement the “hamburger builder” example from above.
// We first need to define the product.

// 1 - We first define Hamburger, which has properties for meat, sauce and toppings. Once a hamburger is made, we are not allowed to change its components, which you codify via let properties.
struct Hamburger {
    let meat: Meat
    let sauce: Sauces
    let toppings: Toppings
}

extension Hamburger: CustomStringConvertible {
    // We also make Hamburger conform to CustomStringConvertible, so you can print it later.
    var description: String {
        return meat.rawValue + " burger"
    }
}

// 2 - We declare Meat as an enum. Each hamburger must have exactly one meat selection.
enum Meat: String {
    case beef
    case chicken
    case kitten
    case tofu
}

// 3 - We define Sauces as an OptionSet. This will allow you to combine multiple sauces together. My personal favorite is ketchup-mayonnaise-secret sauce.
struct Sauces: OptionSet {
    static let mayonnaise = Sauces(rawValue: 1 << 0)
    static let mustard = Sauces(rawValue: 1 << 1)
    static let ketchup = Sauces(rawValue: 1 << 2)
    static let secret = Sauces(rawValue: 1 << 3)
    
    let rawValue: Int
    init(rawValue: Int) {
        self.rawValue = rawValue
    }
}

// 4 - We likewise define Toppings as an OptionSet. We are gonna need more than pickles for a good burger!
struct Toppings: OptionSet {
    static let cheese = Toppings(rawValue: 1 << 0)
    static let lettuce = Toppings(rawValue: 1 << 1)
    static let pickles = Toppings(rawValue: 1 << 2)
    static let tomatoes = Toppings(rawValue: 1 << 3)
    
    let rawValue: Int
    init(rawValue: Int) {
        self.rawValue = rawValue
    }
}

// MARK: - Builder

class HamburgerBuilder {
    
    // 1 - We declare properties for meat, sauces and toppings, which exactly match the inputs for Hamburger. Unlike a Hamburger, we declare these using var to be able to change them. We also specify private(set) for each to ensure only HamburgerBuilder can set them directly.
    private(set) var meat: Meat = .beef
    private(set) var sauces: Sauces = []
    private(set) var toppings: Toppings = []
    
    // 5 - private(set) forces consumers to use the public setter methods. This allows the builder to perform validation before setting the properties.
    // For example, we will ensure a meat is available prior to setting it.
    private var soldOutMeats: [Meat] = [.kitten]
    
    // 6 - If a meat is sold out, we will throw an error whenever setMeat(_:) is called. we need to declare a custom error type for this.
    enum Error: Swift.Error {
        case soldOut
    }
    
    // 2 - Since we declared each property using private(set), you need to provide access to methods to change them. You do so via addSauces(_:), removeSauces(_:), addToppings(_:), removeToppings(_:) and setMeat(_:).
    func addSauces(_ sauce: Sauces) {
        sauces.insert(sauce)
    }
    
    func removeSauces(_ sauce: Sauces) {
        sauces.remove(sauce)
    }
    
    func addToppings(_ topping: Toppings) {
        toppings.insert(topping)
    }
    
    func removeToppings(_ topping: Toppings) {
        toppings.remove(topping)
    }

    func setMeat(_ meat: Meat) throws {
        guard isAvailable(meat) else { throw Error.soldOut }
        self.meat = meat
    }
    
    func isAvailable(_ meat: Meat) -> Bool {
        return !soldOutMeats.contains(meat)
    }
    
    // 3 - Lastly, we define build() to create the Hamburger from the selections.
    func build() -> Hamburger {
        return Hamburger(
            meat: meat,
            sauce: sauces,
            toppings: toppings
        )
    }
}

// MARK: - Director

// An Employee knows how to create two burgers: createCombo1 and createKittenSpecial.
class Employee {
    func createCombo1() throws -> Hamburger {
        let builder = HamburgerBuilder()
        try builder.setMeat(.beef)
        builder.addSauces(.secret)
        builder.addToppings([.lettuce, .tomatoes, .pickles])
        return builder.build()
    }
    
    func createKittenSpecial() throws -> Hamburger {
        let builder = HamburgerBuilder()
        try builder.setMeat(.kitten)
        builder.addSauces(.mustard)
        builder.addToppings([.lettuce, .tomatoes])
        return builder.build()
    }
}

example(of: "Builder of hamburger") {
    let burgerFlipper = Employee()
    if let combo1 = try? burgerFlipper.createCombo1() {
      print("Nom nom " + combo1.description)
    }
}

example(of: "Adding validation in builder") {
    let burgerFlipper = Employee()
    do {
        let kittenBurger = try burgerFlipper.createKittenSpecial()
        print("Nom nom nom " + kittenBurger.description)
    } catch {
        // Since kitten is sold out, you’ll see this printed to the console
        print("Sorry, no kitten burgers here... :[")
    }
}

// MARK: - What should you be careful about?
// The builder pattern works best for creating complex products that require multiple inputs using a series of steps. If your product doesn’t have several inputs or can’t be created step by step, the builder pattern may be more trouble than it’s worth.
// Instead, consider providing convenience initializers to create the product.

// MARK: - Here are its key points:
// - The builder pattern is great for creating complex objects in a step-by-step fashion. It involves three objects: the director, product and builder.
// - The director accepts inputs and coordinates with the builder; the product is the complex object that’s created; and the builder takes step-by-step inputs and creates the product.
