import Foundation
// https://www.avanderlee.com/swift/weak-self/
/*
 Swift uses Automatic Reference Counting (ARC) to track and manage your app’s memory usage. In most cases, this means that memory management “just works” in Swift, and you do not need to think about memory management yourself. ARC automatically frees up the memory used by class instances when those instances are no longer needed.
 
 However, in a few cases ARC requires more information about the relationships between parts of your code in order to manage memory for you.
 
 Here’s an example of how Automatic Reference Counting works. This example starts with a simple class called Person, which defines a stored constant property called name:
 */


class Person {
    let name: String
    init(name: String) {
        self.name = name
        print("\(name) is being initialized")
    }
    deinit {
        print("\(name) is being deinitialized")
    }
}

/*
 
 The Person class has an initializer that sets the instance’s name property and prints a message to indicate that initialization is underway. The Person class also has a deinitializer that prints a message when an instance of the class is deallocated.
 
 The next code snippet defines three variables of type Person?, which are used to set up multiple references to a new Person instance in subsequent code snippets. Because these variables are of an optional type (Person?, not Person), they are automatically initialized with a value of nil, and do not currently reference a Person instance.
 */

var reference1: Person?
var reference2: Person?
var reference3: Person?

//You can now create a new Person instance and assign it to one of these three variables:
reference1 = Person(name: "John Appleseed")
// Prints "John Appleseed is being initialized"

/*
 Note that the message "John Appleseed is being initialized" is printed at the point that you call the Person class’s initializer. This confirms that initialization has taken place.
 
 Because the new Person instance has been assigned to the reference1 variable, there is now a strong reference from reference1 to the new Person instance. Because there is at least one strong reference, ARC makes sure that this Person is kept in memory and is not deallocated.
 
 If you assign the same Person instance to two more variables, two more strong references to that instance are established:
 */
reference2 = reference1
reference3 = reference1

// There are now three strong references to this single Person instance.

/*
 If you break two of these strong references (including the original reference) by assigning nil to two of the variables, a single strong reference remains, and the Person instance is not deallocated:
 */

 reference1 = nil
 reference2 = nil

/*
 ARC does not deallocate the Person instance until the third and final strong reference is broken, at which point it’s clear that you are no longer using the Person instance:
*/

reference3 = nil
// Prints "John Appleseed is being deinitialized"

print()

/*
 In Swift, we need to use weak self and unowned self to give ARC the required information between relationships in our code. Without using weak or unowned you’re basically telling ARC that a certain “strong reference” is needed and you’re preventing the reference count from going to zero. Without correctly using these keywords we possibly retain memory which can cause memory leaks in your app. So-called Strong Reference Cycles or Retain Cycles can occur as well if weak and unowned are not used correctly.
 
 Reference counting applies only to instances of classes. Structures and enumerations are value types, not reference types, and are not stored and passed by reference.
 */

/*
 First of all, weak references are always declared as optional variables as they can automatically be set to nil by ARC when its reference is deallocated.
 The following two classes are going to help explain when to use a weak reference.
 */
class Blog {
    let name: String
    let url: URL
    var owner: Blogger?
    
    init(name: String, url: URL) { self.name = name; self.url = url }
    
    deinit {
        print("Blog \(name) is being deinitialized")
    }
}

class Blogger {
    let name: String
    var blog: Blog?
    
    init(name: String) { self.name = name }
    
    deinit {
        print("Blogger \(name) is being deinitialized")
    }
}

//  we’re defining two instances as optionals
var blog: Blog? = Blog(name: "SwiftLee", url: URL(string: "www.avanderlee.com")!)
var blogger: Blogger? = Blogger(name: "Antoine van der Lee")

blog!.owner = blogger // The blog has a strong reference to its owner and is not willing to release.
blogger!.blog = blog  // At the same time, the owner is not willing to free up its blog.

// setting the optionals to nil.
blog = nil
blogger = nil

/*
Nothing is printed becuase The blog does not release its owner who is retaining its blog which is retaining himself which… well, you get the point, it’s an infinite loop: a retain cycle.
 
 Therefore, we need to introduce a weak reference.
 */

struct Post {
    let title: String
    var isPublished: Bool = false
    
    init(title: String) { self.title = title }
}
class Blog2 {
    let name: String
    let url: URL
    weak var owner: Blogger2?
    
    var publishedPosts: [Post] = []
    var onPublish: ((_ post: Post) -> Void)?
    
    init(name: String, url: URL) {
        self.name = name
        self.url = url
        
        // Adding a closure instead to handle published posts
//        onPublish = { post in
//            self.publishedPosts.append(post)
//            print("Published post count is now: \(self.publishedPosts.count)")
//        }
        
        //Adding a weak reference to our blog instance inside the onPublish method solves our retain cycle:
        onPublish = { [weak self] post in
            self?.publishedPosts.append(post)
            print("Published post count is now: \(self?.publishedPosts.count)")
        }
    }
    
    deinit {
        print("Blog \(name) is being deinitialized")
    }
    
//    func publish(post: Post) {
//        /// Faking a network request with this delay:
//        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
//            self.publishedPosts.append(post)
//            print("Published post count is now: \(self.publishedPosts.count)")
//        }
//    }

    func publish(post: Post) {
        /// Faking a network request with this delay:
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.onPublish?(post)
        }
    }
}

class Blogger2 {
    let name: String
    var blog: Blog2?
    
    init(name: String) { self.name = name }
    
    deinit {
        print("Blogger \(name) is being deinitialized")
    }
}

var blog2: Blog2? = Blog2(name: "SwiftLee", url: URL(string: "www.avanderlee.com")!)
var blogger2: Blogger2? = Blogger2(name: "Antoine van der Lee")

blog2!.owner = blogger2
blogger2!.blog = blog2

blog2 = nil
blogger2 = nil

// Blogger Antoine van der Lee is being deinitialized
// Blog SwiftLee is being deinitialized


/*
 It’s best practice to always use weak combined with self inside closures to avoid retain cycles. However, this is only needed if self also retains the closure. By adding weak by default you probably end up working with optionals in a lot of cases while it’s actually not needed
 */

var blog3: Blog2? = Blog2(name: "SwiftLee", url: URL(string: "www.avanderlee.com")!)
var blogger3: Blogger2? = Blogger2(name: "Antoine van der Lee")

blog3!.owner = blogger3
blogger3!.blog = blog3

//blog3!.publish(post: Post(title: "Explaining weak and unowned self"))
//blog3 = nil
//blogger3 = nil

// This will print out the following:

// Blogger Antoine van der Lee is being deinitialized
// Published post count is now: 1
// Blog SwiftLee is being deinitialized

//If we would change the publish method to include a weak reference instead:

extension Blog2 {
    func publish2(post: Post) {
        /// Faking a network request with this delay:
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            self?.publishedPosts.append(post)
            print("Published post count is now: \(self?.publishedPosts.count)")
        }
    }
}

blog3!.publish2(post: Post(title: "Explaining weak and unowned self"))
blog3 = nil
blogger3 = nil

//We would get the following output:

// Blogger Antoine van der Lee is being deinitialized
// Blog SwiftLee is being deinitialized
// Published post count is now: nil

print()
/*
 A retain cycle occurs as soon as a closure is retaining self and self is retaining the closure. If we would have had a variable containing an onPublish closure instead, this could occur:
 */


var blog4: Blog2? = Blog2(name: "SwiftLee", url: URL(string: "www.avanderlee.com")!)
var blogger4: Blogger2? = Blogger2(name: "Antoine van der Lee")

blog4!.owner = blogger4
blogger4!.blog = blog4

blog4!.publish(post: Post(title: "Explaining weak and unowned self"))
blog4 = nil
blogger4 = nil

//The closure is retaining the blog while the blog is retaining the closure. This results in the following being printed:

// Blogger Antoine van der Lee is being deinitialized
// Published post count is now: 1


/*
 In Conclusion
 
 Use a weak reference whenever it is valid for that reference to become nil at some point during its lifetime. Conversely, use an unowned reference when you know that the reference will never be nil once it has been set during initialization.
 In general, be very careful when using unowned. It could be that you’re accessing an instance which is no longer there, causing a crash. The only benefit of using unowned over weak is that you don’t have to deal with optionals. Therefore, using weak is always safer in those scenarios.
 */


/*
 Are weak and unowned only used with self inside closures?
 No, definitely not. You can indicate any property or variable declaration weak or unowned as long as it’s a reference type. Therefore, this could also work:
 
 download(imageURL, completion: { [weak imageViewController] result in
 // ...
 })
 
 And you could even reference multiple instances as it’s basically an array:
 
 download(imageURL, completion: { [weak imageViewController, weak imageFinalizer] result in
 // ...
 })
 
 */


