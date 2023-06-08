import UIKit

func example(of description: String, action: () -> Void) {
  print("\n--- Example of:", description, "---")
  action()
}


// The flyweight pattern is a structural design pattern that minimizes memory usage and processing.
// This pattern provides objects that all share the same underlying data, thus saving memory.
// They are usually immutable to make sharing the same underlying data trivial.

// The flyweight pattern has objects, called flyweights, and a static method to return them.

// Does this sound familiar? It should! The flyweight pattern is a variation on the singleton pattern. In the flyweight pattern, you usually have multiple different objects of the same class. An example is the use of colors, as you will experience shortly.
// We need a red color, a green color and so on. Each of these colors are a single instance that share the same underlying data.


// MARK: - When should you use it?
// - Use a flyweight in places where you would use a singleton, but you need multiple shared instances with different configurations.
// - If you have an object that’s resource intensive to create and you can’t minimize the cost of creation process, the best thing to do is create the object just once and pass it around instead.

// MARK: - Flyweight example

// Flyweights are very common in UIKit.
// UIColor, UIFont, and UITableViewCell are all examples of classes with flyweights.

example(of: "UIKit flyweights") {
    let red = UIColor.red
    let red2 = UIColor.red
    // This code proves that UIColor uses flyweights. Comparing the colors with === statements shows that each variable has the same memory address, which means .red is a flyweight and is only instantiated once.
    print("Red colors are equal", red === red2)
    
    
    // Of course, not all UIColor objects are flyweights.
    // for example this time the console will log false! Custom UIColor objects aren’t flyweights.
    let color = UIColor(red: 1, green: 0, blue: 0, alpha: 1)
    let color2 = UIColor(red: 1, green: 0, blue: 0, alpha: 1)
    print("Red colors are equal", color === color2)
}

// If UIColor checked the values to see if a color was already made, it could return flyweight instances instead.
extension UIColor {
    // 1 - We created a dictionary called colorStore to store RGBA values.
    static var colorStore: [String: UIColor] = [:]
    
    // 2 - We wrote your own method that takes red green, blue and alpha like the UIColor method.
    class func rgba(
        _ red: CGFloat,
        _ green: CGFloat,
        _ blue: CGFloat,
        _ alpha: CGFloat
    ) -> UIColor {
        
        // 3 - We store the RGB values in a string called key. If a color with that key already exists in colorStore, use that one instead of creating a new one.
        let key = "\(red)\(green)\(blue)\(alpha)"
        if let color = colorStore[key] {
            return color
        }
        
        // 4 - If the key does not already exist in the colorStore, create the UIColor and store it along with its key.
        let color = UIColor(
            red: red,
            green: green,
            blue: blue,
            alpha: alpha
        )
        colorStore[key] = color
        return color
    }
}

example(of: "UIColor flyweight") {
    let flyColor = UIColor.rgba(0, 3, 0, 1)
    let flyColor2 = UIColor.rgba(0, 3, 0, 1)
    print("Colors are equal", flyColor === flyColor2)
}

// MARK: - What should you be careful about?
// - In creating flyweights, be careful about how big your flyweight memory grows. If you’re storing several flyweights, as in colorStore above, you minimize memory usage for the same color, but you can still use too much memory in the flyweight store.
// - To mitigate this, set bounds on how much memory you use or register for memory warnings and respond by removing some flyweights from memory. You could use a LRU (Least Recently Used) cache to handle this.
// - Also be mindful that your flyweight shared instance must be a class and not a struct. Structs use copy semantics, so you don’t get the benefits of shared underlying data that comes with reference types.

// MARK: - Here are its key points:
// - The flyweight pattern minimizes memory usage and processing.
// - This pattern has objects, called flyweights, and a static method to return them. It’s a variation on the singleton pattern.
// - When creating flyweights, be careful about the size of your flyweight memory. If you’re storing several flyweights, it’s still possible to use too much memory in the flyweight store.
// - Examples of flyweights include caching objects such as images, or keeping a pool of objects stored in memory for quick access.
