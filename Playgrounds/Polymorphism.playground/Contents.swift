import Foundation

func example(of description: String, action: () -> Void) {
  print("\n--- Example of:", description, "---")
  action()
}

// - Polymorphism
class Album {
    var name: String

    init(name: String) {
        self.name = name
    }
    
    func getPerformance() -> String {
        "The album \(name) sold lots"
    }
}

class StudioAlbum: Album {
    var studio: String

    init(name: String, studio: String) {
        self.studio = studio
        super.init(name: name)
    }
    
    override func getPerformance() -> String {
        "The studio album \(name) sold lots"
    }
}

class LiveAlbum: Album {
    var location: String

    init(name: String, location: String) {
        self.location = location
        super.init(name: name)
    }
    
    override func getPerformance() -> String {
        "The live album \(name) sold lots"
    }
}

var allAlbums: [Album] = []

example(of: "Polymorphism") {
    // the above defines three classes: albums, studio albums and live albums, with the latter two both inheriting from Album.
    // Because any instance of LiveAlbum is inherited from Album it can be treated just as either Album or LiveAlbum – it's both at the same time.
    // This is called "polymorphism," where it means you can write code like this:
    
    var taylorSwift = StudioAlbum(name: "Taylor Swift", studio: "The Castles Studios")
    var fearless = StudioAlbum(name: "Speak Now", studio: "Aimeeland Studio")
    var iTunesLive = LiveAlbum(name: "iTunes Live from SoHo", location: "New York")
    allAlbums = [taylorSwift, fearless, iTunesLive]
    
    for album in allAlbums {
        // here you can see the true nature of polymorphism
        // We will automatically use the override version of getPerformance() depending on the subclass in question.
        // That's polymorphism in action: an object can work as its class and its parent classes, all at the same time.
        print(album.getPerformance()) // This approach will perform dynamic dispatch
    }
}

example(of: "typecasting") {
    // You will often find you have an object of a certain type, but really you know it's a different type. Sadly, if Swift doesn't know what you know, it won't build your code.
    // So, there's a solution, and it's called typecasting: converting an object of one type to another.
    
    // Chances are you're struggling to think why this might be necessary, but I can give you a very simple example:
    
    for album in allAlbums {
        print(album.getPerformance())

        // Typecasting in Swift comes in three forms, but most of the time you'll only meet two: as? and as!, known as optional downcasting and forced downcasting. The former means "I think this conversion might be true, but it might fail," and the second means "I know this conversion is true, and I'm happy for my app to crash if I'm wrong."
        if let studioAlbum = album as? StudioAlbum {
            print(studioAlbum.studio)
        } else if let liveAlbum = album as? LiveAlbum {
            print(liveAlbum.location)
        }
    }
}


// Protocol Polymorphism
// Protocol polymorphism allows you to achieve polymorphism with ease and not having to worry about implementation from the base entity
protocol Fruit {
    associatedtype Value // Static polymorphism using associatedtype
    func addPrice(low: Value, high: Value) -> Value
    
    func color() -> String // dynamic polymorphism since all fruits will have their own implementation
}

extension Fruit where Value == Int {
    func addPrice(low: Value, high: Value) -> Value {
        low + high
    }
}

extension Fruit where Value == String {
    func addPrice(low: Value, high: Value) -> Value {
        "\(low) added to \(high)"
    }
}

class Banana: Fruit {
    private let name: String
    typealias Value = Int

    init(name: String) {
        self.name = name
    }
    
    func color() -> String {
        "Yellow"
    }
}

class Orange: Fruit {
    private let name: String
    typealias Value = String

    init(name: String) {
        self.name = name
    }
    
    func color() -> String {
        "Orange"
    }
}

class BlueOrange: Orange {
    override init(name: String) {
        super.init(name: name)
    }
    
    override func color() -> String {
        "BlueOrange"
    }
}

example(of: "Protocol Polymorphism") {
    var banana = Banana(name: "its me")
    banana.addPrice(low: 20, high: 4)
    banana.color()
    
    var orange = Orange(name: "Juicy")
    orange.addPrice(low: "20", high: "24")
    orange.color()
    
    var fruits: [any Fruit] = [banana, orange]
    for fruit in fruits {
        print(fruit.color())
    }

    
}

example(of: "Polymorphism and subtyping") {
    var banana = Banana(name: "its me")
    banana.addPrice(low: 20, high: 4)
    
    var orange = Orange(name: "Juicy")
    orange.addPrice(low: "20", high: "24")

    // opaque type
    var fruitBanana: some Fruit = banana // subtyping will perform dynamic dispatch
    print(fruitBanana.color())
}


example(of: "Polymorphism and dynamic dispatch") {
    var orange = Orange(name: "Juicy")
    orange.addPrice(low: "20", high: "24")
    orange.color()
    
    var blueOrange = BlueOrange(name: "Iam blue")
    blueOrange.color()
    
    orange = blueOrange
    print(orange.color()) // now we are using properties of blueOrange
}
