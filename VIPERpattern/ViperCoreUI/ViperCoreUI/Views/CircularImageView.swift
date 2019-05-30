//
//  CircularImageView.swift
//  StoryView
//
//  Created by GEORGE QUENTIN on 07/05/2018.
//  Copyright © 2018 LEXI LABS. All rights reserved.
//

//https://stackoverflow.com/questions/29046571/cut-a-uiimage-into-a-circle-swiftios
//https://stackoverflow.com/questions/34984966/rounding-uiimage-and-adding-a-border

import UIKit
import ViperCore

@IBDesignable
public final class CircularImageView: UIImageView {

    @IBInspectable
    var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }

    @IBInspectable
    var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }

    @IBInspectable
    var borderColor: UIColor? {
        get {
            return UIColor(cgColor: layer.borderColor ?? UIColor.clear.cgColor)
        }
        set {
            layer.borderColor = newValue?.cgColor
        }
    }

    @IBInspectable var rotation: CGFloat = 0 {
        didSet {
            updateLayout()
        }
    }

    @IBInspectable var enableCircularImage: Bool = false {
        didSet {
            updateLayout()
        }
    }

    @IBInspectable var imageSize: CGSize = CGSize(width: 100, height: 100) {
        didSet {
            updateLayout()
        }
    }

    @IBInspectable var circularImage: UIImage = UIImage() {
        didSet {
            updateLayout()
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        updateLayout()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        updateLayout()
    }

    public override func draw(_ rect: CGRect) {
        super.draw(rect)
        updateLayout()
    }

    public override func awakeFromNib() {
        super.awakeFromNib()
        updateLayout()
    }

    func updateLayout() {
        super.image = enableCircularImage
            ? circularImage.circularImage(with: imageSize) : image
        transform = CGAffineTransform(rotationAngle: rotation.toRadians)
    }

}
