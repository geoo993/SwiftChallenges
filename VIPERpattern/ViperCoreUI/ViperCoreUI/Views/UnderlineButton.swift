//
//  DefaultButton.swift
//  StoryView
//
//  Created by GEORGE QUENTIN on 23/02/2018.
//  Copyright © 2018 LEXI LABS. All rights reserved.
//

import UIKit

@IBDesignable
public class UnderlineButton: UIButton {
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }

    @IBInspectable var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }

    @IBInspectable var borderColor: UIColor? {
        get {
            return UIColor(cgColor: layer.borderColor ?? UIColor.clear.cgColor)
        }
        set {
            layer.borderColor = newValue?.cgColor ?? UIColor.clear.cgColor
        }
    }

    @IBInspectable var shadowColor: UIColor? {
        get {
            return UIColor(cgColor: layer.shadowColor ?? UIColor.clear.cgColor)
        }
        set {
            layer.shadowColor = newValue?.cgColor ?? UIColor.clear.cgColor
        }
    }

    @IBInspectable var shadowOpacity: Float {
        get {
            return layer.shadowOpacity
        }
        set {
            layer.shadowOpacity = newValue
        }
    }

    /// The shadow offset. Defaults to (0, -3). Animatable.
    @IBInspectable var shadowOffset: CGSize {
        get {
            return layer.shadowOffset
        }
        set {
            layer.shadowOffset = newValue
        }
    }

    /// The blur radius used to create the shadow. Defaults to 3. Animatable.
    @IBInspectable var shadowRadius: CGFloat {
        get {
            return layer.shadowRadius
        }
        set {
            layer.shadowRadius = newValue
        }
    }

    @IBInspectable var masksToBounds: Bool {
        get {
            return layer.masksToBounds
        }
        set {
            layer.masksToBounds = newValue
        }
    }

    private var state_: UIControl.State = .normal
    public override var state: UIControl.State {
        set {
            state_ = newValue
        }

        get {
            return state_
        }
    }
    @IBInspectable var imageTint: UIColor = UIColor.white {
        didSet {
            let tintedImage = imageView?.image?.withRenderingMode(.alwaysTemplate)
            setImage(tintedImage, for: state_)
            tintColor = imageTint
        }
    }
    
    @IBInspectable var isUnderlined: Bool = false {
        didSet {
            updateButton()
        }
    }

    override public var isEnabled: Bool {
        didSet {
            alpha = isEnabled ? 1.0 : 0.5
        }
    }
    public override init(frame: CGRect) {
        super.init(frame: frame)
        updateButton()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        updateButton()
    }

    public override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        updateButton()
    }
    
    func updateButton() {
        let color = titleLabel?.textColor ?? UIColor.white
        titleLabel?.addUnderline(foregroundColor: color, style: isUnderlined ? .single : .none)
    }
}
