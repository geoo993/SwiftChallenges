import Foundation

func example(of description: String, action: () -> Void) {
  print("\n--- Example of:", description, "---")
  action()
}

// The prototype pattern is a creational pattern that allows an object to copy itself.
// It involves two types:
// - A copying protocol that declares copy methods.
// - A prototype class that conforms to the copying protocol.

// A shallow copy creates a new object instance, but doesn’t copy its properties.
// Any properties that are reference types still point to the same original objects.
// For example, whenever you copy a Swift Array, which is a struct and thereby happens automatically on assignment, a new array instance is created but its elements aren’t duplicated.

// A deep copy creates a new object instance and duplicates each property as well.
// For example, if you deep copy an Array, each of its elements are copied too. Swift doesn’t provide a deep copy method on Array by default, so we can create one here!


// MARK: - When should you use it?
// - Use this pattern to enable an object to copy itself.
// - For example, Foundation defines the NSCopying protocol. However, this protocol was designed for Objective-C, and unfortunately, it doesn’t work that well in Swift. You can still use it, but you’ll wind up writing more boilerplate code yourself.
// - Instead, you can implement your own Copying protocol. We learn about the prototype pattern in depth this way, and your resulting implementation will be more Swifty too!

// MARK: - Deep copy following Prototype pattern
// Lets create a Copying protocol and a Monster class that conforms to that protocol

protocol Copying: AnyObject {
    // 1 - We first declare a required initializer, init(_ prototype: Self).
    // This is called a copy initializer as its purpose is to create a new class instance using an existing instance.
    init(_ prototype: Self)
}

extension Copying {
    // 2 - We normally won’t call the copy initializer directly. Instead, we will simply call copy() on a conforming Copying class instance that you want to copy.
    // Since we declared the copy initializer within the protocol itself, copy() is extremely simple.
    // It determines the current type by calling type(of: self), and it then calls the copy initializer, passing in the self instance.
    // Thereby, even if you create a subclass of a type that conforms to Copying, copy() will function correctly.
    func copy() -> Self {
        return type(of: self).init(self)
    }
}

// 1 - This declares a simple Monster type, which conforms to Copying and has properties for health and level.
class Monster: Copying {
    var health: Int
    var level: Int
    
    init(health: Int, level: Int) {
        self.health = health
        self.level = level
    }
    
    // 2 - In order to satisfy Copying, we must declare init(_ prototype:) as required. However, we're allowed to mark this as convenience and call another designated initializer, which is exactly what we do.
    required convenience init(_ monster: Monster) {
        self.init(health: monster.health, level: monster.level)
    }
}

// 1 - In a real app, we would likely have Monster subclasses as well, which would add additional properties and functionality. Here, we declare an EyeballMonster, which adds a terrifying new property, redness. Oooh, it’s so red and icky! Don’t touch that eyeball!
class EyeballMonster: Monster {
    var redness = 0
    
    // 2 - Since we added a new property, we also need to set its value upon initialization. To do so, you create a new designated initializer: init(health:level:redness:).
    init(health: Int, level: Int, redness: Int) {
        self.redness = redness
        super.init(health: health, level: level)
    }
    
    // 3 - Since we created a new initializer, we must also provide all other required initializers.
    // Note that you need to implement this with the general type, Monster, and then cast it to an EyeballMonster. That’s because specializing to EyeballMonster would mean that it couldn’t take another subclass of Monster, which would break the condition that this is overriding the required initializer from Monster.
    @available(*, unavailable, message: "Call copy() instead") // This indicates we should not allow calls to init(_ monster:) on any subclasses of Monster. Instead, we should always call copy().
    required convenience init(_ prototype: Monster) {
        let eyeballMonster = prototype as? EyeballMonster
        self.init(
            health: eyeballMonster?.health ?? prototype.health,
            level: eyeballMonster?.level ?? prototype.level,
            redness: eyeballMonster?.redness ?? 0
        )
    }
}

example(of: "Deep Copy") {
    let monster = Monster(health: 700, level: 37)
    let monster2 = monster.copy()
    print("Watch out! That monster's level is \(monster2.level)!")
    
    // This here proves that we can indeed create a copy of EyeBallMonster
    let eyeball = EyeballMonster(
        health: 3002,
        level: 60,
        redness: 999
    )
    let eyeball2 = eyeball.copy()
    print("Eww! Its eyeball redness is \(eyeball2.redness)!")
    
    // What happens if you try to create an EyeballMonster from a Monster?
//    let eyeballMonster3 = EyeballMonster(monster) // well it does a fake copy
}

// MARK: - What should you be careful about?
// - By default it’s possible to pass a superclass instance to a subclass’s copy initializer. This may not be a problem if a subclass can be fully initialized from a superclass instance. However, if the subclass adds any new properties, it may not be possible to initialize it from a superclass instance.
// - To mitigate this issue, you can mark the subclass copy initializer as “unavailable.” In response, the compiler will refuse to compile any direct calls to this method.
// - It’s still possible to call the method indirectly, like copy() does. However, this safeguard should be “good enough” for most use cases.
// - If this doesn’t prevent issues for our use case, we will need to consider how exactly you want to handle it. For example, we may print an error message to the console and crash, or you may handle it by providing default values instead.

// MARK: - Here are its key points:
// - The prototype pattern enables an object to copy itself. It involves two types: a copying protocol and a prototype.
// - The copying protocol declares copy methods, and the prototype conforms to the protocol.
// - Foundation provides an NSCopying protocol, but it doesn’t work well in Swift. It’s easy to roll your own Copying protocol, which eliminates reliance on Foundation or any other framework entirely.
// - The key to creating a Copying protocol is creating a copy initializer with the form init(_ prototype:).
