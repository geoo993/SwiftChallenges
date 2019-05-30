
extension UIGestureRecognizer {
    public var touchInView: (point: CGPoint, velocity: CGPoint?, translation: CGPoint?) {
        let point = location(in: view)
        let pan = self as? UIPanGestureRecognizer
        let velocity = pan?.velocity(in: view)
        let translation = pan?.translation(in: view)
        return (point, velocity, translation)
    }

    public var touchInSuperview: (point: CGPoint, velocity: CGPoint?, translation: CGPoint?)? {
        guard let superView = self.view?.superview
        else { return nil }
        let point = location(in: superView)
        let pan = self as? UIPanGestureRecognizer
        let velocity = pan?.velocity(in: superView)
        let translation = pan?.translation(in: superView)
        return (point, velocity, translation)
    }
}

//extension UIGestureRecognizer.State: CustomStringConvertible {
//    public var description: String {
//        switch self {
//        // the recognizer has not yet recognized its gesture, but may be evaluating
//        // touch events. this is the default state
//        case .possible: return "Possible"
//        // the recognizer has received touches recognized as the gesture. the action
//        // method will be called at the next turn of the run loop
//        case .began: return "Began"
//        // the recognizer has received touches recognized as a change to the gesture.
//        // the action method will be called at the next turn of the run loop
//        case .changed: return "Changed"
//        // the recognizer has received touches recognized as the end of the gesture.
//        // the action method will be called at the next turn of the run loop and the
//        // recognizer will be reset to UIGestureRecognizerStatePossible
//        case .ended: return "Ended"
//        // the recognizer has received touches resulting in the cancellation of the gesture.
//        // the action method will be called at the next turn of the run loop.
//        // the recognizer will be reset to UIGestureRecognizerStatePossible.
//        case .cancelled: return "Cancelled"
//        // the recognizer has received a touch sequence that can not be recognized
//        case .failed: return "Failed"
//        }
//    }
//}
