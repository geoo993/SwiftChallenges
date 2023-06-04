import UIKit

func example(of description: String, action: () -> Void) {
  print("\n--- Example of:", description, "---")
  action()
}

// The delegation pattern is a Structural Design Pattern enables an object to use another “helper” object to provide data or perform a task rather than do the task itself. This pattern has three parts:

// - An object needing a delegate, also known as the delegating object. It’s the object that has a delegate. The delegate is usually held as a weak property to avoid a retain cycle where the delegating object retains the delegate, which retains the delegating object.
// - A delegate protocol, which defines the methods a delegate may or should implement.
// - A delegate, which is the helper object that implements the delegate protocol.

// By relying on a delegate protocol instead of a concrete object, the implementation is much more flexible: any object that implements the protocol can be used as the delegate!


// MARK: - When should you use it?

// Use this pattern to break up large classes or create generic, reusable components. Delegate relationships are common throughout Apple frameworks, especially UIKit.
// Both DataSource- and Delegate-named objects actually follow the delegation pattern, as each involves one object asking another to provide data or do something.
// Why isn’t there just one protocol, instead of two, in Apple frameworks?
// - Apple frameworks commonly use the term DataSource to group delegate methods that provide data. For example, UITableViewDataSource is expected to provide UITableViewCells to display.
// - Apple frameworks typically use protocols named Delegate to group methods that receive data or events. For example, UITableViewDelegate is notified whenever a row is selected.

// It’s common for the dataSource and delegate to be set to the same object, such as the view controller that owns a UITableView. However, they don’t have to be, and it can be very beneficial at times to have them set to different objects.

// MARK: - lets look at an example

// the delegate protocol defines the methods of the delegate.
protocol FlightDelegate: AnyObject {
    func willStartFlying(controller: FlightView, destination: String)
    func didFly(controller: FlightView, to destination: String)
}

final class FlightView {
    // The flighets will be used to send information to obejcts acting as delegate.
    private let flights = ["Morroco", "Dubai", "Rome"]
    private var currentFlight: String?
    weak var delegate: FlightDelegate?// You specify the delegate in the delegating object
    
    func runFlight(to destination: String) {
        if let flight = flights.first(where: { $0 == destination }) {
            delegate?.willStartFlying(controller: self, destination: flight)
            currentFlight = flight
            delegate?.didFly(controller: self, to: flight)
        }
    }
}


final class FlightViewController: UIViewController {
    var flightView: FlightView!
    
    init() {
        super.init(nibName: nil, bundle: nil)
        print("Init Controller")
        flightView = FlightView()
        
        // the common convention in iOS is to set delegate objects after an object is created.
        // This is exactly what you do here: The flightView expects that its delegate property will be set.
        flightView.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func load() {
        flightView.runFlight(to: "Dubai")
    }
}

extension FlightViewController: FlightDelegate {
    // It’s common convention to pass the delegating object, which in this case is the FlightViewController, to listen to each of the flightView delegate method calls.
    func willStartFlying(controller: FlightView, destination: String) {
        print("Will Start Departure to \(destination)")
    }
    
    func didFly(controller: FlightView, to destination: String) {
        print("Flight on the way to \(destination)")
    }
}

example(of: "Delegation") {
    var vc = FlightViewController()
    vc.load()
}

// MARK: - What should you be careful about?
// - Delegates are extremely useful, but they can be overused. Be careful about creating too many delegates for an object.
// - If an object needs several delegates, this may be an indicator that it’s doing too much. Consider breaking up the object’s functionality for specific use cases, instead of one catch-all class.
// - It’s hard to put a number on how many is too many; there’s no golden rule. However, if you find yourself constantly switching between classes to understand what’s happening, then that’s a sign you have too many. Similarly, if you cannot understand why a certain delegate is useful, then that’s a sign it’s too small, and you’ve split things up too much.
// - You should also be careful about creating retain cycles. Most often, delegate properties should be weak. If an object must absolutely have a delegate set, consider adding the delegate as an input to the object’s initializer and marking its type as forced unwrapped using ! instead of optional via ?. This will force consumers to set the delegate before using the object.
// - If you find yourself tempted to create a strong delegate, another design pattern may be better suited for your use case. For example, you might consider using the strategy pattern instead.

// MARK: - Here are the key points:
// - The delegation pattern has three parts: an object needing a delegate, a delegate protocol and a delegate.
// - This pattern allows you to break up large classes and create generic, reusable components.
// - Delegates should be weak properties in the vast majority of use cases.
