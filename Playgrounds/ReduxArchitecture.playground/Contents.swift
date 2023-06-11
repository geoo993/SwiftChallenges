import UIKit
import Combine
import PlaygroundSupport

// At Facebook, some years ago, a bug in the desktop web app sparked a new architecture. The app presented the unread count of messages from Messenger in several views at once, not always presenting the same amount of unread messages. This could get out of sync and report different numbers, so the app looked broken. Facebook needed a way to guarantee data consistency and, out of this problem, a new unidirectional architecture was born — Flux.

// After Facebook moved to a Flux based architecture, views that showed the unread message count got data from the same container. This new architecture fixed a lot of these kinds of bugs.

// Flux is a pattern, though, not a framework. In 2015, Dan Abramov and Andrew Clark created Redux as a JavaScript implementation of a Flux inspired architecture. Since then, others have created Redux implementations in languages such as Swift and Kotlin.

// MARK: - What is Redux?

// Redux is an architecture in which all of your app’s state lives in one container. The only way to change state is to create a new state based on the current state and a requested change.
// - The "Store" holds all of your app’s state.
// - An "Action" is immutable data that describes a state change.
// - A "Reducer" changes the app’s state using the current state and an action.


// MARK: - Store
// The Redux store contains all state that drives the app’s user interface. Think of the store as a living snapshot of your app. Anytime its state changes, the user interface updates to reflect the new state.
// You might think storing everything in one place is insane — that’s a valid thought. Instead of creating one massive file for the state, split it up into different sub-states. Each screen cares about a part of the entire apps state.

// - Types of state
// A Store contains data that represents an app’s user interface (UI). Here are some examples:
// 1) "View state" determines which user elements to show, hide, enable, disable or whether a spinner is animating.
// 2) "Navigation state" determines which view to present to the user and which views are currently presented.
// 3) "High-level state" determines whether the user is signed in or signed out. Current user profile metadata and authentication tokens could be contained in the high-level state.
// 4) "Data from web services" include things like responses from a REST API. The response gets parsed into models and placed in the store.
// 5) "Formatted strings" are strings that get transformed for display from raw model data from an API.

// The store is the source of truth for your app. All views get data from the same store, so there’s no chance of two views displaying different data, as was happening during Facebook’s bug.

// - Derived values
// The store doesn’t contain larger files, such as images or videos. Instead, it contains file URLs pointing to media on disk.
// The entire store is in memory at all times. If your app has tons of video files or images in the store instead of file references, iOS may crash your app to free up memory.

// MARK: - View state
// In a Redux architecture, views store no state. They only listen and react to state changes. So, any state that changes how the view behaves lives in the store. Stores consist of immutable value types. When data in the store changes, views get a new, immutable state to re-render the user interface.
// For example, an onboarding displays a welcome screen where you can navigate to the sign-in or sign-up screens. The app state determines which screen is currently shown to the user. When the app state changes, the app presents a new screen to the user.

// MARK: - Subscription
// For a view to render, it subscribes to changes in the store. Each time state changes, the view gets wholesale changes containing the entire state — there is no middle ground. This is unlike MVVM, where you manipulate one property at a time.
// Using Focused Observation, the view can subscribe to pieces of state that it’s interested in, avoiding updates when any app state changes occur. The view still gets the piece of state in one update.
// Views need the current state from the store each time the view loads. On load, they always have an empty state. After subscribing to the store, it fires an update and the view re-renders.
// There’s a short delay between when the app presents the view on screen and when the subscription fires its first update. The duration is usually short enough where you don’t notice the first update. But make sure all views can gracefully display an empty state.

// MARK: - Responding to user interactions
// - Actions
// "Actions" are immutable data that describe a state change. You create actions when the user interacts with the user interface.
// Dispatching an action is the only way to change state in the Redux store. No sneaky view can grab the store and make changes without the rest of the app finding out. Redux works because actions change the store, and it notifies subscribers across the app.
// For example, in the Welcome screen, there are two buttons, Sign In and Sign Up. When the Sign Up button gets tapped, you create and dispatch a Go to Sign Up action. The store updates its state, and it notifies the OnboardingViewController. Then, the OnboardingViewController pushes the sign-up screen onto the navigation stack.

// - Reducers
// Reducers describe possible state changes. Reducers are the step between dispatching an action and changing the store’s state. After an action is dispatched, it travels through a reducer. The only place the store’s state can mutate is in a reducer.
// Reducers are free functions that take in the current store’s state along with an action describing a state.
// They mutate a copy of the current state based on the action, and return the new state. Reducer functions should not introduce side effects. They should not make API calls or modify objects outside of their scope.
// In addition to updating state based on actions, reducers can run business logic to transform state. Date formatting logic lives in reducers to transform data for display. For example, a reducer can transform a Date object to a presentable String.
// Redux recommends to split your reducers into sub-reducers. Sub-reducers help keep your reducer logic focused and readable

// - Threading
// In Redux, it’s important to run all the reducers on the same thread. It doesn’t have to be the main thread, but the same serial queue.
// If you run the reducers on multiple threads, the input state of the reducer could change while it’s running on another thread. Redux is a synchronization point by design.
// ReSwift, is a Redux implementation of unidirectional data flow architecture in Swift, lets you run reducers on any serial queue, but defaults to the main queue. The simplest approach is to run on the main queue because the user interface and store are completely in sync. Then, there’s no need to hop on main queue when observing the store.

// - Performing side effects
// Side effects are any non-pure functions. Any time you call a function that can return a different value given the same inputs is a side effect. Pure functions are deterministic. Given the same inputs, the function always has the same outputs.
// Reducers should be pure functions, free of side effects. In Redux, you handle side effects before dispatching actions and after the store updates.
// For example, apps commonly make asynchronous API calls to a server and wait for a response. In Redux, you never make these asynchronous API calls in reducer functions. Instead, create multiple actions for different stages of your network request.
// Stages of a network request:
// - Network request is in progress.
// - Network request completed successfully.
// - Network request failed.
// Before starting the network request, dispatch an In-progress action. The reducer updates the state in the store to indicate the network request is in-progress. The view updates its user interface to reflect the change by showing a spinner and disabling UI elements as needed.
// Next, make the network request. Once the API call completes, dispatch a Network Request Succeeded or Network Request Failed action. The store updates its state, and the view updates to show a success or failed message, and enables its UI elements. You can also dispatch actions during the network requests to update percentage complete state in the store.
// A network request is one example of an asynchronous operation, and any asynchronous task can follow the same process: dispatch actions before, during and after the task completes.

// MARK: - Rendering updates
// Redux is a “reactive” architecture. The word “reactive” is thrown around a lot these days. In Redux, “reactive” means the view receives updated state via subscriptions, and it “reacts” to the updates. Views never ask the store for the current state; they only update when the store fires an update that data changed.

// - Diffing
// Each time a view receives new state via subscription, it gets the whole state. The view needs to figure out what changed and then properly render the update.
// The simple solution is to reload the entire UI, although this might look clunky. Another solution is to diff the new state with the current state of the UI and render necessary updates.
// Diffing helps avoid unnecessary changes. It also allows views to animate changes, since you know exactly which user interface element changed.
// UIKit sometimes won’t render unnecessary changes. You can test this by subclassing a UIView, set a property to some test value, and check if the system calls draw rect or needs display.


// MARK: - Redux in iOS apps
// "ReSwift" and "Katana" are the two main Swift Redux implementations. Both have a strong following on GitHub and are great choices for your Redux library.
// Redux is a simple concept, and you could write your own Redux library. All the Redux libraries are super small by design. Either way, use of a library is recommended.


// MARK: - Redux protocols
protocol StateType: Equatable { }
protocol ActionType: Equatable { }

// A Reducer is a function that takes the current state from the store, and the action. It combines things together and returns the new state.
typealias Reducer<ReducerState, ReducerAction> = (_ action: ReducerAction, _ state: ReducerState?) -> ReducerState
protocol StoreSubscriber: AnyObject {
    func newState(state: Any)
}

protocol StoreType {
    associatedtype State
    
    /// The current state stored in the store.
    var state: State! { get }
}

class Store<State, Action: ActionType>: StoreType {
    var reducer: Reducer<State, Action>
    var state: State!
    var subscribers: [StoreSubscriber] = []
    
    init(reducer: @escaping Reducer<State, Action>, state: State?) {
        self.reducer = reducer
        self.state = state
    }
    
    func dispatch(_ action: Action) {
        /// Store state holds the gridview state
        ///The store is also in charge of updating the state based on the action
        state = reducer(action, state)
        subscribers.forEach { $0.newState(state: state!) }
    }
    
    func subscribe(_ newSubscriber: StoreSubscriber) {
        subscribers.append(newSubscriber)
    }
    
    func unsubscribe(_ subscriber: StoreSubscriber) {
        for (index, value) in subscribers.enumerated() where value === subscriber {
            if index < subscribers.count {
                self.subscribers.remove(at: index)
            }
        }
    }
}

// - Send Actions
protocol ActionDispatcher {
    func dispatch<A>(_ action: A) where A: ActionType
}

extension Store: ActionDispatcher where Action: ActionType {
    func dispatch<A>(_ action: A) where A: ActionType{
        dispatch(action as! Action)
    }
}

// MARK: - ReSwift publishers
// Instead of subscribing directly to the ReSwift state store, view controllers subscribe to Combine publishers created from the ReSwift store. For this to work, a Combine Subscription forwards the ReSwift store subscriber updates to Combine publisher subscribers:

// A StateSubscription handles the ReSwift store subscription. After subscribing to the store, ReSwift calls newState(state:) when state changes and forwards it to the Combine subscriber’s receive(_:) method.
private final class StateSubscription<S: Subscriber, State: StateType, A: ActionType>:
    Combine.Subscription, StoreSubscriber where S.Input == State {
    var requested: Subscribers.Demand = .none
    var subscriber: S?
    
    let store: Store<State, A>
    var subscribed = false
    
    init(subscriber: S, store: Store<State, A>) {
        self.subscriber = subscriber
        self.store = store
    }
    
    func cancel() {
        store.unsubscribe(self)
        subscriber = nil
    }
    
    func request(_ demand: Subscribers.Demand) {
        requested += demand
        
        if !subscribed, requested > .none {
            // Subscribe to ReSwift store
            store.subscribe(self)
            subscribed = true
        }
    }
    
    // ReSwift calls this method on state changes
    func newState(state: Any) {
        guard requested > .none else {
            return
        }
        requested -= .max(1)
        
        // Forward ReSwift update to subscriber
        if let value = state as? State {
            _ = subscriber?.receive(value)
        }
    }
}

extension Store where State: StateType, Action: ActionType {
    // publisher() creates and returns a StatePublisher that creates a StateSubscription that gets called whenever the State changes.
    func publisher() -> AnyPublisher<State, Never> {
        return StatePublisher(store: self).eraseToAnyPublisher()
    }
    
    struct StatePublisher: Combine.Publisher {
        typealias Output = State
        typealias Failure = Never
        
        let store: Store<State, Action>
        
        func receive<S: Subscriber>(subscriber: S) where Failure == S.Failure, Output == S.Input  {
            let subscription = StateSubscription(subscriber: subscriber, store: store)
            subscriber.receive(subscription: subscription)
        }
    }
}

// MARK: - Redux app example

// - Content view
final class ContentView: UIView {
    let topLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    let button: UIButton  = {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor.magenta
        button.titleLabel?.font = .boldSystemFont(ofSize: 18)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 16
        return button
    }()
    
    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        addSubview(topLabel)
        addSubview(button)
        activateConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func activateConstraints() {
        button.translatesAutoresizingMaskIntoConstraints = false
        let leading = button.leadingAnchor
            .constraint(equalTo: layoutMarginsGuide.leadingAnchor)
        let trailing = button.trailingAnchor
            .constraint(equalTo: layoutMarginsGuide.trailingAnchor)
        let bottom = safeAreaLayoutGuide.bottomAnchor.constraint(
            equalTo: button.bottomAnchor, constant: 20
        )
        let height = button.heightAnchor.constraint(equalToConstant: 50)
        NSLayoutConstraint.activate([leading, trailing, bottom, height])
        
        topLabel.translatesAutoresizingMaskIntoConstraints = false
        let centerX = topLabel.centerXAnchor
            .constraint(equalTo: centerXAnchor)
        let labelbottom = button.topAnchor.constraint(
            equalTo: topLabel.bottomAnchor, constant: 20
        )
        NSLayoutConstraint.activate([centerX, labelbottom])
    }
    
    func addTarget(target: Any?, action: Selector) {
        button.addTarget(target, action: action, for: .touchUpInside)
    }
    
    func configure(title: String, action: String) {
        topLabel.text = title
        button.setTitle(action, for: .normal)
    }
}

// - Welcome
enum Welcome {
    struct State: StateType {
        var user: User
        var title = ""
        var message = ""
        
        init(user: User = .init(name: "")) {
            self.user = user
        }
    }
    
    enum Action: ActionType {
        case viewDidLoad
    }

    static func reducer(action: Action, state: State?) -> State {
        var state = state ?? State()
        switch action {
        case .viewDidLoad:
            state.title = "Welcome 👋 \(state.user.name)"
            state.message = "Yay! welcome to the best app in the world"
        }
        return state
    }
    
}

extension Welcome {
    final class ViewController: UIViewController {
        private(set) var statePublisher: AnyPublisher<State, Never>
        private let actionDispatcher: ActionDispatcher
        private var subscriptions = Set<AnyCancellable>()
        
        private let titleLabel: UILabel = {
            let label = UILabel()
            label.numberOfLines = 0
            label.lineBreakMode = .byWordWrapping
            return label
        }()
        
        init(statePublisher: AnyPublisher<State, Never>, actionDispatcher: ActionDispatcher) {
            self.statePublisher = statePublisher
            self.actionDispatcher = actionDispatcher
            super.init(nibName: nil, bundle: nil)
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        override func viewDidLoad() {
            super.viewDidLoad()
            observeState()
            configure()
            actionDispatcher.dispatch(Action.viewDidLoad)
        }
        
        private func configure() {
            view.addSubview(titleLabel)
            view.backgroundColor = .yellow
            titleLabel.backgroundColor = .yellow
            titleLabel.translatesAutoresizingMaskIntoConstraints = false
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            titleLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        }
        
        private func observeState() {
            statePublisher
                .receive(on: DispatchQueue.main)
                .removeDuplicates()
                .sink { [weak self] state in
                    self?.updateUI(title: state.title, message: state.message)
                }
                .store(in: &subscriptions)
        }
        
        private func updateUI(title: String, message: String) {
            self.title = title
            titleLabel.text = message
        }
    }
}

// - Authentication
enum Auth {
    struct Input: Equatable {
        let isAuthenticated: Bool
        let name: String
    }

    struct State: StateType {
        var title = ""
        var action = ""
        var authenticated: Input?
    }
    
    enum Action: ActionType {
        case viewDidLoad
        case didAuthenticate(Bool, String)
    }
    
    static func reducer(action: Action, state: State?) -> State {
        // creates a new state if one does not already exist
        var state = state ?? State()
        switch action {
        case .viewDidLoad:
            state.title = "Please Authenticate"
            state.action = "Sign in"
        case let .didAuthenticate(auth, name):
            state.authenticated = Input(isAuthenticated: auth, name: name)
        }
        return state
    }
}

extension Auth {
    final class ViewController: UIViewController {
        private(set) var statePublisher: AnyPublisher<State, Never>
        private var content: ContentView!
        private let actionDispatcher: ActionDispatcher
        private var subscriptions = Set<AnyCancellable>()
        
        init(statePublisher: AnyPublisher<State, Never>, actionDispatcher: ActionDispatcher) {
            self.statePublisher = statePublisher
            self.actionDispatcher = actionDispatcher
            super.init(nibName: nil, bundle: nil)
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        override func viewDidLoad() {
            super.viewDidLoad()
            observeState()
            configure()
            actionDispatcher.dispatch(Action.viewDidLoad)
        }
        
        private func configure() {
            content = ContentView()
            view.backgroundColor = .red
            content.backgroundColor = .red
            view.addSubview(content)
            content.translatesAutoresizingMaskIntoConstraints = false
            content.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            content.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
            content.heightAnchor.constraint(greaterThanOrEqualToConstant: 200).isActive = true
            content.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
            content.addTarget(target: self, action: #selector(buttonTapped))
        }
        
        private func observeState() {
            statePublisher
                .receive(on: DispatchQueue.main)
                .removeDuplicates()
                .sink { [weak self] state in
                    self?.updateUI(title: state.title, action: state.action)
                }
                .store(in: &subscriptions)
        }
        
        private func updateUI(title: String, action: String) {
            content.configure(title: title, action: action)
        }
        
        @objc private func buttonTapped() {
            actionDispatcher.dispatch(Action.didAuthenticate(true, "Sam"))
        }
    }
}

// - Onboarding Reducer
struct User: Equatable {
    let name: String
}

enum Onboarding {
    struct State: StateType {
        var isAuthenticated = false
        var user: User?
    }
    
    enum Action: ActionType {
        case viewDidLoad
        case auth(Bool, String)
    }

    static func reducer(action: Action, state: State?) -> State {
        var state = state ?? State()
        switch action {
        case let .auth(authenticated, name):
            state.isAuthenticated = authenticated
            state.user = .init(name: name)
        default: break
        }
        return state
    }
}

extension Onboarding {
    final class ViewController: UINavigationController {
        private let statePublisher: AnyPublisher<State, Never>
        private let actionDispatcher: ActionDispatcher
        private let authViewController: Auth.ViewController
        private var subscriptions = Set<AnyCancellable>()
        private var welcomeViewController: Welcome.ViewController?
        private let makeWelcomeViewController: (User) -> Welcome.ViewController

        init(
            statePublisher: AnyPublisher<State, Never>,
            actionDispatcher: ActionDispatcher,
            authViewController: Auth.ViewController,
            welcomeViewControllerFactory: @escaping (User) -> Welcome.ViewController
        ) {
            self.statePublisher = statePublisher
            self.actionDispatcher = actionDispatcher
            self.authViewController = authViewController
            self.makeWelcomeViewController = welcomeViewControllerFactory
            super.init(nibName: nil, bundle: nil)
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        override func viewDidLoad() {
            super.viewDidLoad()
            observeState()
            actionDispatcher.dispatch(Action.viewDidLoad)
        }
        
        private func observeState() {
            statePublisher
                .receive(on: DispatchQueue.main)
                .removeDuplicates()
                .sink { [weak self] state in
                    self?.presentController(state: state)
                }
                .store(in: &subscriptions)

            authViewController.statePublisher
                .map(\.authenticated)
                .removeDuplicates()
                .sink { [weak self] result in
                    guard let result else { return }
                    self?.actionDispatcher.dispatch(
                        Action.auth(result.isAuthenticated, result.name)
                    )
                }
                .store(in: &subscriptions)
        }
        
        private func presentController(state: State) {
            if state.isAuthenticated, let user = state.user {
                let controller = makeWelcomeViewController(user)
                setViewControllers([controller], animated: false)
                welcomeViewController = controller
            } else {
                welcomeViewController = nil
                setViewControllers([authViewController], animated: true)
            }
        }
    }
}

// - App Launch

enum Launch {
    enum State: StateType {
        case launching
        case content(String, String)
        case onboarding(Onboarding.State)
    }
    
    enum Action: ActionType {
        case viewDidLoad
        case onboarding
    }

    static func reducer(action: Action, state: State?) -> State {
        // creates a new state if one does not already exist
        var state = state ?? State.launching
        switch action {
        case .viewDidLoad:
            state = .content("Lets go...", "Go to Onboarding")
        case .onboarding:
            state = .onboarding(.init())
        }
        return state
    }
}

extension Launch {
    final class ViewController: UIViewController {
        private let statePublisher: AnyPublisher<State, Never>
        private let actionDispatcher: ActionDispatcher
        private var onboardingViewController: Onboarding.ViewController?
        private let makeOnboardingViewController: (Onboarding.State) -> Onboarding.ViewController
        private var content: ContentView!
        private var subscriptions = Set<AnyCancellable>()
        
        init(
            statePublisher: AnyPublisher<State, Never>,
            actionDispatcher: ActionDispatcher,
            onboardingViewControllerFactory: @escaping (Onboarding.State) -> Onboarding.ViewController
        ) {
            self.statePublisher = statePublisher
            self.actionDispatcher = actionDispatcher
            self.makeOnboardingViewController = onboardingViewControllerFactory
            super.init(nibName: nil, bundle: nil)
            observeState()
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        override func viewDidLoad() {
            super.viewDidLoad()
            setup()
            actionDispatcher.dispatch(Action.viewDidLoad)
        }
        
        private func setup() {
            content = ContentView()
            view.backgroundColor = .orange
            content.backgroundColor = .orange
            view.addSubview(content)
            content.translatesAutoresizingMaskIntoConstraints = false
            content.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            content.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
            content.heightAnchor.constraint(greaterThanOrEqualToConstant: 200).isActive = true
            content.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
            content.addTarget(target: self, action: #selector(buttonTapped))
        }
        
        private func observeState() {
            statePublisher
                .receive(on: DispatchQueue.main)
                .removeDuplicates()
                .sink { [weak self] state in
                    switch state {
                    case let .content(title, action):
                        self?.updateUI(title: title, action: action)
                    case let .onboarding(value):
                        self?.present(value)
                    default: break
                    }
                }
                .store(in: &subscriptions)
        }
        
        @objc private func buttonTapped() {
            actionDispatcher.dispatch(Action.onboarding)
        }
        
        private func updateUI(title: String, action: String) {
            content.configure(title: title, action: action)
        }
        
        private func present(_ state: Onboarding.State) {
            let onboardingViewController = makeOnboardingViewController(state)
            onboardingViewController.modalPresentationStyle = .fullScreen
            present(onboardingViewController, animated: true)
            self.onboardingViewController = onboardingViewController
        }
        
    }
}

func makeWelcomeViewController(user: User) -> Welcome.ViewController {
    let store: Store<Welcome.State, Welcome.Action> = {
        return Store(reducer: Welcome.reducer, state: Welcome.State(user: user))
    }()
    return Welcome.ViewController(
        statePublisher: store.publisher(),
        actionDispatcher: store
    )
}

func makeAuthViewController() -> Auth.ViewController {
    let store: Store<Auth.State, Auth.Action> = {
        return Store(reducer: Auth.reducer, state: Auth.State())
    }()
    return Auth.ViewController(
        statePublisher: store.publisher(),
        actionDispatcher: store
    )
}

func makeOnboardingViewController(_ state: Onboarding.State) -> Onboarding.ViewController {
    let store: Store<Onboarding.State, Onboarding.Action> = {
        return Store(reducer: Onboarding.reducer, state: state)
    }()
    let authViewController = makeAuthViewController()
    let welcomeViewControllerFactory: (User) -> Welcome.ViewController = { user in
        return makeWelcomeViewController(user: user)
    }
    return Onboarding.ViewController(
        statePublisher: store.publisher(),
        actionDispatcher: store,
        authViewController: authViewController,
        welcomeViewControllerFactory: welcomeViewControllerFactory
    )
}

func makeLaunchViewController() -> Launch.ViewController {
    let stateStore: Store<Launch.State, Launch.Action> = {
        return Store(reducer: Launch.reducer, state: Launch.State.launching)
    }()
    let onboardingViewControllerFactory: (Onboarding.State) -> Onboarding.ViewController = {
        return makeOnboardingViewController($0)
    }
    return Launch.ViewController(
        statePublisher: stateStore.publisher(),
        actionDispatcher: stateStore,
        onboardingViewControllerFactory: onboardingViewControllerFactory
    )
}

let controller = makeLaunchViewController()
controller.view?.frame.size = CGSize(width: 375, height: 667)
PlaygroundPage.current.liveView = controller


// MARK: - Pros and cons of Redux
// - Pros of Redux
/*
1) Redux scales well as your application grows — if you follow best practices. Separate your Redux store state into sub-states and only observe partial state in your view controllers.
2) Descriptive state changes are all contained in reducers. Any developer can read through your reducer functions to understand all state changes in the app.
3) The store is the single source of truth for your entire app. If data changes in the store, the change propagates to all subscribers.
4) Data consistency across screens is good for iPad apps and other apps that display the same data in multiple places at the same time.
5) Reducers are pure functions — they are easy to test.
6) Redux architecture, overall, is easy to test. You can create a test case by putting the app in any app state you want, dispatch an action and test that the state changed correctly.
7) Redux can help with state restoration by initializing the store with persisted state.
8) It’s easy to observe what’s going on in your app because all the state is centralized to the store. You can easily record state changes for debugging.
9) Redux is lightweight and a relatively simple high-level concept.
10) Redux helps separate side effects from business logic.
11) Redux embraces value types. State can’t change from underneath you.
*/

// - Cons of Redux
/*
1) You need to touch multiple files to add new functionality.
2) Requires a third-party library, but the library is very small.
3) Model layer knows about the view hierarchy and is sensitive to user-interface changes.
4) Redux can use more memory than other architectures since the store is always in memory.
5) You need to be careful with performance because of possible frequent deep copies of the app state struct.
6) Dispatching actions can result in infinite loops if you dispatch actions in response to state changes.
7) Data modeling is hard. Benefits of Redux depend on having a good data model.
8) It is designed to work with a declarative user interface framework like React. This can be awkward to apply to UIKit because UIKit is imperative. This isn’t a blocker, just that it’s not a natural fit.
9) Since the entire app state is centralized, it’s possible to have reducers that depend on each other. That removes modularity and encapsulation of a model / screen / component’s state. So refactoring a component’s state type could cause complier issue elsewhere and this is not good. You won’t run into this if you organize your reducers to only know about a module’s state and no more. This is not constrained by the architecture, though, so it depends on everyone being aware.
*/


// MARK: - Key points
// 1- Redux architecture keeps all your app’s state in a single store.
// 2- An action describes a state change. The only way to change state is to dispatch an action to the store.
// 3- Reducers are pure functions that take an action and the current state, and they return a modified state. The only place the state can change is in a reducer function.
// 4- Convert your store subscriptions into Combine publishers using the publisher methods makes it easy to work with states and onbserving state changes.
