//: [Previous](@previous)

import UIKit
import Foundation
import PlaygroundSupport

let mainFrame = CGRect(origin: .init(x: 250, y: 0), size: .init(width: 500, height: 1000))

let journey = JourneyView(frame: mainFrame).then {
    $0.backgroundColor = .blue
}

let road = journey.roadMap(with: mainFrame.origin).fullPath
road.rotate(inRadians: CGFloat.pi)

let subpaths = road.extractSubpaths()
var counter = 0
var totalLength: CGFloat = 0

var dots: [CALayer] = []
var roadSections: [UIBezierPath] = []

road.cgPath.forEach { element in
    let dot = CALayer().then {
        $0.backgroundColor = UIColor.red.cgColor
        $0.cornerRadius = 2
        $0.bounds = CGRect(origin: .zero, size: CGSize(width: 4, height: 4))
        $0.position = element.point
    }
    dots.append(dot)
    switch element.type {
    case .moveToPoint:
        let nextPath = UIBezierPath()
        nextPath.move(to: element.point)
        roadSections.append(nextPath)
        return
    case .addLineToPoint:
        roadSections.last!.addLine(to: element.point)
    case .addQuadCurveToPoint:
        roadSections.last!.addQuadCurve(to: element.points[1], controlPoint: element.points[0])
    case .addCurveToPoint:
        roadSections.last!.addCurve(to: element.points[2], controlPoint1: element.points[0], controlPoint2: element.points[1])
    case .closeSubpath:
        break
    }
    totalLength += subpaths[counter].length
    counter += 1
    if totalLength > 100 {
        let nextPath = UIBezierPath()
        nextPath.move(to: element.point)
        roadSections.append(nextPath)
        totalLength = 0
    }
}

let pathShapes = roadSections.enumerated().map { index, path in
    CAShapeLayer().then {
        $0.path = path.cgPath
        $0.fillColor = UIColor.clear.cgColor
        $0.lineWidth = 10
        let hue = CGFloat(index) / CGFloat(roadSections.count)
        $0.strokeColor = UIColor(hue: hue, saturation: 0.8, brightness: 1, alpha: 1).cgColor
    }
}

let emojiLabel = UILabel().then {
    $0.text = "👽"
    $0.font = UIFont.systemFont(ofSize: 30)
    $0.frame = CGRect(origin: CGPoint(x: mainFrame.midX, y: 20), size: CGSize(width: 50, height: 50))
}

let buttonShapes = roadSections.enumerated().map { index, section -> UIView in
    let button = UIView()
    button.tag = index
    _ = button.layer.then {
        $0.backgroundColor = UIColor.cyan.cgColor
        $0.borderWidth = 6
        $0.borderColor = UIColor.blue.cgColor
        $0.cornerRadius = 2
        $0.bounds = CGRect(origin: .zero, size: CGSize(width: 30, height: 30))
        $0.position = section.currentPoint
    }
    let anim = CAKeyframeAnimation().then {
        $0.path = section.cgPath
        $0.keyPath = "position"
        $0.duration = 3
        $0.fillMode = CAMediaTimingFillMode.forwards
        $0.isRemovedOnCompletion = false
    }
//    button.rx.tapGesture().when(.recognized).subscribe(onNext: { _ in
//        print(button.tag)
//        emojiLabel.layer.add(anim, forKey: "animation")
//    })
    return button
}

let pathView = UIView(frame: mainFrame)

pathView.backgroundColor = UIColor.black
pathShapes.forEach { pathView.layer.addSublayer($0) }
dots.forEach { pathView.layer.addSublayer($0) }
buttonShapes.forEach { pathView.addSubview($0) }
pathView.addSubview(emojiLabel)

PlaygroundPage.current.liveView = pathView
