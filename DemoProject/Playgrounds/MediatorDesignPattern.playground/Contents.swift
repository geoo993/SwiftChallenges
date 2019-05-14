/*
 
 The Mediator design pattern defines an object that encapsulates how a set of objects interact. Mediator promotes loose coupling by keeping objects from referring to each other explicitly, and it lets you vary their interaction independently. These objects can thus remain more reusable. A “mediator object” in this pattern centralizes complex communication and control logic between objects in a system. These objects tell the mediator object when their state changes and, in turn, respond to requests from the mediator object. An example of this is the controller (i.e. ViewController) in MVC pattern, which is the mediator that coordinates all the work. It accesses the data from the model and displays it with the views, listens to events and manipulates the data as necessary. Another example is NSNotificationCenter which uses Mediator Pattern.
 Let us take a scenario when two or more classes has to interact with each other. Instead of directly communicating with each other and getting the knowledge of their implementation, they can talk via a Mediator.
 So to conclude, the mediator pattern is used to reduce coupling between classes that communicate with each other. Instead of classes communicating directly, and thus requiring knowledge of their implementation, the classes send messages via a mediator object.

 */
enum SocialMedia {
    case twitter
    case snapchat
    case facebook
    case instagram
    case linkedin
    case tinder
}

struct Email {
    var email: String
    var message: String
}

// The protocol Sender is the main focus in this pattern as it is implemented by the Mediator which has the abstract method send that takes message and a Receiver type object as a parameter.
// The Sender has many contacts who are [Receiver]
protocol Sender {
    var contacts: [Receiver] { get set }
    func send(message: String, from sender: Receiver, to receiver: Receiver)
}
// Protocol Receiver only worries about receiving a message by taking a message as a parameter.
protocol Receiver {
    var email: String { get }
    func received(message: Email)
}

// The Mediator handles to communication between the sender and receiver
class Mediator: Sender {
    var contacts: [Receiver] = []
    
    func register(contact: Receiver) {
        contacts.append(contact)
    }
    
    func send(message: String, from sender: Receiver, to receiver: Receiver) {
        for contact in contacts {
            if receiver.email == contact.email && sender.email != receiver.email {
                contact.received(message: Email(email: sender.email, message: message))
            }
        }
    }
}


// Notice that the receivers are not aware of each other or do not old a reference to each other. There is no reference of CEO in team Employee and Employee in CEO.
struct CEO: Receiver {
    var email: String
    init(email: String) {
        self.email = email
    }
    func received(message: Email) {
        print("\(email) received email from: \(message.email).\nMessage:\n\(message.message)\n")
    }
}

struct Employee: Receiver {
    var email: String
    var socialMedias: [SocialMedia]
    init(email: String, socialMedias: [SocialMedia]) {
        self.email = email
        self.socialMedias = socialMedias
    }
    
    func received(message: Email) {
        print("\(email) received email from: \(message.email).\nMessage:\n\(message.message)\n")
    }
}

let mediator = Mediator()
let tom = CEO(email: "tom@outlook.com")
let sam = Employee(email: "samuel993@gmail.com", socialMedias: [.instagram, .facebook])
let gareth = Employee(email: "garth@gmail.com", socialMedias: [.facebook])
let barton = Employee(email: "barton@yahoo.co.uk", socialMedias: [.linkedin, .twitter])
mediator.register(contact: tom)
mediator.register(contact: sam)
mediator.register(contact: gareth)
mediator.register(contact: barton)

let bossMessageToEmployees = "Great news, you are all receiving a 5% bonus this year.\nThank you for your great work and an amazing holiday!"
mediator.send(message: bossMessageToEmployees, from: tom, to: sam)
mediator.send(message: bossMessageToEmployees, from: tom, to: gareth)
mediator.send(message: bossMessageToEmployees, from: tom, to: barton)
mediator.send(message: "Did you get the bonus email from Tom?", from: gareth, to: barton)
mediator.send(message: "Yeah, lets go out and celebrate!", from: barton, to: gareth)
mediator.send(message: "Thank you so much Boss, you're the best!", from: gareth, to: tom)
