import UIKit
import PlaygroundSupport
import SwiftUI

// The coordinator pattern is a structural design pattern for organizing flow logic between view controllers.
// It involves the following components:
// 1 - The coordinator is a protocol that defines the methods and properties all concrete coordinators must implement. Specifically, it defines relationship properties, children and router. It also defines presentation methods, present and dismiss. By holding onto coordinator protocols, instead of onto concrete coordinators directly, you can decouple a parent coordinator and its child coordinators. This enables a parent coordinator to hold onto various concrete child coordinators in a single property, children. Likewise, by holding onto a router protocol instead of a concrete router directly, you can decouple the coordinator and its router.
// 2 - The concrete coordinator implements the coordinator protocol. It knows how to create concrete view controllers and the order in which view controllers should be displayed.
// 3 - The router is a protocol that defines methods all concrete routers must implement. Specifically, it defines present and dismiss methods for showing and dismissing view controllers.
// 4 - The concrete router knows how to present view controllers, but it doesn’t know exactly what is being presented or which view controller will be presented next. Instead, the coordinator tells the router which view controller to present.
// 5 - The concrete view controllers are typical UIViewController subclasses found in MVC. However, they don’t know about other view controllers. Instead, they delegate to the coordinator whenever a transition needs to performed.

// This pattern can be adopted for only part of an app, or it can be used as an “architectural pattern” to define the structure of an entire app.

// MARK: - When should you use it?
// - Use this pattern to decouple view controllers from one another. The only component that knows about view controllers directly is the coordinator.
// - Consequently, view controllers are much more reusable: If you want to create a new flow within your app, you simply create a new coordinator!

// MARK: - Cordinator example

// first lets create router

protocol Router: AnyObject {
  // 1 - first define two present methods. The only difference is one takes an onDismissed closure, and the other doesn’t. If provided, concrete routers will execute the onDismissed whenever a view controller is dismissed
  func present(_ viewController: UIViewController, animated: Bool)
  func present(_ viewController: UIViewController, animated: Bool, onDismissed: (()->Void)?)
  // 2 - We also declare dismiss(animated:). This will dismiss the entire router. Depending on the concrete router, this may result in popping to a root view controller, calling dismiss on a parentViewController or whatever action is necessary per the concrete router’s implementation.
  func dismiss(animated: Bool)
}

extension Router {
    // 3 - here we define a default implementation for present(_:animated:). This simply calls the other present by passing nil for onDismissed.
    func present(_ viewController: UIViewController, animated: Bool) {
        present(viewController, animated: animated, onDismissed: nil)
    }
}

// 1 - We declare NavigationRouter as a subclass of NSObject. This is required because we’ll later make this conform to UINavigationControllerDelegate.
class NavigationRouter: NSObject {
    
    // 2 - We then create these instance properties:
    // navigationController will be used to push and pop view controllers.
    private let navigationController: UINavigationController // will be used to push and pop view controllers.
    
    // routerRootController will be set to the last view controller on the navigationController. We’ll use this  to dismiss the router by popping to this.
    private let routerRootController: UIViewController?
    
    // onDismissForViewController is a mapping from UIViewController to on-dismiss closures. We’ll use this to perform an on-dismiss actions whenever view controllers are popped.
    private var onDismissForViewController: [UIViewController: (() -> Void)] = [:]
    
    // 3 - we create an initializer that takes a navigationController, and we set the navigationController and routerRootController from it.
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.routerRootController = navigationController.viewControllers.first
        super.init()
        navigationController.delegate = self
    }
}

// - Router
extension NavigationRouter: Router {
    
    // 1 - Within present(_:animated:onDismissed:), we set the onDismissed closure for the given viewController and then push the view controller onto the navigationController to show it.
    func present(_ viewController: UIViewController,animated: Bool, onDismissed: (() -> Void)?) {
        onDismissForViewController[viewController] = onDismissed
        navigationController.pushViewController(viewController, animated: animated)
    }
    
    // 2 - Within dismiss(animated:), we verify that routerRootController is set.
    // If not, you simply call popToRootViewController(animated:) on the navigationController.
    // Otherwise, we call performOnDismissed(for:) to perform the on-dismiss action and then pass the routerRootController into popToViewController(_:animated:) on the navigationController.
    func dismiss(animated: Bool) {
        guard let routerRootController = routerRootController else {
            navigationController.popToRootViewController(animated: animated)
            return
        }
        performOnDismissed(for: routerRootController)
        navigationController.popToViewController(routerRootController, animated: animated)
    }
    
    // 3 - Within performOnDismiss(for:), we guard that there’s an onDismiss for the given viewController. If not, we simply return early. Otherwise, we call onDismiss and remove it from onDismissForViewController.
    private func performOnDismissed(for viewController: UIViewController) {
        guard let onDismiss = onDismissForViewController[viewController] else {
            return
        }
        onDismiss()
        onDismissForViewController[viewController] = nil
    }
}

// - UINavigationControllerDelegate
extension NavigationRouter: UINavigationControllerDelegate {
    // Inside navigationController(_:didShow:animated:), we get the from view controller from the navigationController.transitionCoordinator and verify it’s not contained within navigationController.viewControllers.
    // This indicates that the view controller was popped, and in response, we call performOnDismissed to do the on-dismiss action for the given view controller.
    func navigationController(
        _ navigationController: UINavigationController,
        didShow viewController: UIViewController,
        animated: Bool
    ) {
        let controller = navigationController.transitionCoordinator?.viewController(forKey: .from)
        guard
            let dismissedViewController = controller,
            !navigationController.viewControllers .contains(dismissedViewController)
        else { return }
        performOnDismissed(for: dismissedViewController)
    }
}

// - Coordinator
protocol Coordinator: AnyObject {
    // 1 - Here, we declare relationship properties for children and router. we’ll use these properties to provide default implementations within an extension on Coordinator next.
    var children: [Coordinator] { get set }
    var router: Router { get }
    
    // 2 - We also declare required methods for present, dismiss and presentChild.
    func present(animated: Bool, onDismissed: (() -> Void)?)
    func dismiss(animated: Bool)
    func presentChild(_ child: Coordinator, animated: Bool, onDismissed: (() -> Void)?)
}

extension Coordinator {
    // 1 - To dismiss a coordinator, we simply call dismiss on its router. This works because whoever presented the coordinator is responsible for passing an onDismiss closure to do any required teardown, which will be called by the router automatically.
    func dismiss(animated: Bool) {
        router.dismiss(animated: true)
    }
    
    // 2 - Within presentChild, we simply append the given child to children, and then call child.present.
    // We also take care of removing the child by calling removeChild(_:) within the child’s onDismissed action, and lastly, we call the provided onDismissed passed into the method itself.
    func presentChild(_ child: Coordinator, animated: Bool, onDismissed: (() -> Void)? = nil) {
        children.append(child)
        child.present(
            animated: animated,
            onDismissed: { [weak self, weak child] in
                guard let self = self, let child = child else {
                    return
                }
                self.removeChild(child)
                onDismissed?()
            }
        )
    }
    
    private func removeChild(_ child: Coordinator) {
        guard let index = children.firstIndex(where: { $0 === child }) else {
            return
        }
        children.remove(at: index)
    }
}


// - Concrete coordinator

final class HowToCodeCoordinator: Coordinator {
    // 1 - first we declare properties for children and router, which are required to conform to Coordinator and Router respectively.
    var children: [Coordinator] = []
    let router: Router
    
    // 2 - Next, we create an array called stepViewControllers, which we set by instantiating several StepViewController objects.
    private lazy var stepViewControllers = [
        StepViewController.instantiate(
            delegate: self,
            buttonColor: UIColor(red: 0.96, green: 0, blue: 0.11,
                                 alpha: 1),
            text: "When I wake up, well, I'm sure I'm gonna be\n\n" +
            "I'm gonna be the one writin' code for you",
            title: "I wake up"
        ),
        StepViewController.instantiate(
            delegate: self,
            buttonColor: UIColor(red: 0.93, green: 0.51, blue: 0.07,
                                 alpha: 1),
            text: "When I go out, well, I'm sure I'm gonna be\n\n" +
            "I'm gonna be the one thinkin' bout code for you",
            title: "I go out"
        ),
        StepViewController.instantiate(
            delegate: self,
            buttonColor: UIColor(red: 0.23, green: 0.72, blue: 0.11,
                                 alpha: 1),
            text: "Cause' I would code five hundred lines\n\n" +
            "And I would code five hundred more",
            title: "500 lines"
        ),
        StepViewController.instantiate(
            delegate: self,
            buttonColor: UIColor(red: 0.18, green: 0.29, blue: 0.80,
                                 alpha: 1),
            text: "To be the one that wrote a thousand lines\n\n" +
            "To get this code shipped out the door!",
            title: "Ship it!"
        )
    ]

    // 3 - Next, we declare a property for startOverViewController. This will be the last view controller displayed and will simply show a button to “start over.”
    private lazy var startOverViewController = StartOverViewController.instantiate(delegate: self)
    
    // 4 - Next, we create a designated initializer that accepts and sets the router.
    init(router: Router) {
        self.router = router
    }
    
    // 5 - Finally, we implement present(animated:, onDismissed:), which is required by Coordinator to start the flow.
    func present(animated: Bool, onDismissed: (() -> Void)?) {
        guard let viewController = stepViewControllers.first else { return }
        router.present(viewController,animated: animated, onDismissed: onDismissed)
    }
}

// - StepViewControllerDelegate
extension HowToCodeCoordinator: StepViewControllerDelegate {
    // Within stepViewControllerDidPressNext(_:), you first attempt to get the next StepViewController, which is returned by stepViewController(after:) as long as this isn’t the last one. You then pass this to router.present(_:animated:) to show it.
    func stepViewControllerDidPressNext(_ controller: StepViewController) {
        if let viewController = stepViewController(after: controller) {
            router.present(viewController, animated: true)
        } else {
            router.present(startOverViewController, animated: true)
        }
    }
    
    private func stepViewController(after controller: StepViewController) -> StepViewController? {
        guard
            let index = stepViewControllers.firstIndex(where: { $0 === controller }),
            index < stepViewControllers.count - 1
        else { return nil }
        return stepViewControllers[index + 1]
    }
}

// - StartOverViewControllerDelegate
extension HowToCodeCoordinator: StartOverViewControllerDelegate {
    // Whenever startOverViewControllerDidPressStartOver(_:) is called, we call router.dismiss to end the flow.
    // Ultimately, this will result in returning to the first view controller that initiated the flow, and hence, the user can start it again.
    func startOverViewControllerDidPressStartOver(_ controller: StartOverViewController) {
        router.dismiss(animated: true)
    }
}

// - DEMO
// 1 - First, we create homeViewController, and then use this to create navigationController. This will be the “home” screen. If this were actually an iOS app instead, this would be the first screen shown whenever the app is launched.
let homeViewController = HomeViewController.instantiate()
let navigationController = UINavigationController(rootViewController: homeViewController)

// 2 - Next, we create the router using the navigationController, and in turn, create the coordinator using the router.
let router = NavigationRouter(navigationController: navigationController)
let coordinator = HowToCodeCoordinator(router: router)

// 3 - Here, we set homeViewController.onButtonPressed to tell the coordinator to present, which will start its flow.
homeViewController.onButtonPressed = { [weak coordinator] in
    coordinator?.present(animated: true, onDismissed: nil)
}

// 4 - Finally, you set the PlaygroundPage.current.liveView to the navigationController, which tells Xcode to display the navigationController within the assistant editor.
navigationController.view?.frame.size = CGSize(width: 375, height: 667)
PlaygroundPage.current.liveView = navigationController


// MARK: - What should you be careful about?
// - Make sure you handle going-back functionality when using this pattern. Specifically, make sure you provide any required teardown code passed into onDismiss on the coordinator’s present(animated:onDismiss:).
// - For very simple apps, the Coordinator pattern may seem like overkill. You’ll be required to create many additional classes upfront; namely, the concrete coordinator and routers.
// - For long-term or complex apps, the coordinator pattern can help you provide needed structure and increase view controllers’ reusability.

// MARK: - Here are its key points:
// - The coordinator pattern organizes flow logic between view controllers. It involves a coordinator protocol, concrete coordinator, router protocol, concrete router and view controllers.
// - The coordinator defines methods and properties all concrete coordinators must implement.
// - The concrete coordinators know how to create concrete view controllers and their order.
// - The router defines methods all concrete routers must implement.
// - The concrete routers know how to present view controllers.
// - The concrete view controllers are typical view controllers, but they don’t know about other view controllers.
// - This pattern can be adopted for only part of an app or used across an entire application.
