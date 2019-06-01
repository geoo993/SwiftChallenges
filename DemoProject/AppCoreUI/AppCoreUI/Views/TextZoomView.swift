//
//  TextZoomView.swift
//  StoryView
//
//  Created by Daniel Asher on 04/12/2017.
//  Copyright © 2017 LEXI LABS. All rights reserved.
//

import UIKit

class TextZoomView: UIView {
    override class var layerClass: AnyClass {
        return CATextLayer.self
    }

    var textLayer: CATextLayer {
        return layer as? CATextLayer ?? CATextLayer()
    }

    var text: NSAttributedString? {
        didSet {
            textLayer.string = text
        }
    }

    var cornerRadius: Double = 0.0 {
        didSet {
            layer.cornerRadius = CGFloat(cornerRadius)
        }
    }

    var alignment: NSTextAlignment {
        didSet {
            switch alignment {
            case .center:
                textLayer.alignmentMode = CATextLayerAlignmentMode.center
            case .left:
                textLayer.alignmentMode = CATextLayerAlignmentMode.left
            case .right:
                textLayer.alignmentMode = CATextLayerAlignmentMode.right
            default:
                break
            }
        }
    }

    override init(frame: CGRect) {
        alignment = .center
        super.init(frame: frame)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        alignment = .center
        super.init(coder: aDecoder)
        setup()
    }

    func setup() {
//        textLayer.frame = CGRect(origin: .zero, size: bounds.size)
        textLayer.contentsScale = UIScreen.main.scale
    }
}
