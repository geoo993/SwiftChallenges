import UIKit

public extension UIView {
    /// Removes all constrains for this view
    func removeConstraints() {
        var topView: UIView? = self
        repeat {
            var list = [NSLayoutConstraint]()
            for c in topView?.constraints ?? [] {
                if c.firstItem as? UIView == self || c.secondItem as? UIView == self {
                    list.append(c)
                }
            }
            topView?.removeConstraints(list)
            topView = topView?.superview

        } while topView != nil

        translatesAutoresizingMaskIntoConstraints = true
    }

    // Recursive remove subviews and constraints
    func removeSubviewsAndConstraints() {
        self.subviews.forEach({
            $0.removeSubviewsAndConstraints()
            $0.removeConstraints($0.constraints)
            $0.removeFromSuperview()
        })
    }

    func removeNestedSubviewsAndConstraints() {
        while(self.subviews.count > 0) {
            self.removeSubviewsAndConstraints()
        }
    }
}
