import UIKit

func example(of description: String, action: () -> Void) {
  print("\n--- Example of:", description, "---")
  action()
}

// The adapter pattern is a behavioral pattern that allows incompatible types to work together. It involves four components:

// - An object using an adapter is the object that depends on the new protocol.
// - The new protocol is the desired protocol for use.
// - A legacy object existed before the protocol was made and cannot be modified directly to conform to it.
// - An adapter is created to conform to the protocol and passes calls onto the legacy object.

// A great example of a physical adapter comes to mind when you consider the latest iPhone — there’s no headphone jack! If you want to plug your 3.5mm headphones into the lightning port, you need an adapter with a lightning connector on one end and a 3.5mm jack on the other.
// This is essentially what the Adapter Pattern is about: connecting two elements that otherwise won’t “fit” with each other.

// MARK: - When should you use it?
// - Classes, modules, and functions can’t always be modified, especially if they’re from a third-party library. Sometimes you have to adapt instead!
// - You can create an adapter either by extending an existing class, or creating a new adapter class.

// MARK: - Adapter example
// Lets adapt a third-party authentication service to work with an app’s internal authentication protocol

// - Legacy Object
// Imagine GoogleAuthenticator is a third-party class that cannot be modified.
// Thereby, it is the legacy object. Of course, the actual Google authenticator would be a lot more complex; we’ve just named this one “Google” as an example and faked the networking call.
class GoogleAuthenticator {
    func login(
        email: String,
        password: String,
        completion: @escaping (GoogleUser?, Error?) -> Void
    ) {
        // Make networking calls that return a token string
        let token = "special-token-value"
        let user = GoogleUser(
            email: email,
            password: password,
            token: token
        )
        completion(user, nil)
    }
}

struct GoogleUser {
    var email: String
    var password: String
    var token: String
}

// - New Protocol

// This is the authentication protocol for your app which acts as the new protocol. It requires an email and password. If login succeeds, it calls success with a User and Token. Otherwise, it calls failure with an Error.
protocol AuthenticationService {
    func login(
        email: String,
        password: String,
        success: @escaping (User, Token) -> Void,
        failure: @escaping (Error?) -> Void
    )
}

struct User {
    let email: String
    let password: String
}

struct Token {
    let value: String
}

// The app will use this protocol instead of GoogleAuthenticator directly, and it gains many benefits by doing so. For example, you can easily support multiple authentication mechanisms – Google, Facebook and others – simply by having them all conform to the same protocol.

// While you could extend GoogleAuthenticator to make it conform to AuthenticationService — which is also a form of the adapter pattern! — you can also create an Adapter class.

// - Adapter
// 1 - We create GoogleAuthenticationAdapter as the adapter between GoogleAuthenticationAdapter and AuthenticationService.
class GoogleAuthenticatorAdapter: AuthenticationService {
    
    // 2 - We declare a private reference to GoogleAuthenticator, so it’s hidden from end consumers.
    private var authenticator = GoogleAuthenticator()
    
    // 3 - We add the AuthenticationService login method as required by the protocol. Inside this method, we call Google’s login method to get a GoogleUser.
    func login(
        email: String,
        password: String,
        success: @escaping (User, Token) -> Void,
        failure: @escaping (Error?) -> Void
    ) {
        
        // By wrapping the GoogleAuthenticator like this, end consumers don’t need to interact with Google’s API directly. This protects against future changes. For example, if Google ever changed their API and it broke your app, you’d only need to fix it in one place: this adapter.
        authenticator.login(email: email, password: password) {
            (googleUser, error) in
            
            // 4 - If there’s an error, we call failure with it.
            guard let googleUser = googleUser else {
                failure(error)
                return
            }
            
            // 5 - Otherwise, we create user and token from the googleUser and call success.
            let user = User(email: googleUser.email, password: googleUser.password)
            
            let token = Token(value: googleUser.token)
            success(user, token)
        }
    }
}

// - Object Using an Adapter

// 1 - here, we first declare a new class for LoginViewController. It has an authService property and text for the e-mail and password. For simplicity’s sake here, you set them to new UITextField instances.
class LoginViewController: UIViewController {
    var authService: AuthenticationService!
    var email: String?
    var password: String?
    
    // 2 - We then create a class method that instantiates a LoginViewController and sets authService.
    class func instance(with authService: AuthenticationService) -> LoginViewController {
        let viewController = LoginViewController()
        viewController.authService = authService
        return viewController
    }
    
    // 3 - Lastly, we create a login method that calls authService.login with the e-mail and password from the text fields.
    func login() {
        guard let email, let password else {
            print("Email and password are required inputs!")
            return
        }
        authService.login(
            email: email,
            password: password,
            success: { user, token in
                print("Auth succeeded: \(user.email), \(token.value)")
            },
            failure: { error in
                print("Auth failed with error: no error provided")
            }
        )
    }
}

example(of: "Adapter pattern") {
    // here create a new LoginViewController by passing GoogleAuthenticatorAdapter as the authService, set the text for the e-mail and password text fields and call login.
    let viewController = LoginViewController.instance(with: GoogleAuthenticatorAdapter())
    viewController.email = "user@example.com"
    viewController.password = "password"
    viewController.login()
}

// If you wanted to support other APIs like Facebook login, you could easily make adapters for them as well and have the LoginViewController use them exactly the same way without requiring any code changes.

// MARK: - What should you be careful about?
// The adapter pattern allows you to conform to a new protocol without changing an underlying type. This has the consequence of protecting against future changes against the underlying type, but it also makes your implementation harder to read and maintain.
// Be careful about implementing the adapter pattern unless you recognize there’s a real possibility for change. If there isn’t, consider if it makes sense to use the underlying type directly.

// MARK: - Here are its key points:
// - The adapter pattern is useful when working with classes from third-party libraries that cannot be modified. You can use protocols to have them work with the project’s custom classes.
// - To use an adapter, you can either extend the legacy object, or make a new adapter class.
// - The adapter pattern allows you to reuse a class even if it lacks required components or has incompatible components with required objects.
// - In A Briefer History of Time, Steven Hawking said, “Intelligence is the ability to adapt to change.” Maybe he wasn’t talking about the adapter pattern exactly, but this idea is an important component in this pattern and many others: plan ahead for future changes.
