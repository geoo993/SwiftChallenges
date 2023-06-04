import UIKit

// The model-view-controller (MVC) pattern is a structural pattern that separates objects into three distinct types:
// the three types are models, views and controllers!

// - Models hold application data. They are usually structs or simple classes.
// - Views display visual elements and controls on screen. They are usually subclasses of UIView.
// - Controllers coordinate between models and views. They are usually subclasses of UIViewController.


// MVC is very common in iOS programming because it’s the design pattern that Apple chose to adopt in UIKit.
// - Controllers are allowed to have strong properties for their model and view so they can be accessed directly. Controllers may also have more than one model and/or view.

// - Conversely, models and views should not hold a strong reference to their owning controller. This would cause a retain cycle. Instead, models communicate to their controller via property observing/


// MARK: - When should you use it?
// - Use this pattern as a starting point for creating iOS apps.
// - In nearly every app, you’ll likely need additional patterns besides MVC, but it’s okay to introduce more patterns as your app requires them.


// Now lets create an “Address Screen” using MVC

// MARK: - Address

struct Address {
    let street: String
    let city: String
    let state: String
    let zipCode: String
}

// MARK: - AddressView

final class AddressView: UIView {
    var streetTextField: UITextField!
    var cityTextField: UITextField!
    var stateTextField: UITextField!
    var zipCodeTextField: UITextField!
}


// MARK: - AddressViewController
final class AddressViewController: UIViewController {
    
    // MARK: - Properties
    
    // This is an example of how the model can tell the controller that something has changed and that the views need updating.
    var address: Address? {
        didSet {
            updateViewFromAddress()
        }
    }

    // This is the view that is showed to the user
    var addressView: AddressView! {
        guard isViewLoaded else { return nil }
        return (view as! AddressView)
    }
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViewFromAddress()
    }
    
    private func updateViewFromAddress() {
        guard let addressView = addressView,
              let address = address
        else { return }
        addressView.streetTextField.text = address.street
        addressView.cityTextField.text = address.city
        addressView.stateTextField.text = address.state
        addressView.zipCodeTextField.text = address.zipCode
    }
    
    // MARK: - Actions
    
    // allow the user to update the address from the view?
    @objc func updateAddressFromView(_ sender: AnyObject) {
      guard let street = addressView.streetTextField.text,
        street.count > 0,
        let city = addressView.cityTextField.text,
        city.count > 0,
        let state = addressView.stateTextField.text,
        state.count > 0,
        let zipCode = addressView.zipCodeTextField.text,
        zipCode.count > 0 else {
          // TO-DO: show an error message, handle the error, etc
          return
      }
      address = Address(
        street: street,
        city: city,
        state: state,
        zipCode: zipCode
      )
    }
}

// This is an example of how the view can tell the controller that something has changed.
// You can seen how the controller owns the models and the views, and how each can interact with each other, but always through the controller.

// MARK: - What should you be careful about?
// - MVC is a good starting point, but it has limitations. Not every object will neatly fit into the category of model, view or controller. Consequently, applications that only use MVC tend to have a lot of logic in the controllers.
// - This can result in view controllers getting very big! There’s a rather quaint term for when this happens, called “Massive View Controller.”
// - To solve this issue, you should introduce other design patterns as your app requires them.


// MARK: - Here are its key points:
// - MVC separates objects into three categories: models, views and controllers.
// - MVC promotes reusing models and views between controllers. Since controller logic is often very specific, MVC doesn’t usually reuse controllers.
// - The controller is responsible for coordinating between the model and view: it sets model values onto the view, and it handles IBAction calls from the view.
// - MVC is a good starting point, but it has limitations. Not every object will neatly fit into the category of model, view or controller. You should use other patterns as needed along with MVC.
