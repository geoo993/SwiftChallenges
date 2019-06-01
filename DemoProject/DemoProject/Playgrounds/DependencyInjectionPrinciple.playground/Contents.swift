// https://www.youtube.com/watch?v=-n8allUvhw8
import Foundation
import UIKit

//// PART 1
class RequestManager {
    init() {
        
    }
}

class ViewController: UIViewController {
    // 1- Non Dependency Injection
    // the view controller is in charge of creating the view manager instance
    // this means the view controller knows about the behaviour of RequestManager class and also knowns about its instanciation
    //lazy var requestManager: RequestManager? = RequestManager()
    
    // 2- Dependency Injection
    var requestManager: RequestManager?
    
}

// 2- Dependency Injection
// we can inject a RequestManager instant into the viewcontroller instant.
// eventhough the end result may appear identical, it definately isn't
let viewcontroller = ViewController()
// by injecting the RequestManager the viewcontroller does not know how to isntanciate the RequestManager
// many developers immidiately iscard this option because it is combersome and unnecessarily complex.
// but if you consider the benefits, dependency injection becomes much more appealing.
viewcontroller.requestManager = RequestManager()



/// PART2
protocol Serializer {
    func serialize(data: Any) -> Data?
}

class Request {
}

class RequestSerializer: Serializer {
    func serialize(data: Any) -> Data? {
        return nil
    }
}

class MockSerializer: Serializer {
    func serialize(data: Any) -> Data? {
        return Data(base64Encoded: "Mock Data")
    }
}

class DataManager {
    var serializer: Serializer?
}


// Here you can replace serializer with absolutely anything that conforms to Serializer protocol
// This shows the true power of dependecy injection.
let dataManager = DataManager()
dataManager.serializer = RequestSerializer() // Dependency Injection where you can replace this with object type that conforms to Serializer protocol. The dataManager no longer cares about these details.
dataManager.serializer = MockSerializer() // we can replace this with any object type that conforms to Serializer protocol including  ock objects which makes it easier for testing


// Benefits of Dependency Injection
// Transparancy: By injecting the depecncies of an object the reposabilities and requirements of a class or structure becomes more clear and more transparent.
// Testing: Unit testing is so much easier with dependency injection. Dependency injection makes it very easy to replace an object dependecies with mock objects/ dummy objects/ stubs, making unit test easier to setup an isolated behaviour.
// Separation of Concerns: Dependency Injection allows for a sticker seperation of concerns. The DataManager class is not responsible for instatiating Serializer instance, it does not need to know how to do this. Eventhough the DataManager class is concerned with the behaviour of a serialiser, it is not and should not be concerned with its instantiation.
// Coupling: The example with the DataManager class illustrated how the use of protocols and dependency injection can reduce coupling in a project. Protocols are increadibly useful and versatile in swift.


//Most developer identiy three types of Dependency Injection
// - Initializer Injection
// - Property Injection
// - Method Injection

// 1- Initializer Injection: the advantage of this is that dependencies passed in during initialisation can be made immutable, and also that the serializer property cannot be mutated
class DataManagerInitializer {
    private let serializer: Serializer
    init(serializer: Serializer) {
        self.serializer = serializer
    }
}

// 2- Property Injection: the advantage of this is that the dependencies property can be replaced or is mutable. Property Injection is sometimes the only option you have.
class DataManagerProperty {
    var serializer: Serializer?
}


// 3- Method Injection: depencdecies can also be injected whenever they are needed, this is easy to do by defining a methods that accepts a dependency as a parameter.
//  This type of dependency injection introduces flexibility
class DataManagerMethod {
    // the serializer is injected as an arguement of the serialiserRequest with method
    func serializerRequest(_ request: Request, with serializer: Serializer) -> Data? {
        return nil
    }
}


// Dependency Injection is a pattern that can be used to ellininate the use of singleton in a project.
