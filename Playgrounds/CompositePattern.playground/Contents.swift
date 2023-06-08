import Foundation

func example(of description: String, action: () -> Void) {
  print("\n--- Example of:", description, "---")
  action()
}

// The composite pattern is a structural pattern that groups a set of objects into a tree structure so they may be manipulated as though they were one object.
// It uses three types:

// - The component protocol ensures all constructs in the tree can be treated the same way.
// - A leaf is a component of the tree that does not have child elements.
// - A composite is a container that can hold leaf objects and composites.

// For example, an Array is a composite.
// The component is the Array itself. The composite is a private container used by Array to contain leaf objects.
// Each leaf is a concrete type such as Int, String or whatever you add to the Array.


// MARK: - When should you use it?
// - If your app’s class hierarchy forms a branching pattern, trying to create two types of classes for branches and nodes can make it difficult for those classes to communicate.
// - You can solve this problem with the composite pattern by treating branches and nodes the same by making them conform to a protocol. This adds a layer of abstraction to your models and ultimately reduces their complexity.


// MARK: - Example of Composite pattern

// A file hierarchy is an everyday example of the composite pattern.
// Think about files and folders. All .mp3 and .jpeg files, as well as folders, share a lot of functions: “open”, “move to trash,” “get info,” “rename,” etc.
// We can move and store groups of different files, even if they aren’t all the same type, because they all conform to a component protocol.

// This is a component protocol, which all the leaf objects and composites will conform to.
protocol File {
    var name: String { get set }
    func open()
}

// Lets add a couple of leafs that conform to the component protocol.
// They all have a name property and an open function, but each open() varies based on the object’s class.
final class eBook: File {
    var name: String
    var author: String
    
    init(name: String, author: String) {
        self.name = name
        self.author = author
    }
    
    func open() {
        print("Opening \(name) by \(author) in iBooks...\n")
    }
}

final class Music: File {
    var name: String
    var artist: String
    
    init(name: String, artist: String) {
        self.name = name
        self.artist = artist
    }
    
    func open() {
        print("Playing \(name) by \(artist) in iTunes...\n")
    }
}

// The Folder object is a composite, and it has an array that can hold any object that conforms to the File protocol. This means that, not only can a Folder hold Music and eBook objects, it can also hold other Folder objects.
final class Folder: File {
    var name: String
    lazy var files: [File] = []
    
    init(name: String) {
        self.name = name
    }
    
    func addFile(file: File) {
        self.files.append(file)
    }
    
    func open() {
        print("Displaying the following files in \(name)...")
        for file in files {
            print(file.name)
        }
        print("\n")
    }
}

example(of: "Composite pattern of Folder structure") {
    let psychoKiller = Music(name: "Psycho Killer", artist: "The Talking Heads")
    let rebelRebel = Music(name: "Rebel Rebel", artist: "David Bowie")
    let blisterInTheSun = Music(name: "Blister in the Sun", artist: "Violent Femmes")
    let justKids = eBook(name: "Just Kids", author: "Patti Smith")

    let documents = Folder(name: "Documents")
    let musicFolder = Folder(name: "Great 70s Music")

    documents.addFile(file: musicFolder)
    documents.addFile(file: justKids)

    musicFolder.addFile(file: psychoKiller)
    musicFolder.addFile(file: rebelRebel)

    // You’re able to treat all of these objects uniformly and call the same functions on them.
    // Using composite patterns becomes meaningful when you’re able to treat different objects the same way, and reusing objects and writing unit tests becomes much less complicated.
    // Imagine trying to create a container for your files without using a component protocol! Storing different types of objects would get complicated very quickly.
    blisterInTheSun.open()
    justKids.open()

    documents.open()
    musicFolder.open()
}

// MARK: - What should you be careful about?
// - Make sure your app has a branching structure before using the composite pattern.
// - If you see that your objects have a lot of nearly identical code, conforming them to a protocol is a great idea, but not all situations involving protocols will require a composite object.

// MARK: - Here are its key points:
// - The composite pattern is a structural pattern that groups a set of objects into a tree so that they may be manipulated as though they were one object.
// - If your app’s class hierarchy forms a branching pattern, you can treat branches and nodes as almost the same objects by conforming them to a component protocol. The protocol adds a layer of abstraction to your models, which reduces their complexity.
// - This is a great pattern to help simplify apps that have multiple classes with similar features. With it, you can reuse code more often and reduce complexity in your classes.
// - A file hierarchy is an everyday example of the composite pattern. All .mp3 and .jpeg files, as well as folders, share a lot of functions such as “open” and “move to trash.” You can move and store groups of different files, even if they aren’t all the same type, as they all conform to a component protocol.
