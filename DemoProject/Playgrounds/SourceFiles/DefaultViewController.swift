import Foundation
import UIKit
public class DefaultViewController : UIViewController {
    
    var stackView: UIStackView!
    var orangeView: UILabel!
    var yellowView: UILabel!
    var blueView: UILabel!
    public var onTapOrangeHandler: () -> () = {}
    public var onTapYellorHandler: () -> () = {}
    public var onTapBlueHandler: () -> () = {}
    
    override public func loadView() {
        // UI
        
        let view = UIView()
        view.backgroundColor = .red
        
        orangeView = UILabel()
        orangeView.text = "Orange"
        orangeView.textAlignment = .center
        orangeView.backgroundColor = .orange
        orangeView.isUserInteractionEnabled = true
        
        yellowView = UILabel()
        yellowView.text = "Yellow"
        yellowView.textAlignment = .center
        yellowView.backgroundColor = .yellow
        yellowView.isUserInteractionEnabled = true
        
        blueView = UILabel()
        blueView.text = "Blue"
        blueView.textAlignment = .center
        blueView.backgroundColor = .blue
        blueView.isUserInteractionEnabled = true
        
        //Stack View
        stackView = UIStackView()
        stackView.axis  = .horizontal
        stackView.distribution  = .fillEqually // .fillProportionally .equalSpacing .equalCentering
        stackView.alignment = .fill // .leading .firstBaseline .center .trailing .lastBaseline
        stackView.spacing   = 10.0
        stackView.backgroundColor = .green
        stackView.addArrangedSubview(orangeView)
        stackView.addArrangedSubview(yellowView)
        stackView.addArrangedSubview(blueView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackView)
        
        // Layout
        NSLayoutConstraint.activate([
            //stackView.centerXAnchor.constraint(equalToSystemSpacingAfter: view.centerXAnchor, multiplier: 0),
            stackView.bottomAnchor.constraint(equalToSystemSpacingBelow: view.bottomAnchor, multiplier: 0),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0.0),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0.0),
            stackView.heightAnchor.constraint(equalToConstant: 60.0),
            //stackView.widthAnchor.constraint(equalToConstant: 300)
            
            ])
        
        self.view = view
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        let tapOrange = UITapGestureRecognizer(target: self, action: #selector(self.handleOrangeTapGesture(_:)))
        orangeView.addGestureRecognizer(tapOrange)
        let tapYellow = UITapGestureRecognizer(target: self, action: #selector(self.handleYellowTapGesture(_:)))
        yellowView.addGestureRecognizer(tapYellow)
        let tapBlue = UITapGestureRecognizer(target: self, action: #selector(self.handleBlueTapGesture(_:)))
        blueView.addGestureRecognizer(tapBlue)
        
        view.bringSubviewToFront(orangeView)
        view.bringSubviewToFront(yellowView)
        view.bringSubviewToFront(blueView)
        title = "Demo Project"
    }
    
    @objc func handleOrangeTapGesture(_ sender: UITapGestureRecognizer) {
        onTapOrangeHandler()
    }
    
    @objc func handleYellowTapGesture(_ sender: UITapGestureRecognizer) {
        onTapYellorHandler()
    }
    
    @objc func handleBlueTapGesture(_ sender: UITapGestureRecognizer) {
        onTapBlueHandler()
    }
}
