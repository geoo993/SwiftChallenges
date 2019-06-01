//
//  LongPanGesture.swift
//  StorySmarties
//
//  Created by Daniel Asher on 03/06/2016.
//  Copyright © 2016 LEXI LABS. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
import protocol AppCore.Then
import UIKit

public class LongPanGesture {
    static let shouldRecognizeSimultaneouslyDelegate = ShouldRecognizeSimultaneouslyDelegate()
    let longPress = UILongPressGestureRecognizer().then {
        $0.minimumPressDuration = 0.0
        $0.delegate = shouldRecognizeSimultaneouslyDelegate
    } as UIGestureRecognizer

    let pan = UIPanGestureRecognizer().then {
        $0.maximumNumberOfTouches = 1
        $0.delegate = shouldRecognizeSimultaneouslyDelegate
    } as UIGestureRecognizer

    init(addToView: UIView?) {
        addToView?.addGestureRecognizer(longPress)
        addToView?.addGestureRecognizer(pan)
    }

    init(addTo view: UIView, gestureDelegate: UIGestureRecognizerDelegate) {
        view.addGestureRecognizer(longPress)
        view.addGestureRecognizer(pan)
        longPress.delegate = gestureDelegate
        pan.delegate = gestureDelegate
    }

    public lazy var event: Observable<UIGestureRecognizer> = {
        _ = {} // Code folding
        return self.longPress.rx.event
            .startWith(self.longPress) // Require startWith to capture longPress .Began
            .takeUntil(self.pan.rx.event)
            .concat(self.pan.rx.event)
    }()
}

class ShouldRecognizeSimultaneouslyDelegate: NSObject, UIGestureRecognizerDelegate {
    func gestureRecognizer(
        _: UIGestureRecognizer,
        shouldRecognizeSimultaneouslyWith _: UIGestureRecognizer) -> Bool {
        return true
    }
}
