//
//  RxUIView.swift
//  StoryView
//
//  Created by GEORGE QUENTIN on 02/06/2018.
//  Copyright © 2018 LEXI LABS. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

public extension Reactive where Base: UILabel {
//    /// Bindable sink for `hidden` property.
//    var textColor: Binder<UIColor> {
//        return Binder(self.base) { view, color in
//            view.textColor = color
//        }
//    }
    /// Bindable sink for `fontSize` property. Warning: beware of the view life cycle, it can override this
    var fontSize: Binder<CGFloat> {
        return Binder(self.base) { (view: UILabel, size: CGFloat) in
            view.font = view.font.withSize(size)
        }
    }
}
