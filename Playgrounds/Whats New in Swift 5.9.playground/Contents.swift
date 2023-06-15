import UIKit
import Observation
import SwiftUI

func example(of description: String, action: () -> Void) {
    print("\n--- Example of:", description, "---")
    action()
}

// the 5.x releases still have a lot to give – simpler ways to use if and switch, macros, noncopyable types, custom actor executors, and more are all coming in Swift 5.9, making yet another mammoth release.

// MARK: - if and switch predicate
// We can use "if" and "switch" as expressions in several situations.
// This produces syntax that will be a little surprising at first, but overall it does help reduce a little extra syntax in the language.

example(of: "If and Switch") {
    // For example, we can set pass or fail on a depending on a condition like this:
    let score = 400
    let simpleResult = if score > 500 { "Pass" } else { "Fail" }
    print(simpleResult)
    
    // We could have written the above simple if condition like this:
    let ternaryResult = score > 500 ? "Pass" : "Fail"
    print(ternaryResult)
    
    // Or we could use a switch expression to get a wider range of values like this:
    
    let complexResult = switch score {
    case 0...300: "Fail"
    case 301...500: "Pass"
    case 501...800: "Merit"
    default: "Distinction"
    }
    
    print(complexResult)
    
    // We can even omit the "return" keyword in single expression functions that return a value.
    func rating(for score: Int) -> String {
        switch score {
        case 0...300: "Fail"
        case 301...500: "Pass"
        case 501...800: "Merit"
        default: "Distinction"
        }
    }
    print(rating(for: score))
}

// MARK: - Macros
// Macros allow us to create code that transforms syntax at compile time.
// Macros in something like C++ are a way to pre-process your code – to effectively perform text replacement on the code before it’s seen by the main compiler, so that you can generate code you really don’t want to write by hand.

// Swift’s macros are similar, but significantly more powerful – and thus also significantly more complex.
// They also allow us to dynamically manipulate our project’s Swift code before it’s compiled, allowing us to inject extra functionality at compile time.

// The key things to know are:

// - They are type-safe rather than simple string replacements, so you need to tell your macro exactly what data it will work with.
// - They run as external programs during the build phase, and do not live in your main app target.
// - Macros are broken down into multiple smaller types, such as ExpressionMacro to generate a single expression, AccessorMacro to add getters and setters, and ConformanceMacro to make a type conform to a protocol.
// - Macros work with your parsed source code – we can query individual parts of the code, such as the name of a property we’re manipulating or it types, or the various properties inside a struct.
// - They work inside a sandbox and must operate only on the data they are given.
// That last part is particularly important: Swift’s macros support are built around Apple’s SwiftSyntax library for understanding and manipulating source code. You must add this as a dependency for your macros.

// Let’s start with a simple macro.

//let url = #URL("https://swift.org")
//print(url.absoluteString)

// MARK: - Observable object
// Swift 5.9 introduced the macros feature, which became the heart of the SwiftUI data flow. SwiftUI became Combine-free and uses the new Observation framework now. The Observation framework provides us with the Observable protocol that we have to use to allow SwiftUI to subscribe to changes and update views.

// Previously you would have written something like this:
final class StorePublisher: ObservableObject {
    @Published var products: [String] = []
    @Published var favorites: [String] = []
    
    func fetch() async {
        try? await Task.sleep(nanoseconds: 1_000_000_000)
        products = [
            "Product 1",
            "Product 2"
        ]
    }
}

// Now wou don’t need to conform to the Observable protocol in your code.
// Instead, you mark your type with the @Observable macro, which makes that conformance to the Observable protocol for you.

/*
@Observable
final class ObservableStore {
    // We also don’t need the @Published property wrapper now because SwiftUI views automatically track the changes in the available properties of any observable type.
    var products: [String] = []
    var favorites: [String] = []
    
    func fetch() async {
        try? await Task.sleep(nanoseconds: 1_000_000_000)
        products = [
            "Product 1",
            "Product 2"
        ]
    }
}
*/

// Previously, there were a bunch of property wrappers like State, StateObject, ObservedObject, and EnvironmentObject, which you used to management state. Now it has become much more manageable.
/*
struct ProductsView: View {
    @State private var store = ObservableStore()
    
    var body: some View {
        List(store.products, id: \.self) { product in
            Text(verbatim: product)
        }
        .task {
            if store.products.isEmpty {
                await store.fetch()
            }
        }
    }
}
*/

// And the above can be used with environment object this way.

/*
struct MasterView: View {
    @State private var store = ObservableStore()
    
    var body: some View {
        Text("Hello")
            .toolbar {
                NavigationLink {
                    ProductsView2()
                } label: {
                    Text(verbatim: "Stuff")
                }
            }
            .environment(store)
        }
    
}

struct ProductsView2: View {
    @Environment(ObservableStore.self) private var store
    
    var body: some View {
        List(store.products, id: \.self) { product in
            Text(verbatim: product)
        }
        .task {
            if store.products.isEmpty {
                await store.fetch()
            }
        }
    }
}

*/
// MARK: - Noncopyable structs and enums
// The Copyable proposal introduces the concept of noncopyable types (also known as "move-only" types)
// An instance of a noncopyable type always has unique ownership, unlike normal Swift types which can be freely copied.
// This introduces the concept of structs and enums that cannot be copied, which in turn allows a single instance of a struct or enum to be shared in many places – they still ultimately have one owner, but can now be accessed in various parts of your code.
// In addition, this change introduces new syntax to suppress a requirement: ~Copyable. That means “this type cannot be copied”, and this suppression syntax is not available elsewhere at this time. For example, we can’t use ~Equatable to opt out of == for a type.

// So, we could create a new noncopyable User struct like this:
// Noncopyable types cannot conform to any protocols other than Sendable.
struct User: ~Copyable {
    var name: String
}

// Once you create a User instance, its noncopyable nature means that it’s used very differently from previous versions of Swift.

example(of: "noncopyable") {
    func createUser() {
        let newUser = User(name: "Anonymous")
        
        var userCopy = newUser // return an error
        print(userCopy.name)
    }
    
    createUser()
}

// New restrictions also apply to how we use noncopyable types as function parameters.
// it says that functions must specify whether they intend to consume the value and therefore render it invalid at the call site after the function finishes, or whether they want to borrow the value so that they can read all its data at the same time as other borrowing parts of our code.
// So, we could write one function that creates a user, and another function that borrows the user to gain read-only access to its data:
example(of: "noncopyable and borrowing") {
    func createAndGreetUser() {
        let newUser = User(name: "Anonymous")
        greet(newUser)
        print("Goodbye, \(newUser.name)")
    }
    
    func greet(_ user: borrowing User) {
        print("Hello, \(user.name)!")
    }
    
    createAndGreetUser()
}
