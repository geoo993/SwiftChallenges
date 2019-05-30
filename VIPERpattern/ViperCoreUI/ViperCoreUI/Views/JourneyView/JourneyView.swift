//
//  JourneyView.swift
//
//  Code generated using QuartzCode 1.63.0 on 01/02/2018.
//  www.quartzcodeapp.com
//

import UIKit
import RxSwift
import RxCocoa
import ViperCore

extension JourneyView: HasDelegate {
    public typealias Delegate = JourneyViewDelegate
}

@IBDesignable
final public class JourneyView: UIView, CAAnimationDelegate {

    // MARK: - IBInspectable Items
    @IBInspectable var numberOfItems: Int  = 30 {
        didSet {
            updateJourneyView()
        }
    }

    @IBInspectable var radius: CGFloat = 50 {
        didSet {
            updateJourneyView()
        }
    }

    @IBInspectable var topPadding: CGFloat = 50 {
        didSet {
            updateJourneyView()
        }
    }

    @IBInspectable var topSpacing: CGFloat = 70 {
        didSet {
            updateJourneyView()
        }
    }

    @IBInspectable var bottomPadding: CGFloat = 50 {
        didSet {
            updateJourneyView()
        }
    }

    @IBInspectable var bottomSpacing: CGFloat = 50 {
        didSet {
            updateJourneyView()
        }
    }

    @IBInspectable var horizontalSpacing: CGFloat = 50 {
        didSet {
            updateJourneyView()
        }
    }

    @IBInspectable var verticalSpacing: CGFloat = 50 {
        didSet {
            updateJourneyView()
        }
    }

    @IBInspectable var pathWidth: CGFloat = 10 {
        didSet {
            updateJourneyView()
        }
    }

    @IBInspectable var pathColor: UIColor = UIColor.cyan {
        didSet {
            updateJourneyView()
        }
    }

    @IBInspectable var dashLineWidth: CGFloat = 8 {
        didSet {
            updateJourneyView()
        }
    }

    @IBInspectable var dashLineSize: CGFloat = 14 {
        didSet {
            updateJourneyView()
        }
    }

    @IBInspectable var dashLineColor: UIColor = UIColor.white {
        didSet {
            updateJourneyView()
        }
    }

    @IBInspectable var enableDots: Bool = false {
        didSet {
            updateJourneyView()
        }
    }

    @IBInspectable var circleDotsSize: CGFloat = 5 {
        didSet {
            updateJourneyView()
        }
    }

    @IBInspectable var circleDotsColor: UIColor = UIColor.green {
        didSet {
            updateJourneyView()
        }
    }

    @IBInspectable var squaresDotsSize: CGFloat = 20 {
        didSet {
            updateJourneyView()
        }
    }

    @IBInspectable var squaresDotsExerciseColor: UIColor = UIColor.white {
        didSet {
            updateJourneyView()
        }
    }

    @IBInspectable var squaresDotsGameColor: UIColor = UIColor.white {
        didSet {
            updateJourneyView()
        }
    }

    @IBInspectable var squaresDotsEmptyColor: UIColor = UIColor.white {
        didSet {
            updateJourneyView()
        }
    }

    @IBInspectable var backgroundSquaresEnabled: Bool = false {
        didSet {
            updateJourneyView()
        }
    }

    @IBInspectable var backgroundSquaresColor: UIColor = UIColor.white {
        didSet {
            updateJourneyView()
        }
    }

    @IBInspectable var backgroundSquaresSize: CGFloat = 50 {
        didSet {
            updateJourneyView()
        }
    }

    @IBInspectable var backgroundSquaresSamples: Int = 50 {
        didSet {
            updateJourneyView()
        }
    }

    @IBInspectable var background: UIColor = UIColor.white {
        didSet {
            updateJourneyView()
        }
    }

    @IBInspectable var buttonsSize: CGFloat = 50 {
        didSet {
            updateJourneyView()
        }
    }

    @IBInspectable var enableFinish: Bool = false {
        didSet {
            updateJourneyView()
        }
    }

    // MARK: - Declare the delegate variable and other properties
    @IBOutlet public var delegate: JourneyViewDelegate?

    fileprivate var completionBlocks = [CAAnimation: (Bool) -> Void]()
    fileprivate var roadSections: RoadSections!

    /// The top section has first exercise, then game.
    private let nonCycleItemsFromTop = 2

    /// The bottom section has exercise, game, exercise, then finish (ignoring finish)
    private let nonCycleItemsFromBottom = 3

    /// A cycle has 2 exercise and 2 games  (including games)
    private let itemsInOneCycle = 4

    // MARK: - View Life Cycle
    override init(frame: CGRect) {
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
        subviews.filter({ $0 is UIScrollView }).forEach({ $0.removeNestedSubviewsAndConstraints() })
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
 /*
        if enableFinish {
            if let finishSection = road.sections
                .enumerated().filter({ $0.1.type == .finish }).last {
                let section = finishSection.element.path
                let index = finishSection.offset
                let button = JourneyFinishView().then {
                    $0.frame = CGRect.zero
                    $0.tag = index
                    $0.contentView?.backgroundColor = pathColor
                    $0.layer.position = section.currentPoint - CGPoint(x: $0.contentView!.frame.center.x, y: 0)
                }
                scrollView.addSubview(button)
            }
        }
                 */

        pathShapes.forEach { scrollView.layer.addSublayer($0) }
        pathLines.forEach { scrollView.layer.addSublayer($0) }

        if enableDots {
            var dots: [CALayer] = []
            road.fullPath.cgPath.forEach { [weak self] element in
                guard let this = self else { return }
                let dot = CALayer().then {
                    $0.backgroundColor = this.circleDotsColor.cgColor
                    $0.cornerRadius = 2
                    $0.bounds = CGRect(origin: .zero, size: CGSize(width: circleDotsSize, height: circleDotsSize))
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
                    $0.bounds = CGRect(origin: .zero, size: CGSize(width: squaresDotsSize, height: squaresDotsSize))
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

        #if TARGET_INTERFACE_BUILDER
        // do not create buttons in interface builder
        #else
        createButtons(in: scrollView)
        #endif

    }

    // MARK: - Create Buttons after journey view loads
    fileprivate func createButtons(in parent: UIScrollView) {
        if let road = self.roadSections, let delegate = self.delegate {

            if let section = road.sections.first {
                delegate.journeyView(didAddFirst: section, at: 0)
            }

            road.sections
                .filter({ $0.type != .finish })
                .enumerated().forEach { [weak self] index, section in
                    guard let this = self else { return }
                    let tap = UITapGestureRecognizer(target: self, action: #selector(this.handleButtonTap))
                    let size = CGSize(width: buttonsSize, height: buttonsSize)
                    let frame = CGRect(origin: CGPoint.zero, size: size)
                    let button = UIView().then({
                        $0.frame = frame
                        $0.tag = index
                        $0.backgroundColor = .clear
                        $0.isUserInteractionEnabled = section.type.isExercise || section.type.isGame
                        $0.addGestureRecognizer(tap)
                        $0.layer.position = section.path.currentPoint
                    })
                    parent.addSubview(button)

                    if section.type.isExercise {
                        delegate.journeyView(didAddExercise: section, at: index, with: button)
                    }

                    if section.type.isGame {
                        delegate.journeyView(didAddGame: section, at: index, with: button)
                    }
            }

            if let section = road.sections.enumerated()
                .filter({ $1.type == .finish }).last {
                delegate.journeyView(didAddFinish: section.element, at: section.offset)
            }
        }

    }

    // MARK: - Handle Buttons UITapGestureRecognizer
    @objc fileprivate func handleButtonTap(_ sender: UITapGestureRecognizer) {

        if let button = sender.view, let delegate = self.delegate,
            let road = self.roadSections, road.sections.count > button.tag {

            let index = button.tag
            let section = road.sections[index]
            delegate.journeyView(didSelect: section, at: index)
            /*
            if delegate.journeyView(shouldeAnimateViewIn: section) {
                let icon = delegate.journeyView(animateViewIn: section)

                animate(view: icon, in: section, duration: 4, completion: {
                    delegate.journeyView(didEndAnimatingViewIn: section, at: index)
                })
            }
 */
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
    fileprivate func roadMap(with origin: CGPoint) -> RoadSections {

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
