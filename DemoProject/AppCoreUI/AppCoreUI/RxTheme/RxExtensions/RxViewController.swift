
import Foundation
import RxCocoa
import RxSwift
import UIKit

public extension Reactive where Base: NSLayoutManagerDelegate {
    /// Rx observable on NSLayoutManagerDelegate that triggers when layout is completed.
    var didCompleteLayout: ControlEvent<[Any]> {
        let source = methodInvoked(#selector(Base.self.layoutManager(_:didCompleteLayoutFor:atEnd:)))
        return ControlEvent(events: source)
    }

    /// Rx observable on NSLayoutManagerDelegate that triggers when layout is completed and debounced.
    func didCompleteLayoutLatest(withDebounceOf debounceTime: RxTimeInterval = RxTimeInterval.milliseconds(100)) -> ControlEvent<[Any]> {
        let source = didCompleteLayout.debounce(debounceTime, scheduler: MainScheduler.instance)
        return ControlEvent(events: source)
    }
}

public extension Reactive where Base: UIViewController {
    /// Rx observable, on UIViewController that triggers when view has loaded.
    var viewDidLoad: ControlEvent<Void> {
        let source = methodInvoked(#selector(Base.viewDidLoad)).map { _ in }
        return ControlEvent(events: source)
    }

    /// Rx observable on UIViewController that triggers when view will appear.
    var viewWillAppear: ControlEvent<Bool> {
        let source = methodInvoked(#selector(Base.viewWillAppear)).map { $0.first as? Bool ?? false }
        return ControlEvent(events: source)
    }

    /// Rx observable on UIViewController that triggers when view did appear.
    var viewDidAppear: ControlEvent<Bool> {
        let source = methodInvoked(#selector(Base.viewDidAppear)).map { $0.first as? Bool ?? false }
        return ControlEvent(events: source)
    }

    /// Rx observable on UIViewController that triggers when view will disappear.
    var viewWillDisappear: ControlEvent<Bool> {
        let source = methodInvoked(#selector(Base.viewWillDisappear)).map { $0.first as? Bool ?? false }
        return ControlEvent(events: source)
    }

    /// Rx observable on UIViewController that triggers when view has disappeared.
    var viewDidDisappear: ControlEvent<Bool> {
        let source = methodInvoked(#selector(Base.viewDidDisappear)).map { $0.first as? Bool ?? false }
        return ControlEvent(events: source)
    }

    /// Rx observable on UIViewController that triggers when view will layout subviews.
    var viewWillLayoutSubviews: ControlEvent<Void> {
        let source = methodInvoked(#selector(Base.viewWillLayoutSubviews)).map { _ in }
        return ControlEvent(events: source)
    }

    /// Rx observable on UIViewController that triggers when view did layout subviews.
    var viewDidLayoutSubviews: ControlEvent<Void> {
        let source = methodInvoked(#selector(Base.viewDidLayoutSubviews)).map { _ in }
        return ControlEvent(events: source)
    }

    /// Rx observable on UIViewController that triggers when view will move to parent view controller.
    var willMoveToParentViewController: ControlEvent<UIViewController?> {
        let source = methodInvoked(#selector(Base.willMove)).map { $0.first as? UIViewController }
        return ControlEvent(events: source)
    }

    /// Rx observable on UIViewController that triggers when view did move to parent view controller.
    var didMoveToParentViewController: ControlEvent<UIViewController?> {
        let source = methodInvoked(#selector(Base.didMove)).map { $0.first as? UIViewController }
        return ControlEvent(events: source)
    }

    /// Rx observable on UIViewController that triggers when view received memory warning.
    var didReceiveMemoryWarning: ControlEvent<Void> {
        let source = methodInvoked(#selector(Base.didReceiveMemoryWarning)).map { _ in }
        return ControlEvent(events: source)
    }

    /// Rx observable, triggered when the ViewController appearance state changes
    /// (true if the View is being displayed, false otherwise)
    var isVisible: Observable<Bool> {
        let viewDidAppearObservable = base.rx.viewDidAppear.map { _ in true }
        let viewWillDisappearObservable = base.rx.viewWillDisappear.map { _ in false }
        return Observable<Bool>.merge(viewDidAppearObservable, viewWillDisappearObservable)
    }

    /// Rx observable, triggered when the ViewController is being dismissed
    var isDismissing: ControlEvent<Bool> {
        let source = sentMessage(#selector(Base.dismiss)).map { $0.first as? Bool ?? false }
        return ControlEvent(events: source)
    }

    /// FIXME: Remove force_cast
    /// Rx observable, trigger when the ViewController is preparing to segue to a second view controller
    var prepare: ControlEvent<(segue: UIStoryboardSegue, sender: Any?)> {
        let source = methodInvoked(#selector(Base.prepare(for:sender:)))
            .map { (segue: $0.first! as! UIStoryboardSegue, sender: $0[1] as Any?) }

        return ControlEvent(events: source)
    }

    /// Present a view controller and return a Completable
    func present(viewController: UIViewController, animated: Bool = true) -> Completable {
        return Completable.create { [weak base = self.base] completable in
            guard let base = base else { return Disposables.create() }
            base.present(viewController, animated: animated, completion: {
                completable(.completed)
            })
            return Disposables.create()
        }
    }

    /// Dismiss a view controller and return a Completable
    func dismiss(animated: Bool = true) -> Completable {
        return Completable.create { [weak base = self.base] completable in
            guard let base = base else { return Disposables.create() }
            base.dismiss(animated: animated, completion: {
                completable(.completed)
            })
            return Disposables.create()
        }
    }
}

public extension Reactive where Base: UITabBarController {
    /// Rx observable, trigger when the TabBar item is selected
    var didSelect: ControlEvent<(tabBar: UITabBar, item: UITabBarItem)> {
        let source = methodInvoked(#selector(Base.tabBar(_:didSelect:)))
            .map { (tabBar: $0.first! as! UITabBar, item: $0[1] as! UITabBarItem) }
        return ControlEvent(events: source)
    }
}

public extension Reactive where Base: UIPageViewController {

    /// Set view controllers for pageViewController and return a Completable
    func setViewControllers(viewControllers: [UIViewController],
                                   direction: UIPageViewController.NavigationDirection,
                                   animated: Bool = true) -> Completable {
        return Completable.create { completable in
            self.base.setViewControllers(viewControllers, direction: direction, animated: animated,
                                         completion: { _ in completable(.completed) })
            return Disposables.create()
        }
    }
}
