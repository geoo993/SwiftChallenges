
// MARK: - Delegate protocol
@objc public protocol JourneyViewDelegate: NSObjectProtocol {

    @objc func journeyView(didAddFirst section: RoadSection, at index: Int)
    @objc func journeyView(didAddFinish section: RoadSection, at index: Int)
    @objc func journeyView(didAddExercise section: RoadSection, at index: Int, with parent: UIView)
    @objc func journeyView(didAddGame section: RoadSection, at index: Int, with parent: UIView)
    @objc func journeyView(didSelect section: RoadSection, at index: Int)
    //@objc func journeyView(shouldeAnimateViewIn section: UIBezierPath) -> Bool
    //@objc func journeyView(animateViewIn section: UIBezierPath) -> UIView
    //@objc func journeyView(didEndAnimatingViewIn section: UIBezierPath, at index: Int)
}
