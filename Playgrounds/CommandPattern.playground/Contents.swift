import Foundation

func example(of description: String, action: () -> Void) {
  print("\n--- Example of:", description, "---")
  action()
}

// The command pattern is a behavioral pattern that encapsulates information to perform an action into a command object.
// It involves three types:

// 1- The invoker stores and executes commands.
// 2- The command encapsulates the action as an object.
// 3- The receiver is the object that’s acted upon by the command.
// Hence, this pattern allows us to model the concept of executing an action.

// MARK: - When should you use it?
// - Use this pattern whenever you want to create actions that can be executed on receivers at a later point in time.
// For example, you can create and store commands to be performed by a computer AI, and then execute these over time.


// MARK: - Command Pattern example
// Lets create a simple guessing game:
// - a Doorman will open and close a Door a random number of times, and we will guess in advance whether the door will be open or closed in the end.

// - Receiver
// Door is a simple model that will act as the receiver. It will be opened and closed by setting its isOpen property.
final class Door {
    var isOpen = false
}

// - Command
// 1 - here we first define a class called DoorCommand, which acts at the command. This class is intended to be an abstract base class, meaning we won’t instantiate it directly. Rather, we will instantiate and use its subclasses.
class DoorCommand {
    // This class has one property, door, which we set within its initializer.
    let door: Door

    init(_ door: Door) {
        self.door = door
    }

    // This also has a single method, execute(), which we override within its subclasses.
    func execute() { }
}

// 2 - We next define a class called OpenCommand as a subclass of DoorCommand.
// This overrides execute(), wherein it prints a message and sets door.isOpen to true.
class OpenCommand: DoorCommand {
    override func execute() {
        print("opening the door...")
        door.isOpen = true
    }
}

// 3 - lastly, we define CloseCommand as a subclass of DoorCommand. This likewise overrides execute() to print a message and sets door.isOpen to false.
class CloseCommand: DoorCommand {
    override func execute() {
        print("closing the door...")
        door.isOpen = false
    }
}

// - Invoker
// 1 - we define a class called Doorman, which will act as the invoker.
class Doorman {
    // 2 - We then define two properties on Doorman.
    let commands: [DoorCommand]
    let door: Door

    // 3 - Within init(door:), we generate a random number, commandCount, to determine how many times the door should be opened and closed. You set commands by iterating from 0 to commandCount and returning either an OpenCommand or CloseCommand based on whether or not the index is even.
    init(door: Door) {
        let commandCount = arc4random_uniform(10) + 1
        self.commands = (0..<commandCount).map { index in
            return index % 2 == 0 ? OpenCommand(door) : CloseCommand(door)
        }
        self.door = door
    }

    // 4 - lastly, We define execute(), wherein we call execute() on each of the commands.
    func execute() {
        print("Doorman is...")
        commands.forEach { $0.execute() }
    }
}

example(of: "Predicting door open or closed using Command Pattern") {
    // We make a prediction for whether the Door will ultimately be open or closed, as determined by isOpen.
    let isOpen = true
    print("You predict the door will be " + "\(isOpen ? "open" : "closed").")
    print("")
    // If you don’t think it will be open, change isOpen to false instead.
    
    // We create a door and doorman, and then call doorman.execute().
    // The number of opening and closing statements will depend on whatever random number is chosen!
    let door = Door()
    let doorman = Doorman(door: door)
    doorman.execute()
    print("")
    
    // To complete the game, we can check whether we guested it right or wrong.
    if door.isOpen == isOpen {
        print("You were right! :]")
    } else {
        print("You were wrong :[")
    }
    print("The door is \(door.isOpen ? "open" : "closed").")
}

// MARK: - What should you be careful about?
// The command pattern can result in many command objects. Consequently, this can lead to code that’s harder to read and maintain. If you don’t need to perform actions later, you may be better off simply calling the receiver’s methods directly.

// MARK: - Here are its key points:
// - The command pattern encapsulates information to perform an action into a command object. It involves three types: an invoker, command and receiver.
// - The invoker stores and executes commands; the command encapsulates an action as an object; and the receiver is the object that’s acted upon.
// - This pattern works best for actions that need to be stored and executed later. If you always intend to execute actions immediately, consider calling the methods directly on the receiver instead.
