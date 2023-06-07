import UIKit
import PlaygroundSupport

// The state pattern is a behavioral pattern that allows an object to change its behavior at runtime.
// It does so by changing its current state. Here, “state” means the set of data that describes how a given object should behave at a given time.

// This pattern involves three types:

// 1) The context is the object that has a current state and whose behavior changes.
// 2) The state protocol defines required methods and properties. Developers commonly substitute a base state class in place of a protocol. By doing so, they can define stored properties in the base, which isn’t possible using a protocol. Even if a base class is used, it’s not intended to be instantiated directly. Rather, it’s defined for the sole purpose of being subclassed. In other languages, this would be an abstract class. Swift currently doesn’t have abstract classes, however, so this class isn’t instantiated by convention only.
// 3) Concrete states conform to the state protocol, or if a base class is used instead, they subclass the base. The context holds onto its current state, but it doesn’t know its concrete state type. Instead, the context changes behavior using polymorphism: concrete states define how the context should act. If you ever need a new behavior, you define a new concrete state.

// An important question remains, however: where do you actually put the code to change the context’s current state? Within the context itself, the concrete states, or somewhere else?
// You may be surprised to find out that the state pattern doesn’t tell you where to put state change logic! Instead, you’re responsible for deciding this.
// This is both a strength and weakness of this pattern: It permits designs to be flexible, but at the same time, it doesn’t provide complete guidance on how to implement this pattern.


// MARK: - When should you use it?
// - Use the state pattern to create a system that has two or more states that it changes between during its lifetime. The states may be either limited in number (a “closed“ set) or unlimited (an “open” set). For example, a traffic light can be defined using a closed set of “traffic light states.” In the simplest case, it progresses from green to yellow to red to green again.
// - An animation engine can be defined as an open set of “animation states.” It has unlimited different rotations, translations and other animations that it may progress through during its lifetime.
// - Both open- and closed-set implementations of the state pattern use polymorphism to change behavior. As a result, we can often eliminate switch and if-else statements using this pattern.
// - Instead of keeping track of complex conditions within the context, you pass through calls to the current state;  If you have a class with several switch or if-else statements, try to define it using the state pattern instead. You’ll likely create a more flexible and easier maintain system as a result.

// MARK: State pattern example using traffic lights
// lets implement the “traffic light” system.

class TrafficLight: UIView {
    // 1 - We first define a property for canisterLayers. This will hold onto the “traffic light canister” layers. These layers will hold onto the green/yellow/red states as sublayers.
    private(set) var canisterLayers: [CAShapeLayer] = []
    
    // As the names imply, we’ll use currentState to hold onto the traffic light’s current TrafficLightState, and states to hold onto all TrafficLightStates for the traffic light.
    private(set) var currentState: TrafficLightState
    private(set) var states: [TrafficLightState]
    
    // 2 - We don’t need to support init(coder:).
    @available(*, unavailable, message: "Use init(canisterCount: frame:) instead")
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) is not supported")
    }
    
    // 3 - We declare init(canisterCount:frame:) as the designated initializer and provide default values for both canisterCount and frame.
    init(
        canisterCount: Int = 3,
        frame: CGRect = CGRect(x: 0, y: 0, width: 160, height: 420),
        states: [TrafficLightState]
    ) {
        // 1 - We've added states to this initializer. Since it doesn’t make logical sense for states to be empty, you throw a fatalError if it is. Otherwise, you set the currentState to the first object within states and set self.states to the passed-in states
        guard !states.isEmpty, let current = states.first else {
            fatalError("states should not be empty")
        }
        self.currentState = current
        self.states = states
        
        // 2 - Afterwards, we call super.init
        super.init(frame: frame)
        
        // 3 - We also set the backgroundColor to a yellowish color and call createCanisterLayers(count:).
        backgroundColor = UIColor(red: 0.86, green: 0.64, blue: 0.25, alpha: 1)
        createCanisterLayers(count: canisterCount)
        transition(to: currentState)
    }
    
    private func createCanisterLayers(count: Int) {
        // 1 - We first calculate yTotalPadding as a percentage of bounds.height and then use the result to determine each yPadding space. The total number of “padding spaces” is equal to count (the number of canisters) + 1 (one extra space for the bottom).
        let paddingPercentage: CGFloat = 0.2
        let yTotalPadding = paddingPercentage * bounds.height
        let yPadding = yTotalPadding / CGFloat(count + 1)
        
        // 2 - Using yPadding, we calculate canisterHeight. To keep the canisters square, we use canisterHeight for both the height and width of each canister. We then use canisterHeight to calculate the xPadding required to center each canister. Ultimately, we use xPadding, yPadding and canisterHeight to create canisterFrame, which represents the frame for the first canister.
        let canisterHeight = (bounds.height - yTotalPadding) / CGFloat(count)
        let xPadding = (bounds.width - canisterHeight) / 2.0
        var canisterFrame = CGRect(
            x: xPadding,
            y: yPadding,
            width: canisterHeight,
            height: canisterHeight)
        
        // 3 - Using canisterFrame, we loop from 0 to count to create a canisterShape for the required number of canisters, given by count. After creating each canisterShape, we add it to canisterLayers. By keeping a reference to each canister layer, we will later be able to add “traffic light state“ sublayers to them.
        for _ in 0 ..< count {
            let canisterShape = CAShapeLayer()
            canisterShape.path = UIBezierPath(ovalIn: canisterFrame).cgPath
            canisterShape.fillColor = UIColor.black.cgColor
            layer.addSublayer(canisterShape)
            canisterLayers.append(canisterShape)
            canisterFrame.origin.y += (canisterFrame.height + yPadding)
        }
    }
    
    // We define transition(to state:) to change to a new TrafficLightState.
    func transition(to state: TrafficLightState) {
        // We first call removeCanisterSublayers to remove existing canister sublayers; this ensures a new state isn’t added on top of an existing one.
        removeCanisterSublayers()
        // We then set currentState and call apply. This allows the state to add its contents to the TrafficLight instance.
        currentState = state
        currentState.apply(to: self)
        nextState.apply(to: self, after: currentState.delay)
    }
    
    private func removeCanisterSublayers() {
        canisterLayers.forEach {
            $0.sublayers?.forEach {
                $0.removeFromSuperlayer()
            }
        }
    }
    
    // This creates a convenience computed property for the nextState, which you determine by finding the index representing the currentState
    var nextState: TrafficLightState {
        // If there are states after the index, which we determine by index + 1 < states.count, we return that next state.
        guard let index = states.firstIndex(where: { $0 === currentState }), index + 1 < states.count else {
            return states.first! // If there aren’t states after the currentState, we return the first state to go back to the start.
        }
        return states[index + 1]
    }
}

// To show the light states, you need to define a state protocol.
// - State Protocol
protocol TrafficLightState: AnyObject {
    // 1 - We first declare a delay property, which defines the time interval a state should be shown.
    var delay: TimeInterval { get }
    
    // 2 - We then declare apply(to:), which each concrete state will need to implement.
    func apply(to context: TrafficLight)
}

// - Transitioning
extension TrafficLightState {
    // This extension adds “apply after” functionality to every type that conforms to TrafficLightState.
    func apply(to context: TrafficLight, after delay: TimeInterval) {
        // In apply(to:after:), we dispatch to DispatchQueue.main after a passed-in delay, at which point you transition to the current state.
        let queue = DispatchQueue.main
        let dispatchTime = DispatchTime.now() + delay
        // In order to break potential retain cycles, you specify both self and context as weak within the closure.
        queue.asyncAfter(deadline: dispatchTime) { [weak self, weak context] in
            guard let self = self, let context = context else {
                return
            }
            context.transition(to: self)
        }
    }
}

// We declare SolidTrafficLightState to represent a “solid light” state.
class SolidTrafficLightState {
    let canisterIndex: Int
    let color: UIColor
    let delay: TimeInterval
    
    init(canisterIndex: Int, color: UIColor, delay: TimeInterval) {
        self.canisterIndex = canisterIndex
        self.color = color
        self.delay = delay
    }
}

// next need to make SolidTrafficLightState conform to TrafficLightState.
extension SolidTrafficLightState: TrafficLightState {
    // Within apply(to:), we create a new CAShapeLayer for the state
    func apply(to context: TrafficLight) {
        let canisterLayer = context.canisterLayers[canisterIndex]
        let circleShape = CAShapeLayer()
        circleShape.path = canisterLayer.path!
        circleShape.fillColor = color.cgColor
        circleShape.strokeColor = color.cgColor
        canisterLayer.addSublayer(circleShape)
    }
}

// - Convenience Constructors
// Here we add convenience class methods to create common SolidTrafficLightStates: solid green, yellow and red lights.
extension SolidTrafficLightState {
    public class func greenLight(
        color: UIColor =
        UIColor(red: 0.21, green: 0.78, blue: 0.35, alpha: 1),
        canisterIndex: Int = 2,
        delay: TimeInterval = 1.0
    ) -> SolidTrafficLightState {
        return .init(canisterIndex: canisterIndex, color: color, delay: delay)
    }
    
    public class func yellowLight(
        color: UIColor =
        UIColor(red: 0.98, green: 0.91, blue: 0.07, alpha: 1),
        canisterIndex: Int = 1,
        delay: TimeInterval = 0.5
    ) -> SolidTrafficLightState {
        return .init(canisterIndex: canisterIndex, color: color, delay: delay)
    }
    
    public class func redLight(
        color: UIColor =
        UIColor(red: 0.88, green: 0, blue: 0.04, alpha: 1),
        canisterIndex: Int = 0,
        delay: TimeInterval = 2.0
    ) -> SolidTrafficLightState {
        return .init(canisterIndex: canisterIndex, color: color, delay: delay)
    }
}

// Here, you create an instance of trafficLight and set it as the liveView for the playground’s current page, which outputs to the Live View.
let greenYellowRed: [SolidTrafficLightState] = [.greenLight(), .yellowLight(), .redLight()]
let trafficLight = TrafficLight(states: greenYellowRed)
PlaygroundPage.current.liveView = trafficLight

// MARK: - What should you be careful about?
// - Be careful about creating tight coupling between the context and concrete states. Will you ever want to reuse the states in a different context? If so, consider putting a protocol between the concrete states and context, instead of having concrete states call methods on a specific context.
// - If you choose to implement state change logic within the states themselves, be careful about tight coupling from one state to the next.
// - Will you ever want to transition from state to another state instead? In this case, consider passing in the next state via an initializer or property.

// Here are its key points:
// - The state pattern permits an object to change its behavior at runtime. It involves three types: the context, state protocol and concrete states.
// - The context is the object that has a current state; the state protocol defines required methods and properties; and the concrete states implement the state protocol and actual behavior that changes at runtime.
// - The state pattern doesn’t actually tell you where to put transition logic between states. Rather, this is left for you to decide: you can put this logic either within the context or within the concrete states.
