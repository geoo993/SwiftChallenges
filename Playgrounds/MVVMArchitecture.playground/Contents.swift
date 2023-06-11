import UIKit
import PlaygroundSupport

// Model-View-ViewModel (MVVM) is the new trend in the iOS community, but its roots date back to the early 2000s at Microsoft.
// Microsoft architects introduced MVVM to simplify design and development using Extensible Application Markup Language (XAML) platforms, such as Silverlight.
// Prior to MVVM, designers would drag and drop user interface components to create views, and developers would write code for each view specifically. This resulted in the tight coupling between views and business logic — changing one typically required changing the other. Designers lost freedom due to this workflow: They became hesitant to change view layouts because, doing so, often required massive code rewrites.
// Microsoft specifically introduced MVVM to decouple views and business logic. This alleviated pain points for designers: They could now change the user interface, and developers wouldn’t have to change too much code.
// Fast forward to iOS today, and you’ll find that iOS designers usually don’t modify Xcode storyboards or auto layout constraints directly. Rather, they create designs using graphical editors such as Figma. They hand these designs to developers, who, in turn, create both the views and code. Thereby, the goals of MVVM are different for iOS.
// MVVM isn’t intended to allow designers to create views via Xcode directly. Rather, iOS developers use MVVM to decouple views from models. But the benefits are the same: iOS designers can freely change the user interface, and iOS developers won’t need to change much business logic code.


// MARK: - What is it?
// MVVM is a “reactive” architecture. The view reacts to changes on the view model, and the view model updates its state based on data from the model.

// MVVM involves three layers:
// 1) - The model layer contains data access objects and validation logic. It knows how to read and write data, and it notifies the view model when data changes.
// 2) - The view model layer contains the state of the view and has methods to handle user interaction. It calls methods on the model layer to read and write data, and it notifies the view when the model’s data changes.
// 3) - The view layer styles and displays on-screen elements. It doesn’t contain business or validation logic. Instead, it binds its visual elements to properties on the view model. It also receives user inputs and interaction, and it calls methods on the view model in response.
// As a result, the view layer and model layer are completely decoupled. The view layer and model layer only communicate with the view model layer.


// MARK: - Model layer
// The model layer is responsible for all create, read, update and delete (CRUD) operations.
// You can design the model layer in many different ways; yet, two of the most common are "push-and-pull" and "observe-and-push" designs:
// - Push-and-pull designs require consumers to ask for data and wait for the response, which is the “pull” part. Consumers can also update model data and tell the model layer to send it, which is the “push” part.
// - Observe-and-push designs require consumers to “observe” the model layer, instead of asking for data directly. Like push-and-pull designs, consumers can also update model data and tell the model layer to “push” it.

// MARK: - View layer
// A view is a user interface for a screen. In MVVM, the view layer reacts to state changes through bindings to view model properties. It also notifies the view model of user interaction, like button taps or text input updates.
// The purpose of the view is to render the screen. It knows how to layout and style the user interface elements, but doesn’t know anything about business logic.
// In MVVM, you use one-way data binding to bind the UI elements from the view to the view model. This means the view model is the single source of truth. The view doesn’t update until the view model changes its state.
// The view layer contains a hierarchy of views. Each parent view knows about its children and has access to their properties.

// MARK: - View model layer
// The view model contains a view’s state, methods for handling user interaction and bindings to different user interface elements.
// The view model knows how to handle user interactions, like button taps. User interactions map to methods in the view model. The methods do some work, like making an API call, and then change the state of the view model. The state update causes the view to react.
// The purpose of the view model is to decouple the view controller from the view. Ever heard of the “massive view controller problem”? Does your view controller file seem to scroll forever? View models are here to help. They are completely separate from the view controller, and they know nothing about its implementation.
// You can replace your entire view with a different layout without changing the view model. View models give MVVM big wins in testability, since you can test them without a user interface.

// Kickstarter wrote its iOS app using view models. It has over 1,000 view model tests. On its blog, Kickstarter writes, “We write these as a pure mapping of input signals to output signals, and test them heavily, including tests for localization, accessibility, and event tracking.” This idea of “pure mapping” is at the core of MVVM. View models take input signals and produce output signals, providing a clear boundary between view models and views.

// Lets look at the structure of a view model in more depth.
// - "View State" is stored in the view model. The state is made up of @Published properties. Using Combine, the user interface subscribes to the publishers when the view model is created.
// - "Task Methods" perform tasks in response to user interactions. The methods do some work, such as calling a sign-in API, and then updating the view model’s state. The view knows if the state changes because the publishers signal new data. You usually mark task methods as @objc methods, because you have to target-action pair on a UI Control.
// - "Dependencies" are passed to the view model through initializer injection. Task methods rely on the dependencies to communicate with other subsystems in the app, such as a REST API or persistent store. View models know how to use the dependencies, but have no knowledge of the underlying implementations.

// View models sometimes use other view models to change state across the app. In this case, other view models are injected using initializer injection.


// MARK: - MVVM example

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

// - Authentication
final class AuthViewModel {
    let title = "Please Authenticate"
    let buttonAction = "Signin"
}

protocol AuthViewControllerDelegate: AnyObject {
    func didAuthenticate(_ value: Bool, name: String, controller: AuthViewController)
}

final class AuthViewController: UIViewController {
    private let viewModel: AuthViewModel
    private var content: ContentView!
    weak var delegate: AuthViewControllerDelegate?
    
    init(viewModel: AuthViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
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
        content.configure(title: viewModel.title, action: viewModel.buttonAction)
        content.addTarget(target: self, action: #selector(buttonTapped))
    }
    
    @objc private func buttonTapped() {
        delegate?.didAuthenticate(true, name: "Sam", controller: self)
    }
}

// - Welcome Flow
final class WelcomeViewModel {
    let user: User
    let message = "Yay! welcome to the best app in the world"
    var title: String {
        "Welcome 👋 \(user.name)"
    }
    
    init(user: User) {
        self.user = user
    }
}

final class WelcomeViewController: UIViewController {
    private let viewModel: WelcomeViewModel
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    init(viewModel: WelcomeViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }

    private func configure() {
        view.addSubview(titleLabel)
        title = viewModel.title
        view.backgroundColor = .yellow
        titleLabel.text = viewModel.message
        titleLabel.backgroundColor = .yellow
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        titleLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
}

// - Onboarding flow
struct User {
    let name: String
}

final class OnboardingViewModel {
    private(set) var user: User?
    private(set) var isAuthenticated = false
    
    func setData(authenticated: Bool, name: String) {
        user = User(name: name)
        isAuthenticated = authenticated
    }
}

final class OnboardingViewController: UINavigationController {
    private let viewModel: OnboardingViewModel
    private let authViewController: AuthViewController
    private var welcomeViewController: WelcomeViewController?
    private let makeWelcomeViewController: (User) -> WelcomeViewController
    
    init(
        viewModel: OnboardingViewModel,
        authViewController: AuthViewController,
        welcomeViewControllerFactory: @escaping (User) -> WelcomeViewController
    ) {
        self.viewModel = viewModel
        self.authViewController = authViewController
        self.makeWelcomeViewController = welcomeViewControllerFactory
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presentController()
    }
    
    private func presentController() {
        if viewModel.isAuthenticated, let user = viewModel.user {
            let controller = makeWelcomeViewController(user)
            setViewControllers([controller], animated: false)
            welcomeViewController = controller
        } else {
            welcomeViewController = nil
            authViewController.delegate = self
            setViewControllers([authViewController], animated: true)
        }
    }
}

extension OnboardingViewController: AuthViewControllerDelegate {
    func didAuthenticate(_ value: Bool, name: String, controller: AuthViewController) {
        viewModel.setData(authenticated: value, name: name)
        presentController()
    }
}

// - Launch flow
final class LaunchViewModel {
    let title = "Lets go..."
    let buttonAction = "Go to Onboarding"
}

final class LaunchViewController: UIViewController {
    private let viewModel: LaunchViewModel
    private var onboardingViewController: OnboardingViewController?
    private let makeOnboardingViewController: () -> OnboardingViewController
    private var content: ContentView!
    
    init(
        viewModel: LaunchViewModel,
        onboardingViewControllerFactory: @escaping () -> OnboardingViewController
    ) {
        self.viewModel = viewModel
        self.makeOnboardingViewController = onboardingViewControllerFactory
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
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
        content.configure(title: viewModel.title, action: viewModel.buttonAction)
        content.addTarget(target: self, action: #selector(buttonTapped))
    }
    
    @objc private func buttonTapped() {
        presentOnboarding()
    }
    
    private func presentOnboarding() {
        let onboardingViewController = makeOnboardingViewController()
        onboardingViewController.modalPresentationStyle = .fullScreen
        present(onboardingViewController, animated: true)
        self.onboardingViewController = onboardingViewController
    }
    
}

func makeLaunchViewController() -> LaunchViewController {
    let welcomeViewControllerFactory = { user in
        return WelcomeViewController(
            viewModel: WelcomeViewModel(user: user)
        )
    }
    let onboardingViewControllerFactory = {
        return OnboardingViewController(
            viewModel: OnboardingViewModel(),
            authViewController: AuthViewController(viewModel: AuthViewModel()),
            welcomeViewControllerFactory: welcomeViewControllerFactory
        )
    }
    return LaunchViewController(
        viewModel: LaunchViewModel(),
        onboardingViewControllerFactory: onboardingViewControllerFactory
    )
}

let controller = makeLaunchViewController()
controller.view?.frame.size = CGSize(width: 375, height: 667)
PlaygroundPage.current.liveView = controller


// MARK: - Pros and cons of MVVM
// - Pros of MVVM
/*
 
 1) View model logic is easy to test independently from the user interface code. View models contain zero UI — only business and validation logic.
 2) View and model are completely decoupled from each other. View model talks to the view and model separately.
 3) MVVM helps parallelize developer workflow. One team member can build a view while another team member builds the view model and model. Parallelizing tasks gives your team’s productivity a nice boost.
 4) While not inherently modular, MVVM does not get in the way of designing a modular structure. You can build out modular UI components using container view and child views, as long as your view models know how to communicate with each other.
 5) View models can be used across Apple platforms (iOS, tvOS, macOS, etc.) because they don’t import UIKit. Especially if view models are granular.
 */

// - Cons of MVVM
/*
1) There is a learning curve with Combine (compared to MVC.) New team members need to learn Combine and how to properly use view models. Development time may slow down at first, until new team members get up to speed.
2) Typical implementation requires view models to collaborate. Managing memory and syncing state across your app is more difficult when using collaborating view models.
3) Business logic is not reusable from different views, since business logic is inside view specific view models.
4) View models have properties for both UI state and dependencies. This means that view models can be difficult to read, because state management is mixed with side effects and dependencies.
*/


// MARK: - Key points
// - The model layer reads and writes data to disk and tells the view model when data has changed.
// - The view model layer contains all the view layer’s state and handles user interactions. The view model listens for change in the model layer and updates its state.
// - The view layer reacts when view model state changes and tells the view model when the user interacts with its components.
// - Repositories are a façade for networking and persistence. View models use repositories for data access instead of performing the actions themselves.
// - The view layer and model layer are completely decoupled. They each only communicate with the view model layer.
