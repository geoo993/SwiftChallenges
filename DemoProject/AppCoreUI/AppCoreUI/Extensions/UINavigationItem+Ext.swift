
public extension UINavigationItem {
    func disableNavBackButton() {
        hidesBackButton = true
        leftBarButtonItem = nil
    }

    func disableAllNavItems() {
        title = ""
        rightBarButtonItem?.title = ""

        hidesBackButton = true
        backBarButtonItem?.isEnabled = false

        leftBarButtonItem = nil
        rightBarButtonItem = nil
    }

    func addMenuButton(with barImage: UIImage?, size: CGSize, target: Any?, selector: Selector?) {
        if let img = barImage {
            let image = img
                .withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
                .imageWithSize(size: size, extraMargin: 0)

            // create a new button
            let button: UIButton = UIButton(type: .system)
            // set image for button
            button.setImage(image, for: UIControl.State.normal)
            // add function for button
            button.addTarget(target, action: selector!, for: .touchUpInside)
            // set frame
            button.frame = CGRect(origin: CGPoint.zero, size: size)

            let barButton = UIBarButtonItem(customView: button)
            // assign button to navigationbar
            rightBarButtonItem = barButton

            // let menu1 = UIBarButtonItem(title: "Menu", style: .plain, target: self, action: selector)
            // let menu2 = UIBarButtonItem(image: image, style: .plain, target: target, action: selector  )
            // self.rightBarButtonItem = menu2
        }
    }
}
