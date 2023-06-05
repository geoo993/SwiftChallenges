import Foundation
import UIKit
import PlaygroundSupport

let containerFrame = CGRect(x: 0, y: 0, width: 300, height: 500)
let containerView = UIView(frame: containerFrame)
let mainView = UIView(frame: CGRect(x: 0, y: 125, width: 150, height: 250))
mainView.backgroundColor = .red
containerView.addSubview(mainView)

PlaygroundPage.current.liveView = containerView
PlaygroundPage.current.needsIndefiniteExecution = true

let inner = UIView(frame: CGRect(x: 0, y: 50, width: 150, height: 150))
inner.backgroundColor = .blue
mainView.addSubview(inner)


//square size of the grid
let size = 4

// border, here 8 points on each side
let insets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)

// available size is the total of the widths and heights of your cell views:
// bounds.width/bounds.height minus edge insets minus spacing between cells
let frame = inner.frame
let availableSize = CGSize(
    width: frame.width - insets.left - insets.right - CGFloat(size - 1) * tilesSpacing,
    height: frame.height - insets.top - insets.bottom - CGFloat(size - 1) * tilesSpacing)

// maximum width and height that will fit
let maxChildWidth = floor(availableSize.width / CGFloat(size))
let maxChildHeight = floor(availableSize.height / CGFloat(size))

// childSize should be square
let childSize = CGSize(
    width: min(maxChildWidth, maxChildHeight),
    height: min(maxChildWidth, maxChildHeight))

// total area occupied by the cell views, including spacing inbetween
let totalChildArea = CGSize(
    width: childSize.width * CGFloat(size) + tilesSpacing * CGFloat(size - 1),
    height: childSize.height * CGFloat(size) + tilesSpacing * CGFloat(size - 1))

// center everything in GridView
let topLeftCorner = CGPoint(
    x: floor((frame.width - totalChildArea.width) / 2),
    y: floor((frame.height - totalChildArea.height) / 2))

let tilesSpacing : CGFloat = 1

for row in 0..<size {
    for col in 0..<size {
        
        let button = UIButton(frame: CGRect(
            x: topLeftCorner.x + CGFloat(col) * (childSize.width + tilesSpacing),
            y: topLeftCorner.y + CGFloat(row) * (childSize.height + tilesSpacing),
            width: childSize.width,
            height: childSize.height))
        
        button.backgroundColor = UIColor.orange
        button.layer.cornerRadius = 5
        inner.addSubview(button)
    }
}
