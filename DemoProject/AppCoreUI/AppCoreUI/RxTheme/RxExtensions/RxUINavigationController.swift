//
//  UIViewController+Rx.swift
//  StoryView
//
//  Created by Daniel Asher on 12/02/2018.
//  Copyright © 2018 LEXI LABS. All rights reserved.
//

import RxCocoa
import RxSwift
//import ViperCore

public extension Reactive where Base: UINavigationController {
    /// Rx observable, on UINavigationController that triggers when topViewcontroller has changed.
    var topViewController: ControlEvent<UIViewController?> {
        let source = methodInvoked(#selector(Base.viewDidLoad)).map { _ in self.base.topViewController }
        return ControlEvent(events: source)
    }
    /// push a view controller and return a Completable
    func push(viewController: UIViewController, animated: Bool = true) -> Completable {
        return Completable.create { [weak base = self.base] completable in
            guard let base = base else { return Disposables.create() }
            base.push(viewController: viewController, animated: animated, completion: {
                completable(.completed)
            })
            return Disposables.create()
        }
    }
    
}
