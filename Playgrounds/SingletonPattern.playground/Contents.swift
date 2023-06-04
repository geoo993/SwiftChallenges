import UIKit

// The singleton pattern is a creational design pattern that restricts a class to only one instance.
// Every reference to the class refers to the same underlying instance. This pattern is extremely common in iOS app development, as Apple makes extensive use of it.

// The “singleton plus” pattern is also common, which provides a shared singleton instance that allows other instances to be created, too.

// MARK: - When should you use it?
// 1) Use the singleton pattern when having more than one instance of a class would cause problems, or when it just wouldn’t be logical.
// 2) Use the singleton plus pattern if a shared instance is useful most of the time, but you also want to allow custom instances to be created. An example of this is FileManager, which handles everything to do with filesystem access. There is a “default” instance which is a singleton, or you can create your own. You would usually create your own if you’re using it on a background thread.

// Both singleton and singleton plus are common throughout Apple frameworks. For example, UIApplication is a true singleton.


// Add the following right after Code example:

// MARK: - iOS Singleton
let app = UIApplication.shared
// let app2 = UIApplication()

// If you try to uncomment the let app2 line, you’ll get a compiler error! UIApplication doesn’t allow more than one instance to be created.
// This proves it’s a singleton! You can also create your own singleton class.
// Add the following right after the previous code:

// MARK: - Custom Singleton
final class MySingleton {
    // 1 - You first declare a static property called shared, which is the singleton instance.
    static let shared = MySingleton()
    
    // 2 - You mark init as private to prevent the creation of additional instances.
    private init() { }
}

// 3 - You get the singleton instance by calling MySingleton.shared.
let mySingleton = MySingleton.shared

// 4 - You’ll get a compiler error if you try to create additional instances of MySingleton.
// let mySingleton2 = MySingleton()

// Next, add the following singleton plus example below your MySingleton example:

// MARK: - Singleton Plus

// 1- FileManager provides a default instance, which is its singleton property.
let defaultFileManager = FileManager.default

// 2- You’re also allowed to create new instances of FileManager. This proves that it’s using the singleton plus pattern!
let customFileManager = FileManager()

// It’s easy to create your own singleton plus class, too.
// Add the following, which is very similar to a true singleton:

// MARK: - Custom Singleton Plus
final class MySingletonPlus {
    // 1 - You declare a shared static property just like a singleton. This is sometimes called default instead, but it’s simply a preference for whichever name you prefer.
    static let shared = MySingletonPlus()

    // 2 - Unlike a true singleton, you declare init as public/internal to allow additional instances to be created.
    init() { }
}

// 3 - You get the singleton instance by calling MySingletonPlus.shared.
let singletonPlus = MySingletonPlus.shared

// 4 - You can also create new instances, too.
let singletonPlus2 = MySingletonPlus()


// MARK: - What should you be careful about?

// The singleton pattern is very easy to overuse.
//  - If you encounter a situation where you’re tempted to use a singleton, first consider other ways to accomplish your task.
// For example, singletons are not appropriate if you’re simply trying to pass information from one view controller to another. Instead, consider passing models via an initializer or property.
//  - If you determine you actually do need a singleton, consider whether a singleton plus makes more sense.
// - Will having more than one instance cause problems? Will it ever be useful to have custom instances? Your answers will determine whether its better for you to use a true singleton or singleton plus.
// - A very most common reason why singletons are problematic is testing. If you have state being stored in a global object like a singleton then order of tests can matter, and it can be painful to mock them. Both of these reasons make testing a pain.
// - Lastly, beware of “code smell” indicating your use case isn’t appropriate as a singleton at all. For example, if you often need many custom instances, your use case may be better as a regular object.

// MARK: - Here are its key points:
// - The singleton pattern restricts a class to only one instance.
// - The singleton plus pattern provides a “default” shared instance but also allows other instances to be created too.
// - Be careful about overusing this pattern! Before you create a singleton, consider other ways to solve the problem without it. If a singleton really is best, prefer to use a singleton plus over a singleton.
