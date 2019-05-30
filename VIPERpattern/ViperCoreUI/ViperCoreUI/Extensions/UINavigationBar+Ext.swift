
public extension UINavigationBar {
    func clearNavigationBar() {
        setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        shadowImage = UIImage()
        isTranslucent = true
    }
}
