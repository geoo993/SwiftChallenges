import UIKit

func example(of description: String, action: () -> Void) {
  print("\n--- Example of:", description, "---")
  action()
}

// The observer pattern lets one object observe changes on another object. It is a Behavioral Patterns because Observer is about one object observing another object.
// Apple added language-level support for this pattern in Swift 5.1 with the addition of Publisher in the Combine framework.
//
// ------------------             ------------------           ------------------
// |                 |  ------->  |                 |          |                 |
// |  Subscriber     |  <------   |     Publisher   |  ----->  |       Value     |
// |_________________|            |_________________|          |_________________|
//
// This pattern involves three types:
// 1- The subscriber is the “observer” object and receives updates.
// 2- The publisher is the “observable” object and sends updates.
// 3- The value is the underlying object that’s changed.


// MARK: - When should you use it?
// - Use the observer pattern whenever you want to receive changes made on another object.
// - This pattern is often used with MVC, where the view controller has subscriber(s) and the model has publisher(s). This allows the model to communicate changes back to the view controller without needing to know anything about the view controller’s type. Thereby, different view controllers can use and observe changes on the same model type.

// 1- We import Combine, which includes the @Published annotation and Publisher & Subscriber types.
import Combine

// 2 - Next, we declare a new User class; @Published properties cannot be used on structs or any other types besides classes.
final class User {
    
    // 3 - Next, we create a var property for name and mark it as @Published. This tells Xcode to automatically generate a Publisher for this property. Note that you cannot use @Published for let properties, as by definition they cannot be changed.
    @Published var name: String
    
    // 4 - Finally, we create an initializer that sets the initial value of self.name.
    init(name: String) {
        self.name = name
    }
}

example(of: "Observer pattern") {
    // 1 - First, we create a new user named Ray.
    let user = User(name: "Ray")

    // 2 - Next, we access the publisher for broadcasting changes to the user’s name via user.$name. This returns an object of type Published<String>.Publisher. This object is what can be listened to for updates.
    let publisher = user.$name

    // 3 - Next, we create a subscriber by calling sink on the publisher. This takes a closure for which is called for the initial value and anytime the value changes. By default, sink returns a type of AnyCancellable. However, you explicitly declare this type as AnyCancellable? to make it optional as you’ll nil it out later.
    var subscriber: AnyCancellable? = publisher.sink() {
        print("User's name is \($0)")
    }

    // 4 - Finally, you change the user’s name to Vicki.
    user.name = "Vicki"
    
    // 5 - By setting the subscriber to nil, it will no longer receive updates from the publisher. To prove this, you change the user’s name a final time, but you won’t see any new output in the console.
    subscriber = nil
    user.name = "Ray has left the building" // nothing will be printed since we stopped subscribing
}

// MARK: -  What should you be careful about?
// Before you implement the observer pattern, define what you expect to change and under which conditions. If you can’t identify a reason for an object or property to change, you’re likely better off not declaring it as var or @Published, and instead, making it a let property.
// A unique identifier, for example, isn’t useful as an published property since by definition it should never change.

// MARK: -  Here are its key points:
// - The observer pattern lets one object observe changes on another object. It involves three types: the subscriber, publisher and value.
// - The subscriber is the observer; the publisher is the observable object; and the value is the object that’s being changed.
// - Swift 5.1 makes it easy to implement the observer pattern using @Published properties.
