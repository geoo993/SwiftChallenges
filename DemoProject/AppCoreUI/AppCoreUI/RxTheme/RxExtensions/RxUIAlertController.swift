//
//  RxUIAlertController.swift
//  StoryView
//
//  Created by GEORGE QUENTIN on 10/06/2018.
//  Copyright © 2018 LEXI LABS. All rights reserved.
//
// https://gist.github.com/RyogaK/41f55c88250d5882f0e7d10240c4c866

import Foundation
import RxSwift

public protocol RxAlertActionType {
    associatedtype Result

    var title: String? { get }
    var style: UIAlertAction.Style { get }
    var result: Result { get }
}

public struct RxAlertAction<R>: RxAlertActionType {
    public typealias Result = R

    public let title: String?
    public let style: UIAlertAction.Style
    public let result: R
    public init(title: String, style: UIAlertAction.Style, result: R) {
        self.title = title
        self.style = style
        self.result = result
    }
}

public struct RxDefaultAlertAction: RxAlertActionType {
    public typealias Result = RxAlertControllerResult

    public let title: String?
    public let style: UIAlertAction.Style
    public let result: Result
    public init(title: String, style: UIAlertAction.Style, result: Result) {
        self.title = title
        self.style = style
        self.result = result
    }
}

public enum RxAlertControllerResult {
    case Ok
}

public extension Reactive where Base: UIAlertController {

    /// Rx observable on UIAlertController, using presentingViewController that will present the UIAlertController
    // TODO: 🏋️‍♀️ Transform to Signal implementation
    func present<Action: RxAlertActionType, Result>
        (presentingViewController: UIViewController, animated: Bool = true, actions: [Action])
        -> Observable<Result> where Action.Result == Result {
        return Observable.create { observer -> Disposable in
            let alertController = self.base
            actions.map { rxAction in
                UIAlertAction(title: rxAction.title, style: rxAction.style, handler: { _ in
                    observer.onNext(rxAction.result)
                    observer.onCompleted()
                })
            }.forEach(alertController.addAction)

            presentingViewController.present(alertController, animated: animated, completion: nil)
            return alertController.rx.isDismissing.subscribe()
        }
    }

}

extension UIAlertController {
    static func rx_present<Action: RxAlertActionType, Result>
        (viewController: UIViewController, title: String, message: String,
         preferredStyle: UIAlertController.Style = .alert, animated: Bool = true, actions: [Action])
        -> Observable<Result> where Action.Result == Result {
        return Observable.create { observer -> Disposable in
            let alertController =
                UIAlertController(title: title, message: message, preferredStyle: preferredStyle)

            actions.map { rxAction in
                UIAlertAction(title: rxAction.title, style: rxAction.style, handler: { _ in
                    observer.onNext(rxAction.result)
                    observer.onCompleted()
                })
            }.forEach(alertController.addAction)

            viewController.present(alertController, animated: animated, completion: nil)
            return alertController.rx.isDismissing.subscribe()
        }
    }
}
