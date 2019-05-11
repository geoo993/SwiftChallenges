import PlaygroundSupport
import UIKit
import Playgrounds

// these values have been pre-selected by
// the graphics and design teams
let defaultHeight = 200
let defaultColor = UIColor.blue

enum Shapes {
    
    case square
    case circle
    case rectangle
    
}

protocol HelperViewFactoryProtocol {
    
    func configure()
    func position()
    func display()
    var height: Int { get }
    var view: UIView { get }
    var parentView: UIView { get }
    
}

fileprivate class Square: HelperViewFactoryProtocol {
    
    let height: Int
    let parentView: UIView
    var view: UIView
    
    init(height: Int = defaultHeight, parentView: UIView) {
        
        self.height = height
        self.parentView = parentView
        view = UIView()
        
    }
    
    func configure() {
        
        let frame = CGRect(x: 0, y: 0, width: height, height: height)
        view.frame = frame
        view.backgroundColor = defaultColor
        
    }
    
    func position() {
        
        view.center = parentView.center
        
    }
    
    func display() {
        configure()
        position()
        parentView.addSubview(view)
        
    }
    
} // end class Square


fileprivate class Circle : Square {
    
    override func configure() {
        
        super.configure()
        
        view.layer.cornerRadius = view.frame.width / 2
        view.layer.masksToBounds = true
        
    }
    
} // end class Circle

fileprivate class Rectangle : Square {
    
    override func configure() {
        
        let frame = CGRect(x: 0, y: 0, width: height + height/2, height: height)
        view.frame = frame
        view.backgroundColor = UIColor.blue
        
    }
    
} // end class Rectangle

class ShapeFactory {
    
    let parentView: UIView
    
    init(parentView: UIView) {
        
        self.parentView = parentView
        
    }
    
    func create(as shape: Shapes) -> HelperViewFactoryProtocol {
        
        switch shape {
            
        case .square:
            
            let square = Square(parentView: parentView)
            return square
            
        case .circle:
            
            let circle = Circle(parentView: parentView)
            return circle
            
        case .rectangle:
            
            let rectangle = Rectangle(parentView: parentView)
            return rectangle
            
        }
        
    } // end func display
    
} // end class ShapeFactory

// Public factory method to display shapes.
func createShape(_ shape: Shapes, on view: UIView) {
    view.subviews.forEach { (subview) in
        if subview is UIStackView {
        } else {
            subview.removeFromSuperview()
        }
    }
    let shapeFactory = ShapeFactory(parentView: view)
    shapeFactory.create(as: shape).display()
    
}

// Alternative public factory method to display shapes.
// Technically, the factory method should return one of
// a number of related classes.
func getShape(_ shape: Shapes, on view: UIView) -> HelperViewFactoryProtocol {
    
    let shapeFactory = ShapeFactory(parentView: view)
    return shapeFactory.create(as: shape)
    
}

let master = DefaultViewController()
master.onTapOrangeHandler = {
    
    //print("did tap orange view")
    // just draw the shape
    createShape(.circle, on: master.view)
}

master.onTapYellorHandler = {
    //print("did tap square view")
    
    // just draw the shape
    createShape(.square, on: master.view)
}

master.onTapBlueHandler = {
    //print("did tap rectangle view")
    // actually get an object from the factory
    // and use it to draw the shape
    let rectangle = getShape(.rectangle, on: master.view)
    rectangle.display()
}


let nav = UINavigationController(rootViewController: master)
PlaygroundPage.current.liveView = nav
