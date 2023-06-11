import UIKit

// Here we will look the benefits of managing object dependencies. Then, take a quick look at common dependency patterns. Then Finally, take a deep dive into Dependency Injection, one of the common dependency patterns.

// MARK: - Establishing the goals
// The following are the qualities when putting dependency techniques into practice:

// - Maintainability: The ability to easily change a code-base without introducing defects, i.e., the ability to reimplement part of a code-base without adversely affecting the rest of the code-base.
// - Testability: Deterministic unit and UI tests, i.e., tests that don’t rely on things you can’t control, such as the network.
// - Substitutability: The ability to substitute the implementation of a dependency at compile-time and at runtime. This quality is useful for A/B testing, for gating features using feature flags, for replacing side-effect implementations with fake implementations during a test, for temporarily swapping in a diagnostic version of an object during development and more.
// - Deferability: Having the ability to defer big decisions such as selecting a database technology.
// - Parallel work streams: Being able to have multiple developers work independently on the same feature at the same time without stepping on each others toes.
// - Control during development: A code-base that developers can quickly iterate on by controlling build and run behavior, e.g., switching from a keychain-based credential store to a fake in-memory credential store so we don’t need to sign in and out over and over again while working on a sign-in screen.
// - Minimizing object lifetimes: For any given app, the less state a developer has to manage at once, the more predictably an app behaves. Therefore, we want to have the least amount of objects in-memory at once.
// - Reusability: Building a code-base out of components that can be easily reused across multiple features and multiple apps.

// MARK: - Learning the lingo

// It’s difficult to explain how to design objects and their dependencies without agreeing on a vocabulary.
// Developers have not adopted a standard set of terms, so ye can start by using the following definitions and terms with our teams; just know that your milage may vary when using these terms with the iOS developer community.

// Typically, when app developers use the term "dependency", they are talking about "libraries".
// However, here we describe a dependency as an object that another object depends on in order to do some work.
struct Person {}
struct Child {
    let person: Person // dependency
}

// - A "dependency" can also depend on other objects. These other objects are called "transitive dependencies".
struct LowLevelSystem {}
struct SubSystem {
    let lowLevel1: LowLevelSystem // transitive dependencies
    let lowLevel2: LowLevelSystem // transitive dependencies
    let lowLevel3: LowLevelSystem // transitive dependencies
}
struct System {
    let subSystem: SubSystem
}

// - The "object-under-construction" is the object that depends on dependencies. The reason an object goes under construction is to be used by yet another object — the "consumer".
// - All together, you have a consumer that needs the object-under-construction that depends on dependencies that depend on transitive dependencies and so on.
// - The relationships between these objects form an "object graph".

// object-under-construction
let sSystem = SubSystem(
    lowLevel1: LowLevelSystem(), // transitive dependencies
    lowLevel2: LowLevelSystem(),
    lowLevel3: LowLevelSystem()
)
let system = System(subSystem: sSystem) // consumer

/*

While going through this dependency patterns, you’ll see the terms "outside" and "inside".
- Outside refers to code that exists outside the object-under-construction.
- Inside refers to the code that exists inside the object-under-construction.
As you’ll see, this distinction is architecturally significant.

 That’s the terminology we’ll need to know to follow along this deep and winding object-dependency journey.
 Reviewing when and how dependencies are created will help us understand why dependencies exist in the first place.
*/

// MARK: - Creating dependencies
// How do dependencies materialize in the first place? Here’s a couple of common scenarios.

// - Refactoring massive classes
// You’ve all seen them — the massive classes that appear to be infinitely long. Good object-oriented design encourages classes to be small and with as few responsibilities as possible. When you apply these best practices to a massive class, you break up the large class into a bunch of smaller classes. Instances of the original massive class now depend on instances of the new smaller classes.

// - Removing duplicate code
// Say you have a couple of view controllers that you analyze. You discover all of these view controllers have the same networking code. You extract the networking code into a separate class. The view controllers now depend on the new networking class. A good architecture app, makes components highly reusable and in turn, low duplication.

// - Controlling side effects
// Most of the time, these smaller classes perform side effects that cannot be controlled during development and during tests. We use find ways to get control over side effects.

// How you do this refactoring has a direct impact on how many of the outlined goals you can achieve. There are three fundamental considerations that will help you achieve the goals.

// MARK: - The fundamental considerations
// When you design objects that depend on each other, you have to decide how the object-under-construction will get access to its dependencies. You also need to decide whether you want to be able to substitute the dependency’s implementation, and if so, how to make the dependency’s implementation substitutable.

// - Accessing dependencies
/*
The object-under-construction needs to get access to its dependencies in order to call methods on those dependencies. Here are the ways an object-under-construction can get a hold of its dependencies.
 1) From the inside:
      - Global property: The object-under-construction can simply access any visible global property.
      - Instantiation: If a dependency is ephemeral, i.e. the dependency doesn’t need to live longer than the object-under-construction, the object-under-construction can instantiate the dependency.

 2) From the outside:
      - Initializer argument: A dependency can be provided to the object-under-construction as an initializer argument.
      - Mutable stored-property: A dependency can be provided to an already created object-under-construction by setting a visible mutable stored-property on the object-under-construction.
      - Method: Dependencies can be provided to the object-under-construction through visible methods of the object-under-construction.
 */

// - Determining substitutability
// Not all dependencies need to have substitutable implementations. For example, you probably don’t need to substitute the implementation of a dependency that has no side effects, i.e. it only contains pure business logic. However, if the dependency writes something to disk, makes a network call, sends analytic events, navigates the user to another screen, etc. then you probably want to substitute the dependency’s implementation during development or during testing.

// - Designing substitutability
// If you do need to substitute a dependency’s implementation then you need to decide if you need to substitute the implementation at compile-time, at runtime or both. To illustrate, you’ll probably need runtime substitutability when you need to provide a different experience to different users for A/B testing. On the other hand, for testing, developers typically rely on compile-time substitutability.

// MARK: - Why is this architecture?
// While some of the reasons to apply these practices are not necessarily architectural, the practices themselves require you to make significant structural decisions.
// In theory, you can design a good architecture without these techniques outlined.
// However, if you’re writing software using industry best practices, such as unit testing, you’ll definitely need to know about these techniques. On the flip side, these techniques are not a silver bullet. It’s also possible to design a poor architecture while using these techniques.

// MARK: - Dependency patterns
// "Dependency Injection" and "Service Locator" are the most-used patterns in software engineering.

//  1) Dependency Injection: The basic idea of the pattern is to provide all dependencies outside the object-under-construction.
//  2) Service Locator: A Service Locator is an object that can create dependencies and hold onto dependencies. You provide the object-under-construction with a Service Locator. Whenever the object-under-construction needs a dependency, the object-under-construction can simply ask the Service Locator to create or provide the dependency. This pattern is easier to use than Dependency Injection but results in more work when harnessing automated tests.

// Here are other patterns you can use that have been created by the Swift community:
// - Environment: An environment is a mutable struct that provides all the dependencies needed by objects-under-construction. This pattern is very similar to Service Locator; the only difference is an environment is accessed inside objects-under-construction, and a Service Locator is provided to the object-under-construction. This is a neat lightweight approach to managing object dependencies.
// - Protocol Extension: This pattern uses Swift’s protocol extensions to allow the object-under-construction to get access to its dependencies.

// MARK: - Dependency Injection
/*
 The main goal of Dependency Injection is to provide dependencies to the object-under-construction from the outside of the object-under-construction as opposed to querying for dependencies from within the object-under-construction. Dependencies are “injected” into the object-under-construction.
 
 Externalizing dependencies allows you to control dependencies outside the object-under-construction — in a test, for example. By externalizing dependencies, you can easily see what dependencies an object has by looking at the object’s public API. This helps other developers reason about your code, including your future self!
 
 When developers hear “Dependency Injection,” they commonly think about Dependency Injection frameworks. However, Dependency Injection is first and foremost a pattern that you can follow with or without a framework. The best way to learn Dependency Injection is without using a framework.
 
 Next we will look at the history behind Dependency Injection.
 */

// - History of Dependency Injection
/*
 Dependency injection, or DI, is not a new concept. Ask any Android developer if they are familiar with DI, and they will likely tell you DI is essential to building well-architected apps. Dependency injection is also heavily used when building Java backend applications. So, it’s no surprise that Java developers take advantage of the design pattern when moving to Android.
 
 DI is intimately built into the core of some popular frameworks like AngularJS. The official AngularJS documentation has an entire section on the topic. The authors of the documents stressing that DI is “pervasive throughout Angular.”
 
 The object-oriented theory behind DI has been around for a while. DI is based on the Dependency Inversion Principle, also known as Inversion of Control. According to Martin Fowler, Inversion of Control was first written about in 1988 in a paper titled Designing Reusable Classes by Johnson and Foote. Arguably, the concept was popularized by Robert Martin’s paper, Object Oriented Design Quality Metrics: An Analysis of Dependencies published in 1994. These papers are worth a read if you want to dig deep into the roots of object-oriented design.
 The term Dependency Injection was coined by Fowler in his January 14, 2004, post titled, Inversion of Control Containers and the Dependency Injection Pattern. The increasing popularity of Agile and Test-Driven Development motivated developers to find ways to easily test object-oriented code. As a result, to meet testability needs, developers invented Inversion of Control and, more specifically, DI. As you’ll see, using Dependency Injection is key to building testable and maintainable iOS apps.
 */

// - Types of injection
/*
 There are three types of injection:
 
 1) Initializer: The consumer provides dependencies to the object-under-construction’s initializer when instantiating the object-under-construction. To enable this, you add dependencies to the object-under-construction’s initializer parameter list. This is the best injection type because the object-under-construction can store the dependency in an immutable stored-property. The object-under-construction doesn’t need to handle the case in which dependencies are nil and doesn’t have to handle the case in which dependencies change. Initializer injection isn’t always an option, so that’s when you would use property injection, the next injection type.
 2) Property: After instantiating the object-under-construction, the consumer provides a dependency to the object-under-construction by setting a stored-property on the object-under-construction with the dependency. If you don’t have a default implementation for a property-injected-dependency, then you’ll need to make the property type Optional. This injection type is usually used in Interface Builder-backed view controllers because you don’t have control over which initializer UIKit uses to create Interface Builder-backed view controllers.
 3) Method: The consumer provides dependencies to the object-under-construction when calling a method on the object-under-construction. Method injection is rarely used; however, it’s another option at your disposal. If a dependency is only used within a single method, then you could use method injection to provide the dependency. This way, the object-under-construction doesn’t need to hold onto the dependency. Remember, the less state an object has, the better. The shorter an object’s lifetime, the better.
 
 A good rule of thumb is when the object-under-construction cannot function without a dependency, use initializer injection. If the object-under-construction can function without a dependency, you can use any type of injection, preferably initializer injection.
 */

// - Circular dependencies
// Sometimes, two objects are so closely related to each other that they need to depend on one another. For this case to work when using Dependency Injection, you have to use property or method injection in one of the two objects that are in the circular dependency. That’s because you cannot initialize both objects with each other; you have to create one first and then create the second object with the first object via initializer injection, then set a property on the first object with the second. Also, remember to avoid retain cycles by making one reference weak or unowned.

// - Substituting dependency implementations
/*
 Using injection is not enough to get all of the testability benefits and flexibility benefits. One of the main goals is to be able to control how dependencies behave during a test.
 
 Say you have a dependency class that stores and retrieves data from a database. Injecting this database object, i.e., dependency, into a view controller does not give you control over how the database object behaves during a test. This is true because the view controller depends on a specific implementation of the database dependency that cannot be substituted at runtime. In order to control this dependency, the view controller should be able to accept a different implementation of the database object so that a fake implementation, which you control, can be injected during a test.
 
 Therefore, injection alone does not enable substitutability. To enable substitutability, you need to define protocols for dependencies so the consumer can inject different classes that conform to the dependency’s protocol. When designing an object-under-construction, use protocol types for dependencies.
 
 Recall that you can make dependency implementations substitutable at compile-time, at runtime or both. Each dependency is instantiated somewhere. In order to substitute a dependency’s implementation, you wrap the dependency’s instantiation with an if-else statement. In one condition you can instantiate a fake type for testing and, in another condition, you can instantiate a production type for running the app. Writing this if-else statement is different for compile-time substitution versus runtime substitution.
 */

// - Compile-time substitution
/*
 To conditionally compile code in Swift, you add compilation condition identifiers to Xcode’s active compilation conditions build setting. Once you add custom identifiers to the active compilation condition’s build setting, you use the identifiers in #if and #elseif compilation directives.
 
 You can use conditional compilation to change the dependency implementation that you want for a specific build configuration. For example, if you want to use a fake remote API implementation during tests:
 
 - Create a Test build configuration.
 - Change your target scheme’s Test scheme action’s build configuration to the Test build configuration created in the previous step.
 - Add a TEST identifier to your target’s active compilation conditions build setting for the Test build configuration.
 - Find the line of code wherein the consumer is creating a real remote API instance.
 - Write an #if TEST compilation directive and, under the if statement, instantiate a fake remote API.
 - Write an #else compilation directive and instantiate a real remote API under the else.
 - Write an #endif compilation directive on the next line to close the conditional compilation block.
 
 When you run the Test action in Xcode, to run unit and UI tests, the Swift compiler will compile the code that instantiates a fake remote API. When you run any other build action, such as Run, the Swift compiler will compile the code that instantiates a real remote API. Cool! Say goodbye to those flakey tests that try to make real network calls.
 */

// - Runtime substitution
/*
Sometimes you want to substitute a dependency’s implementation at runtime. For instance, if you want to run different logic for your beta testers who are using Testflight, you’ll need to use runtime substitution since the build that Testflight uses is the exact same build distributed to end users via the App Store. Therefore, you can’t use compile-time substitution for this situation. The Testflight use case is just one example.
 
To substitute an implementation at runtime, you write an if statement around the dependency instantiation. You need to decide where to get a value that you can use to compare in the if statement. For example, you can use a remote-feature flag service, or you can key off local values, such as the app’s version number.
 
Another neat trick is to use launch arguments to substitute dependencies at runtime. This is useful when you’re developing an app in Xcode. This is neat because you don’t need to recompile the app to change dependency implementations. Simply grab the launch arguments from UserDefaults and wrap your dependency instantiations with if statements that check launch argument values. You can use this trick during development or even during a continuous integration test.
 
There are several approaches to putting Dependency Injection into practice. The following are the Dependency Injection approaches that will follow later:
 1) On-demand: In this approach, you create dependency graphs when needed in a decentralized fashion. This approach is simple yet not very practical. You can use this approach to solidify your understanding of the fundamentals and to feel some of the pain addressed by more advanced approaches.
 2) Factories: Here, you begin to centralize initialization logic. This approach is also fairly simple and is designed to help you learn the fundamentals.
 3) Single container: This approach packages all the initialization logic together into one container. Since there’s state involved, it’s a bit more difficult to put into practice than the previous two approaches.
 4) Container hierarchy: One of the problems with centralizing all the initialization logic is you end up with one massive class. You can break a single container down into a hierarchy of containers. That’s what this approach is all about.
*/

// MARK: - On-demand approach
// This approach is designed for learning DI and for using DI in trivial situations. As we’ll see, we’ll probably want to use a more advanced approach in real life. In the on-demand approach, whenever a consumer needs a new object-under-construction, the consumer creates or finds the dependencies needed by the object-under-construction at the time the consumer instantiates the object-under-construction. In other words, the consumer is responsible for gathering all dependencies and is responsible for providing those dependencies to the object-under-construction via the initializer, a stored-property or a method.

// - Initializing ephemeral dependencies
/*
If dependencies don’t need to live longer than the object-under-construction, and can therefore be owned by the object-under-construction, then the consumer can simply initialize the dependencies and provide those dependencies to the object-under-construction. These dependencies are ephemeral dependencies because they’re created and destroyed alongside the object-under-construction.
In this case, because the consumer is initializing all the dependencies, the consumer needs to know which concrete implementation to use when initializing a dependency. As long as the object-under-construction uses protocol types for its dependencies, the object-under-construction won’t know what concrete implementation the consumer used to create the dependencies, and that’s what you want.
*/

// - Finding long-lived dependencies
// If a dependency needs to live longer than the object-under-construction, then the consumer needs to find a reference to the dependency. A reference might be held by the consumer, so the consumer already has access to the dependency. Or a parent of the consumer might be holding on to a reference.

// - Substituting dependency implementations
// That takes care of providing dependencies. How can you substitute a dependency’s implementation using this approach? Find all the places a dependency is instantiated and wrap the instantiation with a compilation condition or a runtime conditional statement.
// These are the mechanics to the on-demand approach. What are the pros and cons?

// - Pros of the on-demand approach
/*
 
1) This approach is relatively easy to explain and to understand.
2) Your code is testable because you can substitute nondeterministic side effect dependencies with deterministic fake implementations.
3) You can defer decisions. For example, you can use an in-memory data store implementation while you decide on a database technology. Changing from the in-memory implementation to the database implementation is easy because you can find all the in-memory instantiations and replace them with the database instantiations. This can be a bit tedious, so this is also a con that’s addressed in more advanced approaches.
4) Your team can work on the same feature at the same time because one developer can build an object-under-construction while another builds the dependencies. The developer building the object-under-construction can use fake implementations of the dependencies while the other developer builds the real implementations of the dependencies.
*/

// - Cons of the on-demand approach
/*
1) Dependency instantiations are decentralized. The same initialization logic can be duplicated many times.
2) Consumers need to know how to build the entire dependency graph for an object-under-construction. Dependencies can also have dependencies and so on. The consumer might have to instantiate a lot of dependencies. This is not ideal because multiple consumers using the same object-under-construction class will have to duplicate the dependency graph instantiation logic.
*/

// MARK: - Factories approach
// Instantiating dependencies on-demand is a decentralized approach that doesn’t scale well. That’s because you’ll end up writing a lot of duplicate dependency instantiation logic as your dependency graph gets larger and more complex. The factories approach is all about centralizing dependency instantiation.
// This approach works for ephemeral dependencies, i.e., dependencies that can be instantiated at the same time as the object-under-construction. This approach does not address managing long-lived dependencies such as singletons.
// We will look at how to manage long-lived dependencies in the upcoming containers-approach section.

// To take the factories approach, we create a factories class.
// What does a factories class look like?

// - Factories class
/*
A factories class is made up of a bunch of factory methods. Some of the methods create dependencies and some of the methods create objects-under-construction. Also, a factories class has no state, i.e., the class should not have any stored properties.
One goal of creating a factories class is to make it possible for consumers to create objects-under-construction without having to know how to build dependency graphs required to instantiate objects-under-construction. This makes it super easy for any part of your code to get a hold of any object needed regardless of how much the object in question is broken down into smaller objects.
*/

// - Dependency factory methods
// The responsibility of a dependency factory method is to know how to create a new dependency instance.
/*
 1 - Creating and getting transitive dependencies
 Since dependencies themselves can have their own dependencies, these factory methods need to get transitive dependencies before instantiating a dependency. Transitive dependencies might be ephemeral or long-lived.
 To create an ephemeral transitive dependency, a dependency factory method can simply call another dependency factory included in the factories class.
 To get a reference to a long-lived transitive dependency, a dependency factory method should include a parameter for the transitive dependency. By adding parameters, long-lived transitive dependencies can be provided to the dependency factory method.
 
 2 - Resolving protocol dependencies
 Dependency factory methods typically have a protocol return type to enable substitutability. When this is true, dependency factory methods encapsulate the mapping between protocol and concrete types.
 This is typically called resolution because a dependency factory method is resolving which implementation to create for a particular protocol dependency. In other words, these methods know which concrete initializer to use.
 */

// - Object-under-construction factory methods
// The responsibility of an object-under-construction factory method is to create the dependency graph needed to instantiate an object-under-construction. Object-under-construction factory methods look just like dependency factory methods. The only difference is object-under-construction factory methods are called from the outside of a factories class, whereas dependency factory methods are called within a factories class.

// - Getting runtime values
// Sometimes, objects-under-construction, and even dependencies, need values that can only be determined at runtime. For example, a REST client might need a user ID to function. These runtime values are typically called runtime factory arguments. As the name suggests, you handle this situation by adding a parameter, for each runtime value, to the object-under-construction’s or dependency’s factory method. At runtime, the factory method caller will need to provide the required values as arguments.

// - Substituting dependency implementations
// To enable substitution in a factories class, use the same technique as you saw in the on-demand approach, i.e., wrap dependency resolutions with a conditional statement. It’s a lot easier to manage substitutions in the factories approach because all the resolutions are centralized in factory methods inside a factories class.
// This means you don’t have to duplicate conditional statements inside every consumer; you write the conditional statement once, and only once, for each dependency resolution. This is a big win.

// - Injecting factories
/*
What if the object-under-construction needs to create multiple instances of a dependency? What if the object-under-construction is a view controller that needs to create a dependency every time a user presses a button or types a character into a text field?
 
Factory methods return a single instance of a dependency — so, Houston, we have a problem. The trick is to find a way to give the object-under-construction the power to invoke a factory method multiple times, whenever the object-under-construction needs to create a new dependency instance.
 
Your first instinct might be to simply create an instance of the factories class within the object-under-construction.
 
The object-under-construction would then have access to every single factory method. While this is a very simple approach, the problem is that the object-under-construction becomes harder to unit test. That’s because all dependencies are no longer injected from the outside. With this approach, you’d need to work with the factories class in order to substitute real implementations with fake implementations.
 
The goal is to be able to unit test an object-under-construction without needing the factories class at all. Therefore, it’s important to give objects-under-construction the ability to create multiple instances of dependencies from the outside.
 
You can give this power to objects-under-construction from the outside using one of two Swift features: "closures" or "protocols".
*/

// - Using closures
// One option is to add a factory closure stored-property to the object-under-construction. Here are the steps:
// 1) - Declare a stored-property in the object-under-construction with a signature such as:
// let makeUseCase: () -> UseCase.
// 2) - Add an initializer parameter to the object-under-construction with the same closure type.
// 3) - Go to the factories class and find the factory method that creates the object-under-construction.
// 4) - Use initializer injection, in the object-under-construction factory method, to inject a closure that creates a new dependency. To do this, open a closure in the object-under-construction’s initializer call. Inside the closure, call the dependency factory method for the dependency in question and return the new instance. The closure captures the factories class instance so the object-under-construction essentially holds on to the factories object without knowing.
// 5) - Now, the object-under-construction can easily create a new instance of a dependency by invoking the factory closure, whenever.
// This is so cool because the object-under-construction can create as many instances without needing to know all the transitive dependencies behind the dependency created in the factory closure. This means you can change the entire dependency structure without having to change a single line of code in the object-under-construction.

// - Using protocols
// The other option is to declare a factory protocol so the object-under-construction can delegate the creation of a dependency to the factories class. Here are the steps:
// 1) - Declare a new factory protocol that contains a single method for the dependency that the object-under-construction needs to create.
// 2) The factories class will already conform to this protocol because the dependency factory method in the protocol should match the implemented factory method in the factories class. Simply declare conformance in the factories class.
// 3) Add a stored-property and initializer parameter of the factory protocol type to the object-under-construction. This allows you to inject the factories object into the object-under-construction; however, the object-under-construction will only see the single factory method defined in the protocol. The object-under-construction does not know it is injected with the factories object because the protocol restricts the object-under-construction’s view.
// 4) Go into the object-under-construction’s factory method in the factories class and update the initialization line to inject self. self is the factories object which conforms to the new factory protocol you declared.
// The object-under-construction now has the power to create new dependency instances whenever, while not having access to all the factories in the factories class. You get the same benefits with this approach as the closure approach. This decision comes down to style preference.

// - Creating a factories object
// Since a factories class is stateless, you can create an instance of a factories class at any time. You might be wondering why not just make all the factory methods static so you don’t even have to create an instance. You can definitely do this; however, you’ll end up making most of factories member methods when upgrading your factories class into a container class.

// - Pros of the factories approach
/*
1) Ephemeral dependencies are created in a central place. This gives you a lot of power to switch out entire subsystems by changing a couple of lines of code.
2) Substituting a large amount of dependencies during a functional UI test is much easier because all your dependencies are initialized in one class. Developers typically want to fake out the entire networking and persistence stack during UI tests because developers want deterministic tests so their builds don’t constantly break with false positives.
3) Consumers are more resilient to change because they no longer need to know how to build dependency graphs. That’s one less responsibility for all consumers. This helps your team work in parallel because code is more loosely coupled.
4) Code is generally easier to read because all of the initialization boilerplate is moved out of the classes that do interesting work.
*/

// - Cons of the factories approach
/*
1) In a large app, a single factories class can become extremely large. You can break up large factories classes into multiple classes.
2) This approach only works for ephemeral objects. Longer-lived objects need to be held somewhere. Ideally, all dependencies should be centrally managed regardless of lifespan.

*/

// MARK: - Single-container approach
// A container is like a factories class that can hold onto long-lived dependencies. A container is a stateful version of a factories class.
// What are some examples of long-lived dependencies? A data store is a perfect example. A data store is a container for data that is needed to render screens. Since this data can probably change, you want a single copy of this data. Therefore, you don’t want to create a new data store instance every time an object needs a data store. You probably want a single instance to live as long as the app’s process, i.e., you need a singleton. To keep a data store instance alive, you need an object to hold onto this singleton so that ARC doesn’t de-allocate the data store.

// - Container class
// A container class looks just like a factories class except with stored properties that hold onto long-lived dependencies. You can either initialize constant stored properties during the container’s initialization or you can create the properties lazily if the properties use a lot of resources. However, lazy properties have to be variables so constant properties are better by default.
// Having long-lived dependencies co-located with factories changes how factories access these long-lived dependencies.

// - Dependency factory methods
/*
 Recall that the responsibility of a dependency factory method is to know how to create a new dependency instance. Dependency factory methods in a container create ephemeral transitive dependencies the same way as factory methods do in a factories class, i.e., by calling another dependency factory.
 
 How dependency factory methods get ahold of long-lived dependencies in a container, though, is different than in a factories class.
 
 To get a reference to a long-lived transitive dependency, a dependency factory method gets the dependency from a stored property. This is nice because it removes the need to add parameters to factory methods.
*/

// - Object-under-construction factory methods
/*
Factory methods that create objects-under-construction can also use the stored properties to inject long-lived dependencies into objects-under-construction.
 
Just like dependency factory methods from above, these factory methods also don’t need to have parameters for long-lived dependencies. This is a huge benefit for consumers because consumers don’t have to manage anything in order to create objects-under-construction. They simply invoke the empty argument factory method or provide runtime values.
 
Consumers can now create objects-under-construction without having to know anything about the dependency graphs behind these objects. This gives your code flexibility because one developer can change the dependency graph without affecting the developer building the code around the consumer.
 
That takes care of linking a container’s stored properties to factory method implementations.
*/

// - Substituting long-lived dependency implementations
// You can substitute implementations of long-lived dependencies by wrapping their initialization line with a conditional statement. This is possible as long as the long-lived stored properties use a protocol type. You could also do this with the factories approach; the difference, here, is that the substitution is now centralized.
// Easy peasy. At this point, you probably want to know when and how to create a container.

// - Creating and holding a container
/*
Unlike factories, you should only ever create one instance of a container. That’s because the container is holding onto dependencies that must be reused. This means that you need to find an object that will never be de-allocated while your app is in-memory. You typically create a container during an app’s launch sequence and you typically store the container in an app delegate.
Going from learning how to build a factories class to learning how to build a single container is not a huge leap. However, the theory behind containers gets interesting when you need to break a single container into a container hierarchy.
*/

// - Pros of the single-container approach
/*
1) A container can manage an app’s entire dependency graph. This removes the need for other code to know how to build object graphs.
2) Containers manage singletons; therefore, you won’t have singleton references floating in global space. Singletons can now be managed centrally by a container.
3) You can change an object’s dependency graph without having to change code outside the container class.
*/

// - Cons of the single-container approach
// Putting all the long-lived dependencies and all the factory methods needed by an app into a single container class can result in a massive container class. This is the most common issue when using DI. The good news is that you can break this massive container up into smaller containers.


// MARK: - Designing container hierarchies
// So far, we’ve read about ephemeral objects that don’t need to be reused and long-lived objects that stay alive throughout the app’s lifetime. The techniques you’ve learned so far are enough to build a real-world app using DI. Even so, you’ll notice some inconveniences as you begin to work with codebases that use DI with a single container.

// - Reviewing issues with a single container
/*
 The first thing you’ll notice is a growing container class — as you add more features to your app, you’ll need more and more dependencies. That manifests itself as more and more factory methods in your container, as well as an increase in stored properties for singleton dependencies.
 
 You’ll also notice a lot of optional conditional unwrapping. Most apps have many dependencies that need to know about the currently signed-in user to do things like authenticate HTTP requests.
 
 If all the reusable dependencies live as long as an app lives, the container logic will need to handle optional cases because the user can be signed out while the app is running.
 
 Based on the container design thus far, there’s nothing stopping any consumer from asking the container for dependencies that require the user to be signed in.
 
 Ideally, consumers would only have access to these reusable dependencies when a user is signed in. This is just one of many examples of optional case handling that sneaks into your singe-dependency container.
 */

// - Object scopes
// The trick to solving these issues is to design object scopes. To do this, think about at what point in time dependencies should be created and destroyed. Every object has a lifetime. You want to explicitly design when objects come and go. For example, objects in a user scope are created when a user signs in and are destroyed when a user signs out. Objects in a view controller scope are created when the view controller loads and are destroyed when the view controller is de-allocated.

// Here are the typical scopes you find in most apps:
/*
 1) App scope: Traditional singletons fall under this scope. Objects in the app scope are created when the app launches and are destroyed when the app is killed. Typical dependencies you find in this scope include authentication stores, analytics trackers, logging systems, etc.
2) User scope: User scope objects are created when a user signs in, and they’re destroyed when a user signs out. Some apps allow users to sign in to multiple accounts. In this case, the app could have multiple user scopes alive at the same time. Most dependencies, such as remote API’s and data stores, are usually found in this scope. This scope also typically contains more specific versions of dependencies found in the app scope. For instance, the app scope could have an anonymous analytics tracker while a user scope could have a user specific analytics tracker. Scopes are very powerful because they help convert a bunch of mutable state into immutable state. For that reason, you can go even further with scopes by designing shorter lived scopes. Here are a couple of examples.
3) Feature scope: Objects in a feature scope are created when the user navigates to a feature and are destroyed when the user navigates away. Feature scopes are handy when a feature needs to share data amongst many objects that make up the feature.
4) Interaction scope: Objects in an interaction scope are created when a gesture is recognized and are destroyed when the gesture ends. This is handy when you are building a complex user interaction. This is an example of a very short-lived scope.
 
 Once you’ve designed the scopes that you need, and once you’ve identified which dependencies should live in which scopes, the next step is to break up the single container into a container hierarchy.

 */

// - Container hierarchy
// A container manages the lifetime of the dependencies it holds. Because of this, each scope maps to a container. A user scope would have a user-scoped container. The user-scoped container is created when the user signs in and so forth. This is how the dependencies that are in the user scope are all created and destroyed at the same time, because the scoped container owns these objects.
// For every scope you design, you create a container class. When you do this, you’ll notice that scoped containers will want to have access to factory methods and stored properties from other containers. To do this, you build a "container hierarchy".

// - Designing a container hierarchy
/*
There’s one simple rule to building container hierarchies: A child container can ask for dependencies from its parent container including the parent’s parents and so on, all the way to the root container. A parent container cannot ask for a dependency from a child container.
 
The app scoped container is always the root container. If you think about how the hierarchy maps to length of object lifetimes, the rule makes a lot of sense. Parent containers live longer than child containers. If the parent was allowed to ask for a dependency from a child container, the child container might no longer be alive. So that’s the rationale for the rule.
 
Are you ready for some meta?
 
The container hierarchy is an object graph itself; therefore, you can use initializer injection to provide child containers with parent containers.
 
As with all DI conventions, this sounds more complicated than it really is. The child container’s initializer needs to have a parameter for the parent container. The child container can then hold a reference to the parent container in a stored-property. This gives the child access to all the factory methods and stored properties in the parent container.
*/

// - Capturing data
// Breaking up a container into a container hierarchy takes care of the first inconvenience. What about the second inconvenience — the one about handling optionals?
// Besides managing the lifetime of dependencies, a container can also capture data model values. This is helpful if the data model value is immutable for the lifetime of the container. Capturing data in a container is a way to convert mutable values into immutable values. This makes the code inside a container more deterministic because the logic does not have to consider a change in the captured value.

// - Pros of the container hierarchy
/*
1) Scoping allows you to design dependencies that don’t have to be singletons.
2) By capturing values in a scope, you can convert mutable values into immutable values.
3) Container classes are shorter when you divide container classes into scoped container classes.
*/

// - Cons of the container hierarchy
/*
1) Container hierarchies are more complex than a single-container solution. Developers that join your team might encounter a learning curve.
2) Even when containers are broken up into scoped containers, complex apps might still end up with really long container classes.
*/

// MARK: - Key points
/*
1- The iOS SDK is object oriented; therefore, you use object-oriented techniques to design well-architected iOS apps.
2- There are many beneficial goals including testability and maintainability that can be achieved by managing object dependencies.
3- Consumers need objects-under-construction and objects-under-construction need transitive dependencies. Together, these objects form an object graph.
4- Accessing dependencies, determining substitutability and designing substitutability form the basis of the three fundamental questions you need to answer to reap the benefits of managing object dependencies.
5- Dependency Injection, Service Locator, Environment and Protocol extensions are the main dependency patterns used by iOS app developers.
6- Dependency Injection (DI) is all about providing dependencies from the outside of objects.
7- There are three types of DI: Initializer, property and method injection.
8- You saw how to apply DI in four ways: On-demand, Factories, Single Container and Container Hierarchy.
9- When applying the DI pattern, your goal is to construct a flow, or a screen, entire object graph upfront.
10- When an object-under-construction needs to create multiple instances of a dependency, you inject a factory closure or you inject an object that conforms to a factory protocol.
*/
