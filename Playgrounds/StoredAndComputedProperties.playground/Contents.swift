import Foundation

func example(of description: String, action: () -> Void) {
  print("\n--- Example of:", description, "---")
  action()
}


// Properties are any values associated with a class, struct, or enum. It can be classified into two types.

// - Stored property
// - Computed property


// Stored properties can store constant (let) or variable (var) values.

// Here is an example of a User struct.
struct User {
    // 1 -  We declare names as a variable value because it can be changed.
    var firstName: String
    var lastName: String
    // 2 - dateOfBirth isn't likely to change, so we declare it as a constant (let).
    let dateOfBirth: Date
}

// Stored property is straightforward. We store a value that describes that particular object but what about a computed property.

// A computed property is a value that can be derived from other stored value.
// It is a property that does not store a value directly, but instead provides a getter and/or a setter for accessing and modifying other properties and variables indirectly. When a computed property is accessed, the getter method is called to generate and return the computed value.
// When a computed property is set, the setter method is called to update the underlying stored value or perform some other side effect.


// One computed property that I can think of for our User struct is an age.
extension User {
    // Computed properties are useful in situations where the value of a property depends on the values of other properties or variables.
    // For example, the computed property age is created based on the dateOfBirth of the user.
    // It doesn't make sense to store an age as a stored property because it changes every second.
    var age: Int {
        let comps = Calendar.current.dateComponents([.year], from: dateOfBirth, to: .now)
        return comps.year ?? 0
    }
}

// A computed property provides a getter and an optional setter to indirectly retrieve and set other properties and values. It has the following format.
/*
var propertName: propertyType {
    get {
        // Return computed value
    }

    set {
        // Set other property
    }
}
 */

// Computed properties are declared with the "get" and "set" keywords. The "get" keyword is used to define the getter method, while the "set" keyword is used to define the setter method.
// Since the setter (set) is optional, a computed property with no setter (set) is known as a read-only computed property.

// If your computed property supports both read and write, you must declare both get and set keywords.

// In the following, we create a new computed property, fullName, which read and write to two properties, firstName and lastName.

extension User {
    var fullName: String {
        get {

            // 1 - fullName is a combination of firstName and lastName separated by a space.
            "\(firstName) \(lastName)"
        }
        set(newFullName) {

            // 2 - When we set a new value to fullName, we split it by space and assign it to firstName and lastName.
            let comps = newFullName.components(separatedBy: " ")
            firstName = comps[0]
            lastName = comps[1]
        }
    }
}


example(of: "Computed Properties") {
    var user = User(firstName: "John", lastName: "Doe", dateOfBirth: .init(timeIntervalSinceNow: -50))
    print(user.fullName)
    // John Doe

    user.fullName = "Sarun W"
    print(user.firstName)
    // Sarun

    print(user.lastName)
    // W
}
