
import Foundation

public extension UINavigationController {

    func setRootViewController (_ vc : UIViewController) {
        popToRootViewController(animated: false)
        setViewControllers([vc], animated: true)
    }

    func push(viewController: UIViewController, animated: Bool, completion: (() -> Void)?) {
        CATransaction.begin()
        CATransaction.setCompletionBlock(completion)
        pushViewController(viewController, animated: animated)
        CATransaction.commit()
    }

    func pop(animated: Bool, completion: (() -> Void)?) {
        CATransaction.begin()
        CATransaction.setCompletionBlock(completion)
        popViewController(animated: animated)
        CATransaction.commit()
    }
    
    func popTo(viewController: UIViewController, animated: Bool, completion: @escaping () -> Void) {
        self.popToViewController(viewController, animated: animated)
        self.callCompletion(animated: animated, completion: completion)
    }

    private func callCompletion(animated: Bool, completion: @escaping () -> Void) {
        if animated, let coordinator = self.transitionCoordinator {
            coordinator.animate(alongsideTransition: nil) { _ in
                completion()
            }
        } else {
            completion()
        }
    }
    

    var rootViewControllerInNavigationStack : UIViewController? {
        return viewControllers.first
    }

    func previousViewControllerInNavigationStack() -> UIViewController? {
        guard let _ = self.navigationController else {
            return nil
        }

        guard let viewControllers = self.navigationController?.viewControllers else {
            return nil
        }

        guard viewControllers.count >= 2 else {
            return nil
        }
        return viewControllers[viewControllers.count - 2]
    }

    func popNavigationStack<T : UIViewController>(to target: T.Type, animated: Bool = true) {
        let popToTargetVC : () -> Void = {

            while !(self.topViewController is T) {
                self.popViewController(animated: false)
                if self.viewControllers.first == self.topViewController {
                    break
                }
            }
        }

        if self.topViewController?.presentedViewController != nil {
            self.topViewController?.dismiss(animated: animated, completion: {
                popToTargetVC()
            })
        } else {
            popToTargetVC()
        }
    }

    func remove<T: UIViewController>(type target: T.Type, animated: Bool = true ) {

        for tempVC: UIViewController in self.viewControllers
        {
            if tempVC.isKind(of: T.classForCoder()) {
                tempVC.removeFromParent()
            }
        }
    }

    func removeAllBut<T: UIViewController>(type target: T.Type, animated: Bool = true ) {

        for tempVC: UIViewController in self.viewControllers
        {
            if tempVC.isKind(of: T.classForCoder()) == false {
                tempVC.removeFromParent()
            }
        }
    }
    // TODO: SWIFT4-2 Consider using CATransitionType in parameter list
    func addTransition(transitionType type: String = CATransitionType.fade.rawValue,
                              subtype: String = CATransitionType.reveal.rawValue,
                              duration: CFTimeInterval = 0.3) {
        let transition = CATransition()
        transition.duration = duration
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        transition.type = CATransitionType(rawValue: type)
        self.view.layer.add(transition, forKey: nil)
    }

}
