import Foundation
import UIKit

@objc public enum SectionType: Int {
    case exercise
    case game
    case finish
    case empty

    public var name: String {
        switch self {
        case .exercise: return "Exercise"
        case .game: return "Game"
        case .finish: return "Finish"
        case .empty: return "Empty"
        }
    }
    public var isExercise: Bool {
        switch self {
        case .exercise: return true
        default: return false
        }
    }
    public var isGame: Bool {
        switch self {
        case .game: return true
        default: return false
        }
    }
}

@objc public class RoadSection: NSObject {
    let path: UIBezierPath
    public let type: SectionType
    public let instance: Int

    init(path: UIBezierPath, type: SectionType, instance: Int) {
        self.path = path
        self.type = type
        self.instance = instance
    }
}

public class RoadSections {
    public let fullPath: UIBezierPath
    public let sections: [RoadSection]
    
    init(fullPath: UIBezierPath, sections: [RoadSection]) {
        self.fullPath = fullPath
        self.sections = sections
    }
}

final public class JourneyView: UIView, CAAnimationDelegate {
    var numberOfItems: Int  = 30
    var radius: CGFloat = 50
    var topPadding: CGFloat = 50
    var topSpacing: CGFloat = 70
    var bottomPadding: CGFloat = 50
    var bottomSpacing: CGFloat = 50
    var horizontalSpacing: CGFloat = 50
    var verticalSpacing: CGFloat = 50
    var pathWidth: CGFloat = 10
    var pathColor: UIColor = UIColor.cyan
    var dashLineWidth: CGFloat = 8
    var dashLineSize: CGFloat = 14
    var dashLineColor: UIColor = UIColor.white
    var enableDots: Bool = false
    var circleDotsSize: CGFloat = 5
    var circleDotsColor: UIColor = UIColor.green
    var squaresDotsSize: CGFloat = 20
    var squaresDotsExerciseColor: UIColor = UIColor.white
    var squaresDotsGameColor: UIColor = UIColor.white
    var squaresDotsEmptyColor: UIColor = UIColor.white
    var backgroundSquaresEnabled: Bool = false
    var backgroundSquaresColor: UIColor = UIColor.white
    var backgroundSquaresSize: CGFloat = 50
    var backgroundSquaresSamples: Int = 50
    var background: UIColor = UIColor.white
    var buttonsSize: CGFloat = 50

    fileprivate var completionBlocks = [CAAnimation: (Bool) -> Void]()
    fileprivate var roadSections: RoadSections!

    /// The top section has first exercise, then game.
    private let nonCycleItemsFromTop = 2

    /// The bottom section has exercise, game, exercise, then finish (ignoring finish)
    private let nonCycleItemsFromBottom = 3

    /// A cycle has 2 exercise and 2 games  (including games)
    private let itemsInOneCycle = 4

    // MARK: - View Life Cycle
    override public init(frame: CGRect) {
        super.init(frame: frame)
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    public override func draw(_ rect: CGRect) {
        updateJourneyView()
        super.draw(rect)
    }

    public override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        updateJourneyView()
    }
    // MARK: - cycles
    func cycles(using numberOfItems: Int) -> Int {
        var numberOfCycles = numberOfItems
        numberOfCycles -= (nonCycleItemsFromTop + nonCycleItemsFromBottom)
        numberOfCycles = Int(ceil(Double(numberOfCycles) / Double(itemsInOneCycle)))
        return numberOfCycles
    }

    // MARK: - Remove Views
    fileprivate func removeAllViews() {
        subviews.filter({ $0 is UIScrollView })
            .forEach({ $0.removeNestedSubviewsAndConstraints() })
        roadSections = nil
    }

    // MARK: - Update scrollView
    fileprivate func updateJourneyView() {
        #if TARGET_INTERFACE_BUILDER
        setupJourneyView()
        #else
        #endif
    }

    // MARK: - Setup scrollView
    fileprivate func setupJourneyView() {
        removeAllViews()

        // start at the top mid center of the frame
        let origin = CGPoint(x: frame.midX, y: frame.minY)
        let road = roadMap(with: origin)
        roadSections = road

        let contentSize = road.fullPath.bounds.height + bottomPadding
        let rect = CGRect(origin: frame.origin, size: CGSize(width: frame.width, height: contentSize))
        let scrollView = UIScrollView().then {
            $0.frame = frame
            $0.contentSize = rect.size
            $0.showsHorizontalScrollIndicator = false
            $0.showsVerticalScrollIndicator = false
            $0.bounces = false
            $0.bouncesZoom = false
            $0.backgroundColor = background
        }
        self.addSubview(scrollView)

        let pathSections = road.sections.map { $0.path }
        let pathShapes = pathSections
            .enumerated().map { [weak self] index, path -> CAShapeLayer in
                guard let this = self else { return CAShapeLayer() }
                return CAShapeLayer().then {
                    $0.name = "road\(index)"
                    $0.path = path.cgPath
                    $0.fillColor = UIColor.clear.cgColor
                    $0.lineWidth = this.pathWidth
                    $0.strokeColor = this.pathColor.cgColor
                    //let hue = CGFloat(index) / CGFloat(roadSections.count)
                    //$0.strokeColor = UIColor(hue: hue, saturation: 0.8, brightness: 1, alpha: 1).cgColor
                }
        }

        let pathLines = pathSections
            .enumerated().map { [weak self] index, path -> CAShapeLayer in
                guard let this = self else { return CAShapeLayer() }
                return CAShapeLayer().then {
                    $0.name = "roadline\(index)"
                    $0.path = path.cgPath
                    $0.fillColor = nil
                    $0.lineWidth = this.dashLineWidth
                    $0.strokeColor = this.dashLineColor.cgColor
                    $0.lineDashPattern = [NSNumber(value: this.dashLineSize.toDouble),
                                          NSNumber(value: this.dashLineSize.toDouble)]
                    //let hue = CGFloat(index) / CGFloat(roadSections.count)
                    //$0.strokeColor = UIColor(hue: hue, saturation: 0.8, brightness: 1, alpha: 1).cgColor
                }
        }

        if backgroundSquaresEnabled {
            let backgroundSquares = CGRect
                .freeSpaces(in: rect, minSize: backgroundSquaresSize * 0.4, maxSize: backgroundSquaresSize,
                            spacing: 10, attempts: backgroundSquaresSamples)
                .map({ rect -> UIView in
                    let rotation = CGFloat.random(min: 0, max: 360)
                    return UIView().then {
                        $0.frame = rect
                        $0.backgroundColor = backgroundSquaresColor
                        $0.transform = CGAffineTransform(rotationAngle: rotation.toRadians)
                    }
                })
            backgroundSquares.forEach { scrollView.addSubview($0) }
        }

        pathShapes.forEach { scrollView.layer.addSublayer($0) }
        pathLines.forEach { scrollView.layer.addSublayer($0) }

        if enableDots {
            var dots: [CALayer] = []
            road.fullPath.cgPath.forEach { [weak self] element in
                guard let this = self else { return }
                let dot = CALayer().then {
                    $0.backgroundColor = this.circleDotsColor.cgColor
                    $0.cornerRadius = 2
                    $0.bounds = CGRect(origin: .zero, size: CGSize(width: this.circleDotsSize, height: this.circleDotsSize))
                    $0.position = element.point
                }
                dots.append(dot)

            }
            dots.forEach { scrollView.layer.addSublayer($0) }

            let buttons = road.sections.enumerated().map { [weak self]  index, section -> CALayer in
                guard let this = self else { return  CALayer() }
                let layer = CALayer().then {
                    //$0.backgroundColor = (section.type == .game) ?
                    //    this.squaresDotsColor.inverse.cgColor : this.squaresDotsColor.cgColor
                    $0.cornerRadius = 5
                    $0.masksToBounds = true
                    $0.bounds = CGRect(origin: .zero, size: CGSize(width: this.squaresDotsSize, height: this.squaresDotsSize))
                    $0.position = section.path.currentPoint
                }
                switch section.type {
                case .exercise:
                    layer.backgroundColor = this.squaresDotsExerciseColor.cgColor
                case .game:
                    layer.backgroundColor = this.squaresDotsGameColor.cgColor
                case .empty:
                    layer.backgroundColor = this.squaresDotsEmptyColor.cgColor
                case .finish:
                    layer.backgroundColor = UIColor.black.cgColor
                }
                return layer
            }
            buttons.forEach { scrollView.layer.addSublayer($0) }
        }
    }

    // MARK: - Animate view on UIBezierPath
    fileprivate func animate(view: UIView, in section: UIBezierPath,
                             duration: CFTimeInterval, completion: (() -> Void)?) {

        view.layer.removeAllAnimations()
        view.layer.speed = 1

        CATransaction.begin()
        CATransaction.setCompletionBlock({
            completion?()
        })

        let anim = CAKeyframeAnimation().then {
            $0.path = section.cgPath
            $0.keyPath = "position"
            $0.duration = duration
            $0.fillMode = CAMediaTimingFillMode.forwards
            $0.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
            $0.isRemovedOnCompletion = false

        }
        view.layer.add(anim, forKey: "position")
        CATransaction.commit()
    }

    // MARK: - Road Bezier Path
    public func roadMap(with origin: CGPoint) -> RoadSections {

        var sections: [RoadSection] = []
        var itemsCount = 0
        var path = UIBezierPath()
        let midX = origin.x, minY = origin.y
        var yPosition: CGFloat = minY
        var exercises: Int = 0
        var games: Int = 0
        var startPoint: CGPoint = CGPoint.point(midX, minY + topPadding)
        var cycles = self.cycles(using: self.numberOfItems)
        if cycles < 0 {
            cycles = 0
        }

        startPoint = addTopSection(midX, minY, startPoint, &yPosition, &path, &sections,
                                   &exercises, &games, &itemsCount)
        for _ in 0..<cycles {
            startPoint = addLeftToRightSection(midX, minY, startPoint, &yPosition, &path, &sections,
                                               &exercises, &games, &itemsCount)
            startPoint = addRightToLeftSection(midX, minY, startPoint, &yPosition, &path, &sections,
                                               &exercises, &games, &itemsCount)
        }

        if numberOfItems >= itemsCount && numberOfItems < itemsCount + 2 {
            startPoint = addLeftToBottomSection(midX, minY, startPoint, &yPosition, &path,
                                                &sections, &exercises, &games, &itemsCount)
        } else {
            startPoint = addLeftToRightSection(midX, minY, startPoint, &yPosition, &path, &sections,
                                               &exercises, &games, &itemsCount)
            startPoint = addRightToBottomSection(midX, minY, startPoint, &yPosition, &path, &sections,
                                                 &exercises, &games, &itemsCount)
        }

        return RoadSections(fullPath: path, sections: sections)
    }

    fileprivate func addTopSection(_ midX: CGFloat, _ minY: CGFloat,
                                   _ startPoint: CGPoint, _ yPosition: inout CGFloat,
                                   _ path: inout UIBezierPath, _ sections: inout [RoadSection],
                                   _ exercises: inout Int, _ games: inout Int, _ itemsCount: inout Int) -> CGPoint {

        let diameter = radius + radius
        let halfVerticalSpacing = (verticalSpacing * 0.5)

        // position at top center
        path.move(to: startPoint)

        // move down to the top spacing
        path.addLine(to: CGPoint.point(midX, minY + topSpacing ))
        yPosition += topSpacing

        let firstSectionPath = UIBezierPath(); exercises += 1
        firstSectionPath.move(to: startPoint)
        firstSectionPath.addLine(to: CGPoint.point(midX, minY + (topSpacing * 0.7)))
        let type1: SectionType = itemsCount >= numberOfItems ? .empty : .exercise
        let firstSection = RoadSection(path: firstSectionPath, type: type1, instance: exercises)
        sections.append(firstSection)
        itemsCount += 1

        let secondSectionPath = UIBezierPath(); games += 1
        secondSectionPath.move(to: CGPoint.point(midX, minY + (topSpacing * 0.7)))
        secondSectionPath.addLine(to: CGPoint.point(midX, minY + topSpacing ))

        // top cut off
        // curving from top to the left side
        path.addArc(withCenter: CGPoint.point(midX - radius, minY + topSpacing ),
                    radius: radius, startAngle: 0, endAngle: CGFloat.pi / 2, clockwise: true)
        secondSectionPath.addArc(withCenter: CGPoint.point(midX - radius, minY + topSpacing ),
                                 radius: radius, startAngle: 0, endAngle: CGFloat.pi / 2, clockwise: true)

        // line connecting the curve on the left to the left center
        path.addLine(to: CGPoint.point(midX - radius - (horizontalSpacing), minY + topSpacing + radius ))
        secondSectionPath.addLine(to: CGPoint.point(midX - radius - (horizontalSpacing), minY + topSpacing + radius ))
        yPosition += diameter

        // curving from left center to the bottom left then to the right
        path.addArc(withCenter: CGPoint.point(midX - radius - (horizontalSpacing), minY + yPosition),
                    radius: radius, startAngle: 3 / 2 * CGFloat.pi, endAngle: CGFloat.pi, clockwise: false)
        secondSectionPath.addArc(withCenter: CGPoint.point(midX - radius - (horizontalSpacing), minY + yPosition),
                                 radius: radius, startAngle: 3 / 2 * CGFloat.pi, endAngle: CGFloat.pi, clockwise: false)
        yPosition += radius

        // line connecting the curve on the left to the center
        let lastPoint = CGPoint.point(midX - diameter - (horizontalSpacing), minY + halfVerticalSpacing + yPosition)
        path.addLine(to: lastPoint)
        secondSectionPath.addLine(to: lastPoint)
        let type2: SectionType = itemsCount >= numberOfItems ? .empty : .game
        let secondSection = RoadSection(path: secondSectionPath, type: type2, instance: games)
        sections.append(secondSection)
        itemsCount += 1

        return lastPoint
    }

    fileprivate func addLeftToRightSection(_ midX: CGFloat, _ minY: CGFloat,
                                           _ startPoint: CGPoint, _ yPosition: inout CGFloat,
                                           _ path: inout UIBezierPath, _ sections: inout [RoadSection],
                                           _ exercises: inout Int, _ games: inout Int, _ itemsCount: inout Int) -> CGPoint {

        let diameter = radius + radius
        let halfVerticalSpacing = (verticalSpacing * 0.5)

        yPosition += halfVerticalSpacing

        // filling in the last line
        let firstSectionPath = UIBezierPath(); exercises += 1
        firstSectionPath.move(to: startPoint)
        path.addLine(to: CGPoint.point(midX - diameter - (horizontalSpacing), minY + halfVerticalSpacing + yPosition ))
        firstSectionPath.addLine(to: CGPoint.point(midX - diameter - (horizontalSpacing),
                                                   minY + halfVerticalSpacing + yPosition ))
        yPosition += halfVerticalSpacing + radius

        // curving from bottom left to the right
        path.addArc(withCenter: CGPoint.point(midX - radius - (horizontalSpacing), minY + yPosition),
                    radius: radius, startAngle: CGFloat.pi, endAngle: CGFloat.pi / 2, clockwise: false)
        firstSectionPath
            .addArc(withCenter: CGPoint.point(midX - radius - (horizontalSpacing), minY + yPosition),
                    radius: radius, startAngle: CGFloat.pi, endAngle: CGFloat.pi / 2, clockwise: false)
        yPosition += radius

        // line that goes from the left side to the center
        path.addLine(to: CGPoint.point(midX, minY + yPosition ))
        firstSectionPath.addLine(to: CGPoint.point(midX, minY + yPosition ))
        let type1: SectionType = itemsCount >= numberOfItems ? .empty : .exercise
        let firstSection = RoadSection(path: firstSectionPath, type: type1, instance: exercises)
        sections.append(firstSection)
        itemsCount += 1

        let secondSectionPath = UIBezierPath(); games += 1
        secondSectionPath.move(to: CGPoint.point(midX, minY + yPosition ))
        path.addLine(to: CGPoint.point(midX + radius + horizontalSpacing, minY + yPosition ))
        secondSectionPath.addLine(to: CGPoint.point(midX + radius + horizontalSpacing, minY + yPosition ))
        yPosition += radius

        // curving from right side to bottom right
        path.addArc(withCenter: CGPoint.point(midX + radius + (horizontalSpacing), minY + yPosition),
                    radius: radius, startAngle: 3 / 2 * CGFloat.pi, endAngle: 0, clockwise: true)
        secondSectionPath.addArc(withCenter: CGPoint.point(midX + radius + (horizontalSpacing), minY + yPosition),
                                 radius: radius, startAngle: 3 / 2 * CGFloat.pi, endAngle: 0, clockwise: true)
        yPosition += radius

        // line connecting the curve on the top right to the curve on the bottom right
        let lastPoint = CGPoint.point(midX + diameter + (horizontalSpacing), minY + halfVerticalSpacing + yPosition )
        path.addLine(to: lastPoint)
        secondSectionPath.addLine(to: lastPoint)
        let type2: SectionType = itemsCount >= numberOfItems ? .empty : .game
        let secondSection = RoadSection(path: secondSectionPath, type: type2, instance: games)
        sections.append(secondSection)
        itemsCount += 1

        return lastPoint
    }

    fileprivate func addRightToLeftSection(_ midX: CGFloat, _ minY: CGFloat,
                                           _ startPoint: CGPoint, _ yPosition: inout CGFloat,
                                           _ path: inout UIBezierPath, _ sections: inout [RoadSection],
                                           _ exercises: inout Int, _ games: inout Int, _ itemsCount: inout Int) -> CGPoint {

        let diameter = radius + radius
        let halfVerticalSpacing = verticalSpacing * 0.5

        yPosition += halfVerticalSpacing

        // filling in the last line
        let firstSectionPath = UIBezierPath(); exercises += 1
        firstSectionPath.move(to: startPoint)
        path.addLine(to: CGPoint.point(midX + diameter + (horizontalSpacing), minY + halfVerticalSpacing + yPosition ))
        firstSectionPath.addLine(to: CGPoint.point(midX + diameter + (horizontalSpacing),
                                                   minY + halfVerticalSpacing + yPosition ))
        yPosition += halfVerticalSpacing + radius

        // curving from bottom right to the left
        path.addArc(withCenter: CGPoint.point(midX + radius + (horizontalSpacing), minY  + yPosition),
                    radius: radius, startAngle: 0, endAngle: CGFloat.pi / 2, clockwise: true)
        firstSectionPath.addArc(withCenter: CGPoint.point(midX + radius + (horizontalSpacing), minY + yPosition),
                                radius: radius, startAngle: 0, endAngle: CGFloat.pi / 2, clockwise: true)
        yPosition += radius

        // moving from the right to connect to the center
        path.addLine(to: CGPoint.point(midX, minY + yPosition))
        firstSectionPath.addLine(to: CGPoint.point(midX, minY + yPosition))
        let type1: SectionType = itemsCount >= numberOfItems ? .empty : .exercise
        let firstSection = RoadSection(path: firstSectionPath, type: type1, instance: exercises)
        sections.append(firstSection)
        itemsCount += 1

        // moving from the center to left side
        let secondSectionPath = UIBezierPath(); games += 1
        secondSectionPath.move(to: CGPoint.point(midX, minY + yPosition))
        path.addLine(to: CGPoint.point(midX - radius - (horizontalSpacing), minY + yPosition))
        secondSectionPath.addLine(to: CGPoint.point(midX - radius - (horizontalSpacing), minY + yPosition))
        yPosition += radius

        // curving from left side to bottom left
        path.addArc(withCenter: CGPoint.point(midX - radius - (horizontalSpacing), minY + yPosition),
                    radius: radius, startAngle: 3 / 2 * CGFloat.pi, endAngle: CGFloat.pi, clockwise: false)
        secondSectionPath.addArc(withCenter: CGPoint.point(midX - radius - (horizontalSpacing), minY + yPosition),
                                 radius: radius, startAngle: 3 / 2 * CGFloat.pi, endAngle: CGFloat.pi,
                                 clockwise: false)
        yPosition += radius

        // line connecting the top left to the bottom left
        let lastPoint = CGPoint.point(midX - diameter - (horizontalSpacing), minY + halfVerticalSpacing + yPosition )
        path.addLine(to: lastPoint)
        secondSectionPath.addLine(to: lastPoint)
        let type2: SectionType = itemsCount >= numberOfItems ? .empty : .game
        let secondSection = RoadSection(path: secondSectionPath, type: type2, instance: games)
        sections.append(secondSection)
        itemsCount += 1

        return lastPoint
    }

    fileprivate func addLeftToBottomSection(_ midX: CGFloat, _ minY: CGFloat,
                                            _ startPoint: CGPoint, _ yPosition: inout CGFloat,
                                            _ path: inout UIBezierPath, _ sections: inout [RoadSection],
                                            _ exercises: inout Int, _ games: inout Int, _ itemsCount: inout Int) -> CGPoint {

        let diameter = radius + radius
        let halfVerticalSpacing = (verticalSpacing * 0.5)

        yPosition += halfVerticalSpacing

        // filling in the last line
        let firstSectionPath = UIBezierPath(); exercises += 1
        firstSectionPath.move(to: startPoint)
        path.addLine(to: CGPoint.point(midX - diameter - (horizontalSpacing), minY + halfVerticalSpacing + yPosition ))
        firstSectionPath.addLine(to: CGPoint.point(midX - diameter - (horizontalSpacing),
                                                   minY + halfVerticalSpacing + yPosition ))
        yPosition += halfVerticalSpacing + radius

        // curving from bottom left to the right
        path.addArc(withCenter: CGPoint.point(midX - radius - (horizontalSpacing), minY + yPosition),
                    radius: radius, startAngle: CGFloat.pi, endAngle: CGFloat.pi / 2, clockwise: false)
        firstSectionPath
            .addArc(withCenter: CGPoint.point(midX - radius - (horizontalSpacing), minY + yPosition),
                    radius: radius, startAngle: CGFloat.pi, endAngle: CGFloat.pi / 2, clockwise: false)
        yPosition += radius

        // moving from the left to connect to the center
        path.addLine(to: CGPoint.point(midX - radius, minY + yPosition ))
        firstSectionPath.addLine(to: CGPoint.point(midX - radius, minY + yPosition ))

        // curving from left side to bottom left
        path.addArc(withCenter: CGPoint.point(midX - radius, minY + radius + yPosition),
                    radius: radius, startAngle: 3 / 2 * CGFloat.pi, endAngle: 0, clockwise: true)
        firstSectionPath.addArc(withCenter: CGPoint.point(midX - radius, minY + radius + yPosition),
                                 radius: radius, startAngle: 3 / 2 * CGFloat.pi, endAngle: 0,
                                 clockwise: true)
        yPosition += radius

        let type: SectionType = itemsCount >= numberOfItems ? .empty : .exercise
        let firstSection = RoadSection(path: firstSectionPath, type: type, instance: exercises)
        sections.append(firstSection)
        itemsCount += 1

        // move down to finish using the bottom spacing
        let lastPoint = CGPoint.point(midX, minY + yPosition + bottomSpacing )
        let secondSectionPath = UIBezierPath()
        secondSectionPath.move(to: CGPoint.point(midX, minY + yPosition))
        path.addLine(to: lastPoint)
        secondSectionPath.addLine(to: lastPoint)
        let secondSection = RoadSection(path: secondSectionPath, type: .finish, instance: 1)
        sections.append(secondSection)
        yPosition += bottomSpacing
        itemsCount += 1

        return lastPoint
    }

    fileprivate func addRightToBottomSection(_ midX: CGFloat, _ minY: CGFloat,
                                             _ startPoint: CGPoint, _ yPosition: inout CGFloat,
                                             _ path: inout UIBezierPath, _ sections: inout [RoadSection],
                                             _ exercises: inout Int, _ games: inout Int, _ itemsCount: inout Int) -> CGPoint {

        let diameter = radius + radius
        let halfVerticalSpacing = verticalSpacing * 0.5

        yPosition += halfVerticalSpacing

        // start from last position
        let firstSectionPath = UIBezierPath(); exercises += 1
        firstSectionPath.move(to: startPoint)
        path.addLine(to: CGPoint.point(midX + diameter + (horizontalSpacing), minY + halfVerticalSpacing + yPosition ))
        firstSectionPath.addLine(to: CGPoint.point(midX + diameter + (horizontalSpacing),
                                                   minY + halfVerticalSpacing + yPosition ))
        yPosition += halfVerticalSpacing + radius

        // curving from bottom right to the left
        path.addArc(withCenter: CGPoint.point(midX + radius + (horizontalSpacing), minY + yPosition),
                    radius: radius, startAngle: 0, endAngle: CGFloat.pi / 2, clockwise: true)
        firstSectionPath.addArc(withCenter: CGPoint.point(midX + radius + (horizontalSpacing), minY + yPosition),
                                radius: radius, startAngle: 0, endAngle: CGFloat.pi / 2, clockwise: true)
        yPosition += radius

        // moving from the right to connect to the center
        path.addLine(to: CGPoint.point(midX + radius, minY + yPosition))
        firstSectionPath.addLine(to: CGPoint.point(midX + radius, minY + yPosition))

        // cutoff from the zig, curve positioned from to the center to bottom
        path.addArc(withCenter: CGPoint.point(midX + radius, minY + radius + yPosition), radius: radius,
                    startAngle: 3 / 2 * CGFloat.pi, endAngle: CGFloat.pi, clockwise: false)
        firstSectionPath.addArc(withCenter: CGPoint.point(midX + radius, minY + radius + yPosition),
                                radius: radius, startAngle: 3 / 2 * CGFloat.pi, endAngle: CGFloat.pi, clockwise: false)
        let type: SectionType = itemsCount >= numberOfItems ? .empty : .exercise
        let firstSection = RoadSection(path: firstSectionPath, type: type, instance: exercises)
        sections.append(firstSection)
        yPosition += radius
        itemsCount += 1

        // move down to finish using the bottom spacing
        let lastPoint = CGPoint.point(midX, minY + yPosition + bottomSpacing )
        let secondSectionPath = UIBezierPath()
        secondSectionPath.move(to: CGPoint.point(midX, minY + yPosition))
        path.addLine(to: lastPoint)
        secondSectionPath.addLine(to: lastPoint)
        let secondSection = RoadSection(path: secondSectionPath, type: .finish, instance: 1)
        sections.append(secondSection)
        yPosition += bottomSpacing

        return lastPoint
    }

}
