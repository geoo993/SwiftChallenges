//
//  MainTabBar.swift
//  StoryView
//
//  Created by GEORGE QUENTIN on 30/04/2018.
//  Copyright © 2018 LEXI LABS. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import ViperCore

@IBDesignable public final class TabBarView: UITabBar {

    var layers = [String: CALayer]()

    @IBInspectable public var viewHeight: CGFloat = 55.0 {
        didSet {
            updateBar()
        }
    }

    @IBInspectable public var profileEmogi: String = "👽" {
        didSet {
            updateBar()
        }
    }

    @IBInspectable public var profileEmogiSize: CGSize = CGSize(width: 40, height: 40) {
        didSet {
            updateBar()
        }
    }

    @IBInspectable public var imagesSize: CGSize = CGSize(width: 30, height: 30) {
        didSet {
            updateBar()
        }
    }

    @IBInspectable public var imagesSelectedVerticalInset: CGFloat = -1.0 {
        didSet {
            updateBar()
        }
    }

    @IBInspectable public var imagesDeSelectedVerticalInset: CGFloat = 7.0 {
        didSet {
            updateBar()
        }
    }

    @IBInspectable public var labelsHorizontalInset: CGFloat = 10.0 {
        didSet {
            updateBar()
        }
    }

    @IBInspectable public var labelsVeritcalPosition: CGFloat = -2 {
        didSet {
            updateBar()
        }
    }

    @IBInspectable public var labelsCornerRadius: CGFloat = 6 {
        didSet {
            updateBar()
        }
    }

    @IBInspectable public var labelsHeight: CGFloat = 13.0 {
        didSet {
            updateBar()
        }
    }

    @IBInspectable public var labelsBackgroundColor: UIColor = UIColor.white {
        didSet {
            updateBar()
        }
    }

    @IBInspectable public var itemSelectedColor: UIColor = UIColor.white {
        didSet {
            updateBar()
        }
    }

    @IBInspectable public var itemUnSelectedColor: UIColor = UIColor.white.withAlphaComponent(0.5) {
        didSet {
            updateBar()
        }
    }

    @IBInspectable public var lineSeperatorHeight: CGFloat = 0.5 {
        didSet {
            updateBar()
        }
    }

    @IBInspectable public var lineSeperatorColor: UIColor = UIColor.gray {
        didSet {
            updateBar()
        }
    }

    @IBInspectable var labelsFontSize: CGFloat = 10 {
        didSet {
            updateBar()
        }
    }
    
    var isIphoneXDevice: Bool {
        switch UIDevice.current.modelName {
        case .iPhoneX, .iPhoneXR, .iPhoneXS, .iPhoneXSMax:
            return true
        default:
            return false
        }
    }
    
    public override func sizeThatFits(_ size: CGSize) -> CGSize {
        var sizeThatFits = super.sizeThatFits(size)
        if viewHeight > 0.0 {
            if #available(iOS 11.0, *), isIphoneXDevice {
                let extentedHeight = window?.safeAreaInsets.bottom ?? 0.0
                sizeThatFits.height = viewHeight + extentedHeight
            } else {
                sizeThatFits.height = viewHeight
            }
        }
        return sizeThatFits
    }

    override init (frame: CGRect) {
        super.init(frame: frame)
        setupLayers()
        updateBar()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupLayers()
        updateBar()
    }

    public override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        setupLayers()
        updateBar()
    }

    public func updateColor(index: Int) -> UIColor {
        switch index {
        case 0:
            // profile
            return .weirdGreen
        case 1:
            // reading area
            return .darkSkyBlue
        case 2:
            // listening area
            return .pumpkinOrange
        case 3:
            // shop
            return .sunflowerYellow
        default:
            return .white
        }
    }

    func setupLayers() {
        let background = CALayer()
        layer.addSublayer(background)
        layers["topBorder"] = background
    }

    public func updateBar () {

        let topBorder = layers["topBorder"]
        topBorder?.frame = CGRect(x:0.0, y: 0.0, width: frame.size.width, height: lineSeperatorHeight)
        topBorder?.backgroundColor = lineSeperatorColor.cgColor

        let selectedItem = self.selectedItem ?? self.items?.first ?? UITabBarItem()
        let selectedItemIndex = selectedItem.tag
        let selectedItemTitle = selectedItem.title
        barTintColor = updateColor(index: selectedItemIndex)

        // update the selected bar item frames
        let tabItems = items ?? []
        tabItems.forEach ({
            $0.imageInsets = UIEdgeInsets(top: imagesDeSelectedVerticalInset, left: 0, bottom: -imagesDeSelectedVerticalInset, right: 0)
        })
        selectedItem.imageInsets = UIEdgeInsets(top: imagesSelectedVerticalInset, left: 0, bottom: -imagesSelectedVerticalInset, right: 0)
        selectedItem.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: labelsVeritcalPosition)

        // update profile bar item emoji image
        let emojiimage = profileEmogi.toUIImage(with: profileEmogiSize).withRenderingMode(.alwaysOriginal)
        if let profile = tabItems.first(where: { $0.title == "Profile" }) {
            profile.selectedImage = emojiimage
            profile.image = emojiimage
            profile.landscapeImagePhone = emojiimage
        }
        // update remaining unselected tabBar items
        for tabBarItemView in subviews {

            if let titleLabel = tabBarItemView.subviews.first(where: { $0 is UILabel }) as? UILabel,
                let imageView = tabBarItemView.subviews.first(where: { $0 is UIImageView }) as? UIImageView {
                let isNotSelected = (selectedItemTitle != titleLabel.text)
                let isProfile = (titleLabel.text == "Profile")
                imageView.frame.size = isProfile ? profileEmogiSize : imagesSize
                imageView.tintColor = isNotSelected ? itemUnSelectedColor : itemSelectedColor

                let labelWidth = titleLabel.text?.widthOfString(usingFont: titleLabel.font) ?? 0
                titleLabel.backgroundColor = labelsBackgroundColor
                titleLabel.font = UIFont(name: FamilyName.quicksandMedium, size: labelsFontSize)
                titleLabel.frame.size = CGSize(width: labelWidth + labelsHorizontalInset, height: labelsHeight)
                titleLabel.layer.cornerRadius = labelsCornerRadius
                titleLabel.textAlignment = .center
                titleLabel.clipsToBounds = true
                titleLabel.isHidden = isNotSelected
            }
        }
    }

}

public extension Reactive where Base: TabBarView {

    /// Bindable sink for `profileEmogi` property.
    var profileEmogi: Binder<String> {
        return Binder(self.base) { view, emoji in
            view.profileEmogi = emoji
        }
    }

}
