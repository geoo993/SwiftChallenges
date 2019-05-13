/*
 The Command pattern is used to express a request, including the call to be made and all of its required parameters, in a command object. The command may then be executed immediately or held for later use. As in real world, a command is a request sent from its invoker (aka sender) to its receiver. By isolating and encapsulating the request, this pattern separates the sender and the receiver of a command in a context where both are dependending on an abstraction rather than the detail of the command invoked by the sender, this abstraction or interface is called the Command.
 In the pattern, the class or sender that executes the command (Invoker) is decoupled from the class which produces the command(CommandHandler) and from the class that knows how to perform it (Receiver). The Invoker is the heart of the pattern. It can call the execute() method to perform an action (send the command) without being aware of the concrete class that conforms to the Command interface/protocol (ConcreteHandler) and what it does. It only knows about the abstract type Command interface/protocol. The ConcreteHandler class conforms to Command protocol and takes an instance of Receiver object in the initializer. It then calls the receiver object to perform certain task/operation.
 */

protocol ICommand {
    func send()
}
protocol IReceiver {
    func open()
}

struct Email {
    var email: String
    var message: String
}

// Command Handler, this class holds an instance of the receiver and takes an instance of Receiver object in the initializer.
// It then calls the receiver object to perform certain task/operation, which in this case run() the email.
class CommandHandler: ICommand {
    
    var receiver: IReceiver
    
    init(receiver: IReceiver) {
        self.receiver = receiver
    }
    
    func send() {
        receiver.open()
    }
}

// Sender, the Invoker is the heart of the pattern. It can call the execute() method to perform an action (send the command)
// without being aware of the concrete class that conforms to the Command interface/protocol (ConcreteHandler) and what it does.
class Invoker {
    func execute(command: ICommand) {
        command.send()
    }
}

// Receiver, the receiver is the class that does the actual work. It can do any  business logic, database request or network operation.
class Receiver: IReceiver {
    var email: Email
    
    init(email: Email) {
        self.email = email
    }
    
    func open() {
        print("Received email from: \(email.email).\nMessage: \(email.message)")
    }
}

////============================
// Create client, Now we can create any client to work with our Comman pattern.
// this Client is the class that creates the CommandHanlder object and pass it into the invoker.
// It can be any class you want.
class Gmail {
    let invoker = Invoker()
    
    func sendEmailTo(email: String, message: String) {
        let receiver = Receiver(email: Email(email: email, message: message))
        let command: ICommand = CommandHandler(receiver: receiver)
        invoker.execute(command: command)
    }
}

let gmail = Gmail()
gmail.sendEmailTo(email: "ggeoo93@gmail.com", message: "Hi Ann, I am working on an exciting new project. Call me back!")
