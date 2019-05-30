//
//  Created by wddwycc on 2018/3/7.
//  2018 Copyright (c) RxSwiftCommunity. All rights reserved.
//

#if os(iOS)

import UIKit
import RxSwift
import RxCocoa


public extension Reactive where Base: UISlider {

    /// Bindable sink for `thumbTintColor` property
    var thumbTintColor: Binder<UIColor?> {
        return Binder(self.base) { view, attr in
            UIView.animate(withDuration: 0.3, animations: {
                view.thumbTintColor = attr
            })
        }
    }

    /// Bindable sink for `minimumTrackTintColor` property
    var minimumTrackTintColor: Binder<UIColor?> {
        return Binder(self.base) { view, attr in
            UIView.animate(withDuration: 0.3, animations: {
                view.minimumTrackTintColor = attr
            })
        }
    }

    /// Bindable sink for `maximumTrackTintColor` property
    var maximumTrackTintColor: Binder<UIColor?> {
        return Binder(self.base) { view, attr in
            UIView.animate(withDuration: 0.3, animations: {
                view.maximumTrackTintColor = attr
            })
        }
    }

}
#endif
