import Foundation

func example(of description: String, action: () -> Void) {
  print("\n--- Example of:", description, "---")
  action()
}

// The multicast delegate pattern is a behavioral pattern that’s a variation on the delegate pattern.
// It allows you to create one-to-many delegate relationships, instead of one-to-one relationships in a simple delegate.

// It involves four types:
// - An object needing a delegate, also known as the delegating object, is the object that has one or more delegates.
// - The delegate protocol defines the methods a delegate may or should implement.
// - The delegate(s) are objects that implement the delegate protocol.
// - The multicast delegate is a helper class that holds onto delegates and allows you to notify each whenever a delegate-worthy event happens.

// The main difference between the multicast delegate pattern and the delegate pattern is the presence of a multicast delegate helper class. Swift doesn’t provide you this class by default.
// However, you can easily create your own


// MARK: - When should you use it?
// - Use this pattern to create one-to-many delegate relationships.
// - For example, you can use this pattern to inform multiple objects whenever a change has happened to another object. Each delegate can then update its own state or perform relevant actions in response.

// MARK: - MulticastDelegate example

// 1 - We define MulticastDelegate as a generic class that accepts any ProtocolType as the generic type.
// Swift doesn’t yet provide a way to restrict <ProtocolType> to protocols only. Consequently, you could pass a concrete class type instead of a protocol for ProtocolType. Most likely, however, you’ll use a protocol. Hence, you name the generic type as ProtocolType instead of just Type.
class MulticastDelegate<ProtocolType> {
    // 2 - We define DelegateWrapper as an inner class. We’ll use this to wrap delegate objects as a weak property.
    // This way, the multicast delegate can hold onto strong wrapper instances, instead of the delegates directly.
    private class DelegateWrapper {
        weak var delegate: AnyObject? // Unfortunately, here you have to declare the delegate property as AnyObject instead of ProtocolType.
        
        init(_ delegate: AnyObject) {
            self.delegate = delegate
        }
    }
    
    // 1 - We declare delegateWrappers to hold onto the DelegateWrapper instances, which will be created under the hood by MulticastDelegate from delegates passed to it.
    private var delegateWrappers: [DelegateWrapper]
    
    // 2 - We then add a computed property for delegates. This filters out delegates from delegateWrappers that have already been released and then returns an array of definitely non-nil delegates.
    var delegates: [ProtocolType] {
        delegateWrappers = delegateWrappers.filter { $0.delegate != nil }
        return (delegateWrappers.compactMap{ $0.delegate } as? [ProtocolType]) ?? []
    }
    
    // 3 - Lastly, we create an initializer that accepts an array of delegates and maps these to create delegateWrappers.
    init(delegates: [ProtocolType] = []) {
        delegateWrappers = delegates.map {
            DelegateWrapper($0 as AnyObject)
        }
    }
    
    // You also need a means to add and remove delegates after a MulticastDelegate has been created already.
    // 1 - As its name implies, we’ll use addDelegate to add a delegate instance, which creates a DelegateWrapper and appends it to the delegateWrappers.
    func addDelegate(_ delegate: ProtocolType) {
        let wrapper = DelegateWrapper(delegate as AnyObject)
        delegateWrappers.append(wrapper)
    }
    
    // 2 - Likewise, we’ll use removeDelegate to remove a delegate. In such, you first attempt to find the index for the DelegateWrapper that matches the delegate using pointer equality, === instead of ==. If found, you remove the delegate wrapper at the given index.
    func removeDelegate(_ delegate: ProtocolType) {
        guard let index = delegateWrappers.firstIndex(where: {
            $0.delegate === (delegate as AnyObject)
        }) else { return }
        delegateWrappers.remove(at: index)
    }
    
    // Lastly, we need a means to actually invoke all of the delegates.
    // We iterate through delegates, the computed property we defined before that automatically filters out nil instances, and call the passed-in closure on each delegate instance.
    func invokeDelegates(_ closure: (ProtocolType) -> ()) {
        delegates.forEach { closure($0) }
    }
}

// We define EmergencyResponding, which will act as the delegate protocol.
protocol EmergencyResponding {
    func notifyFire(at location: String)
    func notifyCarCrash(at location: String)
}

// - Delegates
// We define two delegate objects: FireStation and PoliceStation. Whenever an emergency happens, both the police and fire fighters will respond.
final class FireStation: EmergencyResponding {
    func notifyFire(at location: String) {
        print("Firefighters were notified about a fire at " + location)
    }
    
    func notifyCarCrash(at location: String) {
        print("Firefighters were notified about a car crash at " + location)
    }
}

final class PoliceStation: EmergencyResponding {
    func notifyFire(at location: String) {
        print("Police were notified about a fire at " + location)
    }
    
    func notifyCarCrash(at location: String) {
        print("Police were notified about a car crash at " + location)
    }
}

// - Delegating Object
class DispatchSystem {
    // We declare DispatchSystem, which has a multicastDelegate property.
    // This is the delegating object. We can imagine this is part of a larger dispatch system, where we notify all emergency responders whenever a fire, crash, or other emergency event happens.
    let multicastDelegate = MulticastDelegate<EmergencyResponding>()
}

example(of: "Multicast Delegate Example") {
    // First we create dispatch as an instance of DispatchSystem.
    let dispatch = DispatchSystem()
    
    // We then create delegate instances for policeStation and fireStation and register both by calling dispatch.multicastDelegate.addDelegate(_:).
    var policeStation: PoliceStation! = PoliceStation()
    var fireStation: FireStation! = FireStation()

    dispatch.multicastDelegate.addDelegate(policeStation)
    dispatch.multicastDelegate.addDelegate(fireStation)
    
    // This calls notifyFire(at:) on each of the delegate instances on multicastDelegate.
    dispatch.multicastDelegate.invokeDelegates {
        $0.notifyFire(at: "Ray’s house!")
    }
    
    // In the event that a delegate becomes nil, it should not be notified of any future calls on multicast delegate.
    // Lets verify this verify
    print("")
    fireStation = nil // We set fireStation to nil, which in turn will result in its related DelegateWrapper on MulticastDelegate having its delegate set to nil as well.
    //  When you then call invokeDelegates, this will result in said DelegateWrapper being filtered out, so its delegate’s code will not be invoked.
    dispatch.multicastDelegate.invokeDelegates {
        $0.notifyCarCrash(at: "Ray's garage!")
    }
}

// MARK: - What should you be careful about?
// - This pattern works best for “information only” delegate calls.
// - If delegates need to provide data, this pattern doesn’t work well. That’s because multiple delegates would be asked to provide the data, which could result in duplicated information or wasted processing.
// - In this case, consider using the chain-of-responsibility pattern instead

// MARK: - Here are its key points:
// - The multicast delegate pattern allows you to create one-to-many delegate relationships. It involves four types: an object needing a delegate, a delegate protocol, delegates, and a multicast delegate.
// - An object needing a delegate has one or more delegates; the delegate protocol defines the methods a delegate should implement; the delegates implement the delegate protocol; and the multicast delegate is a helper class for holding onto and notifying the delegates.
// - Swift doesn’t provide a multicast delegate object for you. However, it’s easy to implement your own to support this pattern.
