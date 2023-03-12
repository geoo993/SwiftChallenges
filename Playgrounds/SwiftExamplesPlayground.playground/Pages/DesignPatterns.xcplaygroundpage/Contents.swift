import Foundation
import UIKit

func example(of description: String, action: () -> Void) {
  print("\n--- Example of:", description, "---")
  action()
}


//- Singleton

/// The Singleton class defines the `shared` field that lets clients access the
/// unique singleton instance.
class Singleton {
    
    /// The static field that controls the access to the singleton instance.
    ///
    /// This implementation let you extend the Singleton class while keeping
    /// just one instance of each subclass around.
    static var shared: Singleton = {
        let instance = Singleton()
        // ... configure the instance
        // ...
        return instance
    }()
    
    /// The Singleton's initializer should always be private to prevent direct
    /// construction calls with the `new` operator.
    private init() {}
    
    /// Finally, any singleton should define some business logic, which can be
    /// executed on its instance.
    func someBusinessLogic() -> String {
        // ...
        return "Result of the 'someBusinessLogic' call"
    }
}

example(of: "Singleton") {
    let instance1 = Singleton.shared
    let instance2 = Singleton.shared
    
    if (instance1 === instance2) {
        print("Singleton works, both variables contain the same instance.")
    } else {
        print("Singleton failed, variables contain different instances.")
    }
}

//- Builder

class URLBuilder {

    private var components: URLComponents

    init() {
        self.components = URLComponents()
    }

    func set(scheme: String) -> URLBuilder {
        self.components.scheme = scheme
        return self
    }

    func set(host: String) -> URLBuilder {
        self.components.host = host
        return self
    }

    func set(port: Int) -> URLBuilder {
        self.components.port = port
        return self
    }

    func set(path: String) -> URLBuilder {
        var path = path
        if !path.hasPrefix("/") {
            path = "/" + path
        }
        self.components.path = path
        return self
    }

    func addQueryItem(name: String, value: String) -> URLBuilder  {
        if self.components.queryItems == nil {
            self.components.queryItems = []
        }
        self.components.queryItems?.append(URLQueryItem(name: name, value: value))
        return self
    }

    func build() -> URL? {
        return self.components.url
    }
}

example(of: "Builder") {
    let url = URLBuilder()
        .set(scheme: "https")
        .set(host: "www.samclub.com")
        .set(path: "api/v1")
        .addQueryItem(name: "sort", value: "name")
        .addQueryItem(name: "order", value: "asc")
        .build()
    print(url?.absoluteString)
}



//- Factory
protocol Animal {
    func speak() -> String
}

class Dog: Animal {
    func speak() -> String {
        return "Woof!"
    }
}

class Cat: Animal {
    func speak() -> String {
        return "Meow!"
    }
}

class AnimalFactory {
    static func createAnimal(type: String) -> Animal? {
        switch type {
        case "dog":
            return Dog()
        case "cat":
            return Cat()
        default:
            return nil
        }
    }
}

example(of: "Factory") {
    if let animal = AnimalFactory.createAnimal(type: "dog") {
        print(animal.speak())
    }
}

//- Facade
class Engine {
    func produceEngine() -> String {
        "produce engine"
    }
    
    func action() -> String {
        "Engine: Broom!\n"
    }
}
class Body {
    func produceBody() -> String {
        "produce body"
    }
    
    func action() -> String {
        "Body: Go!\n"
    }
}
class Accessories {
    func produceAccessories() -> String {
        "produce accessories"
    }
    
    func action() -> String {
        "Accessories: Fire!\n"
    }
}

// complex system
class Facade {

    private let engine: Engine
    private let body: Body
    private let accessories: Accessories

    init(
        engine: Engine = Engine(),
        body: Body = Body(),
        accessories: Accessories = Accessories()
    ) {
        self.engine = engine
        self.body = body
        self.accessories = accessories
    }

    func operation() -> String {
        var result = "Facade initializes systems:"
        result += " " + engine.produceEngine()
        result += " " + body.produceBody()
        result += " " + accessories.produceAccessories()
        result += "\n" + "Facade orders subsystems to perform the action:\n"
        result += " " + engine.action()
        result += " " + body.action()
        result += " " + accessories.action()
        return result
    }
}

example(of: "Facade") {
    let engine = Engine()
    let body = Body()
    let accessories = Accessories()
    let facade = Facade(engine: engine, body: body, accessories: accessories)
    print(facade.operation())
}

//- Decorator
/// The base Component interface defines operations that can be altered by decorators.
protocol Component {
    func operation() -> String
}

/// Concrete Components provide default implementations of the operations. There might be several variations of these classes.
class ConcreteComponent: Component {
    func operation() -> String {
        return "ConcreteComponent"
    }
}

/// The base Decorator class follows the same interface as the other components.
/// The primary purpose of this class is to define the wrapping interface for
/// all concrete decorators. The default implementation of the wrapping code
/// might include a field for storing a wrapped component and the means to
/// initialize it.
class Decorator: Component {
    private var component: Component

    init(_ component: Component) {
        self.component = component
    }

    /// The Decorator delegates all work to the wrapped component.
    func operation() -> String {
        return component.operation()
    }
}

class ConcreteDecoratorA: Decorator {

    /// Decorators may call parent implementation of the operation, instead of
    /// calling the wrapped object directly. This approach simplifies extension
    /// of decorator classes.
    override func operation() -> String {
        return "ConcreteDecoratorA(" + super.operation() + ")"
    }
}

class ConcreteDecoratorB: Decorator {
    override func operation() -> String {
        return "ConcreteDecoratorB(" + super.operation() + ")"
    }
}

example(of: "Decorator") {
    func someClientCode(component: Component) {
        print("Result: " + component.operation())
    }
    
    // This way the client code can support both simple components...
    print("Client: I've got a simple component")
    let simple = ConcreteComponent()
    someClientCode(component: simple)

    // ...as well as decorated ones.
    //
    // Note how decorators can wrap not only simple components but the other decorators as well.
    let decorator1 = ConcreteDecoratorA(simple)
    let decorator2 = ConcreteDecoratorB(decorator1)
    print("\nClient: Now I've got a decorated component")
    someClientCode(component: decorator2)
}

//- Adapter
/// The Target defines the domain-specific interface used by the client code.
class Target {

    func request() -> String {
        return "Target: The default target's behavior."
    }
}

/// The Adaptee contains some useful behavior, but its interface is incompatible
/// with the existing client code. The Adaptee needs some adaptation before the
/// client code can use it.
class Adaptee {
    public func specificRequest() -> String {
        return ".eetpadA eht fo roivaheb laicepS"
    }
}

/// The Adapter makes the Adaptee's interface compatible with the Target's
/// interface.
class Adapter: Target {
    private var adaptee: Adaptee

    init(_ adaptee: Adaptee) {
        self.adaptee = adaptee
    }

    override func request() -> String {
        return "Adapter: (TRANSLATED) " + adaptee.specificRequest().reversed()
    }
}

example(of: "Adapter") {
    func someClientCode(target: Target) {
        print(target.request())
    }
    
    print("Client: I can work just fine with the Target objects:")
    someClientCode(target: Target())

    let adaptee = Adaptee()
    print("Client: The Adaptee class has a weird interface. See, I don't understand it:")
    print("Adaptee: " + adaptee.specificRequest())

    print("Client: But I can work with it via the Adapter:")
    someClientCode(target: Adapter(adaptee))
}

//- Observer
protocol CartObserver: AnyObject {
    func cartContentsDidChange()
}

class Cart {
    private var items: [String] = []
    private var observers: [CartObserver] = []

    func addItem(_ item: String) {
        items.append(item)
        notifyObservers()
    }

    func removeItem(at index: Int) {
        items.remove(at: index)
        notifyObservers()
    }

    func addObserver(_ observer: CartObserver) {
        observers.append(observer)
    }

    func removeObserver(_ observer: CartObserver) {
        observers.removeAll { $0 === observer }
    }

    private func notifyObservers() {
        for observer in observers {
            observer.cartContentsDidChange()
        }
    }
}

class CartViewController: UIViewController, CartObserver {
    let cart = Cart()

    override func viewDidLoad() {
        super.viewDidLoad()
        cart.addObserver(self)
    }

    deinit {
        cart.removeObserver(self)
    }

    func cartContentsDidChange() {
        print("Update the display with the new contents of the cart")
    }
}

example(of: "Observer") {
    let controller = CartViewController()
    controller.cart.addItem("Hello world")
}


//- Iterator
struct Emojis: Sequence {
    let animals: [String]

    func makeIterator() -> EmojiIterator {
        return EmojiIterator(self.animals)
    }
}

struct EmojiIterator: IteratorProtocol {

    private let values: [String]
    private var index: Int?

    init(_ values: [String]) {
        self.values = values
    }

    private func nextIndex(for index: Int?) -> Int? {
        if let index = index, index < self.values.count - 1 {
            return index + 1
        }
        if index == nil, !self.values.isEmpty {
            return 0
        }
        return nil
    }

    mutating func next() -> String? {
        if let index = self.nextIndex(for: self.index) {
            self.index = index
            return self.values[index]
        }
        return nil
    }
}

example(of: "Iterator") {
    let emojis = Emojis(animals: ["🐶", "🐔", "🐵", "🦁", "🐯", "🐭", "🐱", "🐮", "🐷"])
    for emoji in emojis {
        print(emoji)
    }
}
//- Memento

/// The Memento interface provides a way to retrieve the memento's metadata, such as creation date or name. However, it doesn't expose the Originator's state.
protocol Memento {
    var name: String { get }
    var date: Date { get }
}

/// The Originator holds some important state that may change over time. It also
/// defines a method for saving the state inside a memento and another method
/// for restoring the state from it.
class Originator {

    /// For the sake of simplicity, the originator's state is stored inside a single variable.
    private var state: String

    init(state: String) {
        self.state = state
        print("Originator: My initial state is: \(state)")
    }

    /// The Originator's business logic may affect its internal state.
    /// Therefore, the client should backup the state before launching methods
    /// of the business logic via the save() method.
    func doSomething() {
        print("Originator: I'm doing something important.")
        state = generateRandomString()
        print("Originator: and my state has changed to: \(state)")
    }

    private func generateRandomString() -> String {
        return String(UUID().uuidString.suffix(4))
    }

    /// Saves the current state inside a memento.
    func save() -> Memento {
        return ConcreteMemento(state: state)
    }

    /// Restores the Originator's state from a memento object.
    func restore(memento: Memento) {
        guard let memento = memento as? ConcreteMemento else { return }
        self.state = memento.state
        print("Originator: My state has changed to: \(state)")
    }
}

/// The Concrete Memento contains the infrastructure for storing the Originator's state.
class ConcreteMemento: Memento {

    /// The Originator uses this method when restoring its state.
    private(set) var state: String
    private(set) var date: Date

    init(state: String) {
        self.state = state
        self.date = Date()
    }

    /// The rest of the methods are used by the Caretaker to display metadata.
    var name: String { return state + " " + date.description.suffix(14).prefix(8) }
}

/// The Caretaker doesn't depend on the Concrete Memento class. Therefore, it
/// doesn't have access to the originator's state, stored inside the memento. It
/// works with all mementos via the base Memento interface.
class Caretaker {
    private lazy var mementos = [Memento]()
    private var originator: Originator

    init(originator: Originator) {
        self.originator = originator
    }

    func backup() {
        print("\nCaretaker: Saving Originator's state...\n")
        mementos.append(originator.save())
    }

    func undo() {
        guard !mementos.isEmpty else { return }
        let removedMemento = mementos.removeLast()

        print("Caretaker: Restoring state to: " + removedMemento.name)
        originator.restore(memento: removedMemento)
    }

    func showHistory() {
        print("Caretaker: Here's the list of mementos:\n")
        mementos.forEach({ print($0.name) })
    }
}

example(of: "Memento") {
    let originator = Originator(state: "Super-duper-super-puper-super.")
    let caretaker = Caretaker(originator: originator)

    caretaker.backup()
    originator.doSomething()

    caretaker.backup()
    originator.doSomething()

    caretaker.backup()
    originator.doSomething()

    print("\n")
    caretaker.showHistory()

    print("\nClient: Now, let's rollback!\n\n")
    caretaker.undo()

    print("\nClient: Once more!\n\n")
    caretaker.undo()
}

//- Repository Pattern
