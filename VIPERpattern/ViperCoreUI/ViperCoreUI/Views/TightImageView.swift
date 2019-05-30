//
//  TightImageView.swift
//  StoryView
//
//  Created by Daniel Asher on 10/01/2018.
//  Copyright © 2018 LEXI LABS. All rights reserved.
//

import AVFoundation
import UIKit

class TightImageView: UIImageView {
    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override var intrinsicContentSize: CGSize {
        if let image = self.image, self.frame.width > 0 {
            switch contentMode {
            case .scaleAspectFit:
                let frame = AVMakeRect(aspectRatio: image.size, insideRect: self.frame)
                return CGSize(width: frame.width, height: frame.height)
            case .scaleAspectFill:
                let boundingRect = CGRect(x: 0, y: 0, width: self.frame.width, height: CGFloat.infinity)
                let frame = AVMakeRect(aspectRatio: image.size, insideRect: boundingRect)
                return CGSize(width: frame.width, height: frame.height)
            default:
                return super.intrinsicContentSize
            }
        }

        return super.intrinsicContentSize
    }
}
