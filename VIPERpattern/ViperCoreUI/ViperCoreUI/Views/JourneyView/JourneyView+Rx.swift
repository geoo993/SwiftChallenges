//
//  JourneyView+Rx.swift
//  StoryView
//
//  Created by GEORGE QUENTIN on 27/05/2018.
//  Copyright © 2018 LEXI LABS. All rights reserved.
//
// swiftlint:disable large_tuple

import RxSwift
import RxCocoa

private func castOrThrow<T>(_ resultType: T.Type, _ object: Any) throws -> T {
    guard let returnValue = object as? T else {
        throw RxCocoaError.castingError(object: object, targetType: resultType)
    }

    return returnValue
}

public extension Reactive where Base: JourneyView {

    /// Reactive wrapper for `delegate`.
    /// For more information take a look at `DelegateProxyType` protocol documentation.
    //var delegate: DelegateProxy<JourneyView, JourneyViewDelegate> {
    fileprivate var delegate: JourneyViewDelegateProxy {
        return JourneyViewDelegateProxy.proxy(for: base)
    }

    func setDelegate(_ delegate: JourneyViewDelegate) -> Disposable {
        return JourneyViewDelegateProxy
            .installForwardDelegate(delegate, retainDelegate: false, onProxyForObject: self.base)
    }

    var didAddFirst: ControlEvent<(section: RoadSection, index: Int)> {
        return ControlEvent(events: delegate.didAddFirst)
    }

    var didAddFinish: ControlEvent<(section: RoadSection, index: Int)> {
        return ControlEvent(events: delegate.didAddFinish)
    }

    var didAddExercise: ControlEvent<(section: RoadSection, index: Int, parent: UIView)> {
        return ControlEvent(events: delegate.didAddExercise)
    }

    var didAddGame: ControlEvent<(section: RoadSection, index: Int, parent: UIView)> {
        return ControlEvent(events: delegate.didAddGame)
    }

    var didSelect: ControlEvent<(section: RoadSection, index: Int)> {
        return ControlEvent(events: delegate.didSelect)
    }

}
