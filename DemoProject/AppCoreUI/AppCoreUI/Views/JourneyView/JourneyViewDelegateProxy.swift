//
//  JourneyViewDelegateProxy.swift
//  StoryView
//
//  Created by GEORGE QUENTIN on 27/05/2018.
//  Copyright © 2018 LEXI LABS. All rights reserved.
//
// https://medium.com/@sudomax/rxswift-migrate-delegates-to-beautiful-observables-3e606a863048
// https://github.com/ReactiveX/RxSwift/issues/1460
// https://github.com/GabrielAraujo/RxGoogleMaps/blob/master/Sources/GMSMapView%2BRx.swift

import RxSwift
import RxCocoa

final class JourneyViewDelegateProxy: DelegateProxy<JourneyView, JourneyViewDelegate>,
DelegateProxyType, JourneyViewDelegate {

    /// Typed parent object.
    weak private(set) var journeyView: JourneyView?

    public var didAddFirst = PublishSubject<(section: RoadSection, index: Int)>()
    public var didAddFinish = PublishSubject<(section: RoadSection, index: Int)>()
    public var didAddExercise = PublishSubject<(section: RoadSection, index: Int, parent: UIView)>()
    public var didAddGame = PublishSubject<(section: RoadSection, index: Int, parent: UIView)>()
    public var didSelect = PublishSubject<(section: RoadSection, index: Int)>()

    /// - parameter journeyView: Parent object for delegate proxy.
    init(parentObject: JourneyView) {
        self.journeyView = parentObject
        super.init(parentObject: parentObject, delegateProxy: JourneyViewDelegateProxy.self)
    }

    // Register known implementationss
    static func registerKnownImplementations() {
        self.register { JourneyViewDelegateProxy(parentObject: $0) }
    }

    //We need a way to read the current delegate
    class func currentDelegate(for object: JourneyView) -> JourneyViewDelegate? {
        return object.delegate
    }

    //We need a way to set the current delegate
    class func setCurrentDelegate(_ delegate: JourneyViewDelegate?, to object: JourneyView) {
        object.delegate = delegate as? JourneyViewDelegateProxy
    }

    // MARK: delegate methods
    func journeyView(didAddFirst section: RoadSection, at index: Int) {
        didAddFirst.onNext((section, index))
    }

    func journeyView(didAddFinish section: RoadSection, at index: Int) {
        didAddFinish.onNext((section, index))
    }

    func journeyView(didAddExercise section: RoadSection, at index: Int, with parent: UIView) {
        didAddExercise.onNext((section, index, parent))
    }

    func journeyView(didAddGame section: RoadSection, at index: Int, with parent: UIView) {
        didAddGame.onNext((section, index, parent))
    }

    func journeyView(didSelect section: RoadSection, at index: Int) {
        didSelect.onNext((section, index))
    }

    deinit {
        didAddFirst.on(.completed)
        didAddFinish.on(.completed)
        didSelect.on(.completed)
        didAddExercise.on(.completed)
        didAddGame.on(.completed)
    }

}
