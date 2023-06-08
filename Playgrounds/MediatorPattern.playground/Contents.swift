import Foundation

func example(of description: String, action: () -> Void) {
  print("\n--- Example of:", description, "---")
  action()
}

// The mediator pattern is a behavioral design pattern that encapsulates how objects communicate with one another.
// It involves four types:

// 1- The colleagues are the objects that want to communicate with each other. They implement the colleague protocol.
// 2- The colleague protocol defines methods and properties that each colleague must implement.
// 3- The mediator is the object that controls the communication of the colleagues. It implements the mediator protocol.
// 4- The mediator protocol defines methods and properties that the mediator must implement.

// Each colleague contains a reference to the mediator, via the mediator protocol. In lieu of interacting with other colleagues directly, each colleague communicates through the mediator.
// The mediator facilitates colleague-to-colleague interaction: Colleagues may both send and receive messages from the mediator.

// MARK: - When should you use it?
// This mediator pattern is useful to separate interactions between colleagues into an object, the mediator.
// This pattern is especially useful when you need one or more colleagues to act upon events initiated by another colleague, and, in turn, have this colleague generate further events that affect other colleagues.

// MARK: - Mediator example
// Lets create the mediator class.
// You may notice that the Mediator class is similar to the MulticastDelegate class, but it has a few key differences that make it unique.

// 1 - First, we define Mediator as a generic class that accepts any ColleagueType as the generic type. You also declare Mediator as open to enable classes in other modules to subclass it.
open class Mediator<ColleagueType> {
    
    // 2 - Next, we define ColleagueWrapper as an inner class, and we declare two stored properties on it: strongColleague and weakColleague. In some use cases, we will want Mediator to retain colleagues, but in others, we won’t want this. Hence, we declare both weak and strong properties to support both scenarios. Unfortunately, Swift doesn’t provide a way to limit generic type parameters to class protocols only. Consequently, we declare strongColleague and weakColleague to be of type AnyObject? instead of ColleagueType?.
    private class ColleagueWrapper {
        var strongColleague: AnyObject?
        weak var weakColleague: AnyObject?
        
        // 3 - We declare colleague as a computed property. This is a convenience property that first attempts to unwrap weakColleague and, if that’s nil, then it attempts to unwrap strongColleague.
        var colleague: ColleagueType? {
            return (weakColleague ?? strongColleague) as? ColleagueType
        }
        
        // 4 - Finally, we declare two designated initializers, init(weakColleague:) and init(strongColleague:), for setting either weakColleague or strongColleague.
        init(weakColleague: ColleagueType) {
            self.strongColleague = nil
            self.weakColleague = weakColleague as AnyObject
        }
        
        init(strongColleague: ColleagueType) {
            self.strongColleague = strongColleague  as AnyObject
            self.weakColleague = nil
        }
    }
    
    // 1 - First, we declare colleagueWrappers to hold onto the ColleagueWrapper instances, which will be created under the hood by Mediator from colleagues passed to it.
    private var colleagueWrappers: [ColleagueWrapper] = []
    
    // 2 - Next, we add a computed property for colleagues. This uses filter to find colleagues from colleagueWrappers that have already been released and then returns an array of definitely non-nil colleagues.
    var colleagues: [ColleagueType] {
        var colleagues: [ColleagueType] = []
        colleagueWrappers = colleagueWrappers.filter {
            guard let colleague = $0.colleague else { return false }
            colleagues.append(colleague)
            return true
        }
        return colleagues
    }
    
    // 3 - Finally, we declare init(), which will act as the designated initializer for Mediator.
    init() { }
    
    // We also need a means to add and remove colleagues.
    // 1 - As the name implies, we’ll use addColleague(_:strongReference:) to add a colleague. Internally, this creates a ColleagueWrapper that either strongly or weakly references colleague depending on whether strongReference is true or not.
    func addColleague(_ colleague: ColleagueType, strongReference: Bool = true) {
        let wrapper: ColleagueWrapper
        if strongReference {
            wrapper = ColleagueWrapper(strongColleague: colleague)
        } else {
            wrapper = ColleagueWrapper(weakColleague: colleague)
        }
        colleagueWrappers.append(wrapper)
    }
    
    // 2 - Likewise, we’ll use removeColleague to remove a colleague. In such, we first attempt to find the index for the ColleagueWrapper that matches the colleague using pointer equality, === instead of ==, so that it’s the exact ColleagueType object. If found, we remove the colleague wrapper at the given index.
    func removeColleague(_ colleague: ColleagueType) {
        guard let index = colleagues.firstIndex(where: {
            ($0 as AnyObject) === (colleague as AnyObject)
        }) else { return }
        colleagueWrappers.remove(at: index)
    }
    
    // Lastly, we need a means to actually invoke all of the colleagues.
    // Both of these methods iterate through colleagues, the computed property we defined before that automatically filters out nil instances, and call the passed-in closure on each colleague instance.
    func invokeColleagues(closure: (ColleagueType) -> Void) {
        colleagues.forEach(closure)
    }
    
    func invokeColleagues(by colleague: ColleagueType, closure: (ColleagueType) -> Void) {
        colleagues.forEach {
            guard ($0 as AnyObject) !== (colleague as AnyObject)
            else { return }
            closure($0)
        }
    }
}


// - Colleague Protocol
// We declare Colleague here, which requires conforming colleagues to implement a single method: colleague(_ colleague:didSendMessage:).
protocol Colleague: AnyObject {
    func colleague(_ colleague: Colleague?, didSendMessage message: String)
}

//  - Mediator Protocol
// We declare MediatorProtocol here, which requires conforming mediators to implement two methods: addColleague(_:) and sendMessage(_:by:).
protocol MediatorProtocol: AnyObject {
    func addColleague(_ colleague: Colleague)
    func sendMessage(_ message: String, by colleague: Colleague)
}

// As you may have guessed from these protocols, you’ll create a mediator-colleague example where colleagues will send message strings via the mediator.
// The mediator design pattern is the three musketeers calling each other!

// - Colleague
// 1 - We declare Musketeer here, which will act as the colleague.
class Musketeer {
    // 2 - WE create two properties, name and mediator.
    var name: String
    weak var mediator: MediatorProtocol?
    
    // 3 - Within init, WE set the properties and call mediator.addColleague(_:) to register this colleague;
    // WE’ll make Musketeer actually conform to Colleague next.
    init(mediator: MediatorProtocol, name: String) {
        self.mediator = mediator
        self.name = name
        mediator.addColleague(self)
    }
    
    // 4 - Within sendMessage, we print out the name and passed-in message to the console and then call sendMessage(_:by:) on the mediator. Ideally, the mediator should then forward this message onto all of the other colleagues.
    func sendMessage(_ message: String) {
        print("\(name) sent: \(message)")
        mediator?.sendMessage(message, by: self)
    }
}

// Here, we make Musketeer conform to Colleague. To do so, we implement its required method colleague(_:didSendMessage:), where we print the Musketeer’s name and the received message.
extension Musketeer: Colleague {
    func colleague(_ colleague: Colleague?, didSendMessage message: String) {
        print("\(name) received: \(message)")
    }
}

// - Mediator
// Next, we need to implement the mediator.
// 1 - We create MusketeerMediator as a subclass of Mediator<Colleague>, and we make this conform to MediatorProtocol via an extension.
class MusketeerMediator: Mediator<Colleague> {
    
}

extension MusketeerMediator: MediatorProtocol {
    
    // 2 - Within addColleague(_:), we call its super class’ method for adding a colleague, addColleague(_:strongReference:).
    func addColleague(_ colleague: Colleague) {
        self.addColleague(colleague, strongReference: true)
    }
    
    // 3 - Within sendMessage(_:by:), we call its super class’ method invokeColleagues(by:) to send the passed-in message to all colleagues except for the matching passed-in colleague.
    func sendMessage(_ message: String, by colleague: Colleague) {
        invokeColleagues(by: colleague) {
            $0.colleague(colleague, didSendMessage: message)
        }
    }
}

example(of: "Mediator of Musketeers") {
    // We declare an instance of MusketeerMediator called mediator and three instances of Musketeer, called athos, porthos and aramis.
    let mediator = MusketeerMediator()
    let athos = Musketeer(mediator: mediator, name: "Athos")
    let porthos = Musketeer(mediator: mediator, name: "Porthos")
    let aramis = Musketeer(mediator: mediator, name: "Aramis")
    
    // For example, the message sent by Athos was received by Porthos and Aramis, yet Athos did not receive it.
    // This is exactly the behavior you’d expect to happen!
    athos.sendMessage("One for all...!")
    print("")

    porthos.sendMessage("and all for one...!")
    print("")

    aramis.sendMessage("Unus pro omnibus, omnes pro uno!")
    print("")
    
}

example(of: "Mediator, send message to all Collegues (i.e Musketeers)") {
    let mediator = MusketeerMediator()
    let athos = Musketeer(mediator: mediator, name: "Athos")
    let porthos = Musketeer(mediator: mediator, name: "Porthos")
    let aramis = Musketeer(mediator: mediator, name: "Aramis")
    // Using mediator directly, it’s also possible to send a message to all colleagues.
    mediator.invokeColleagues() {
        $0.colleague(nil, didSendMessage: "Best ever team!")
    }
}

// MARK: - What should you be careful about?
// - This pattern is very useful in decoupling colleagues. Instead of colleagues interacting directly, each colleague communicates through the mediator.
// - However, you need to be careful about turning the mediator into a “god” object — an object that knows about every other object within a system.
// - If your mediator gets too big, consider breaking it up into multiple mediator–colleague systems. Alternatively, consider other patterns to break up the mediator, such as delegating some of its functionality.

// MARK: - Here are its key points:

// - The mediator pattern encapsulates how objects communicate with one another. It involves four types: colleagues, a colleague protocol, a mediator, and a mediator protocol.
// - The colleagues are the objects that communicate; the colleague protocol defines methods and properties all colleagues must have; the mediator controls the communication of the colleagues; and the mediator protocol defines required methods and properties that the mediator must have.
// - In lieu of talking directly, colleagues hold onto and communicate through the mediator. The colleague protocol and mediator protocol helps prevent tight coupling between all objects involved.
