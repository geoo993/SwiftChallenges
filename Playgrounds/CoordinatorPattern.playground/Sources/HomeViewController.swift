import UIKit

public class HomeViewController: UIViewController {
    public var onButtonPressed: (() -> Void)?
    
    private var button: UIButton!
    private var label: UILabel!
    
    public override func loadView() {
        setupView()
        setupButton()
    }
    
    private func setupView() {
        view = UIView(frame: CGRect(x: 0, y: 0, width: 320, height: 480))
        view.backgroundColor = .white
    }
    
    private func setupButton() {
        button = UIButton()
        view.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        button.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        button.heightAnchor.constraint(greaterThanOrEqualToConstant: 100).isActive = true
        button.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        
        button.setTitle("How to Code", for: .normal)
        button.backgroundColor = .black
        button.addTarget(self, action: #selector(buttonPressed(_:)), for: .touchUpInside)
    }
    
    @objc private func buttonPressed(_ sender: AnyObject) {
        onButtonPressed?()
    }
}

extension HomeViewController {
    public class func instantiate() -> HomeViewController {
        let viewController = HomeViewController()
        viewController.title = "Code"
        return viewController
    }
}
