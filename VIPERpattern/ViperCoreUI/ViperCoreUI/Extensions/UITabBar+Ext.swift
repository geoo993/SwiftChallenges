//
//  UITabBar+Ext.swift
//  StoryView
//
//  Created by GEORGE QUENTIN on 03/03/2019.
//  Copyright © 2019 LEXI LABS. All rights reserved.
//

import UIKit

extension UITabBar {
    // Workaround for iOS 11's new UITabBar behavior where on iPad, the UITabBar inside
    // the Master view controller shows the UITabBarItem icon next to the text
    override open var traitCollection: UITraitCollection {
        if UIDevice.current.userInterfaceIdiom == .pad {
            return UITraitCollection(horizontalSizeClass: .compact)
        }
        return super.traitCollection
    }
}
