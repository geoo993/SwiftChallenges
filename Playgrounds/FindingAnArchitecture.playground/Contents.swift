import UIKit

// MARK: - Which architecture if right for me?

// You might be wondering: Which architecture pattern is right for me? Honestly, there’s no perfect universal app architecture. An architecture that works best for one project might not work best for your project. There are many different aspects to consider when establishing an architecture for you and your team to follow. This chapter guides you through the process of finding the best architecture for your project.

// There’s a lot that goes into shaping your app’s codebase into a cohesive and effective architecture. Knowing where to start can especially be overwhelming. Every single file in your app’s codebase plays a part in your app’s architecture. There’s no shortage of architecture patterns. Unfortunately, most patterns only scratch the surface and leave you to figure out the fine details. In addition, many patterns are similar to one another and have only minor differences here and there.

// All of this makes architecture hard to put into practice. Fortunately, there are pragmatic steps you can take to ensure your architecture is effective:
// 1- Understand the current state of your codebase.
// 2- Identify problems you’d like to solve or code you’d like to improve.
// 3- Evaluate different architecture patterns.
// 4- Try a couple patterns on for size before committing to one.
// 5- Draw a line in the sand and define your app’s baseline architecture.
// 6- Look back and determine if your architecture is effectively addressing the problems you want to solve.
// 7- Iterate and evolve your app’s architecture over time.

// Notice how selecting an architecture pattern isn’t the first item on the list. The reality is that selecting an architecture pattern is less important than understanding the the problems you’re trying to solve using architectural patterns. Taking the time to understand the problems you want to solve allows you to focus on the few aspects of architecture that really make a difference. While many problems will be specific to your project, there are several general problems you can solve through good architecture and they are as follows.


// MARK: - Identifying problems to solve
// Before embarking on any architecture project, you should first identify and understand the problems you’d like to solve. This will allow you to evaluate whether you’re getting the most out of your app’s architecture. A good architecture enables you and your team to easily and safely change code without a ton of risk. Making changes to code in a codebase that’s not architected well is expensive and risky.
// The two primary problems that good architecture practices solve are
// 1- slow team velocity
// 2- fragile code quality.
// Additionally, good architecture practices can help you prevent rigid software.


// MARK: - Boosting team velocity and strengthening code quality
// A good app architecture enables you to deliver features and bug fixes faster without compromising on quality. On the other hand, a less-than-ideal architecture slows your team down and makes your codebase very difficult to change without breaking existing functionality. Knowing this, what problems should you be looking for? Which problems can architecture solve?

// Here are several problems that, when present, lead to slow velocity and fragile code quality:
// - My app’s codebase is hard to understand.
// - Changing my app’s codebase sometimes causes regressions.
// - My app exhibits fragile behavior when running.
// - My code is hard to re-use.
// - Changes require large code refactors.
// - My teammates step on each other’s toes.
// - My app’s codebase is hard to unit test.
// - My team has a hard time breaking user stories into tasks.
// - My app takes a long time to compile.

// You can solve these problems by applying architecture concepts. All of these problems have common root causes. Walking through some of the root causes will help set the stage for studying each of these problems in detail.

// MARK: - Understanding root causes
// Each of these problems can be caused by two fundamental root causes:
// 1- highly interdependent code
// 2- large types

// Understanding these root causes is important when creating a plan for boosting team velocity and strengthening code quality. So what exactly are these root causes, and how do you know if they’ve made it into your codebase? That’s next.

// - Highly interdependent code
// A typical codebase has a ton of interdependencies and connections amongst variables, objects and types. Code becomes highly interdependent when code in one type reaches out to other concrete, i.e., non-protocol, types. Types usually reach out to other types in order to read-write state or in order to call methods. Making one part of your code depend on another is extremely easy. This is especially true when a codebase has a lot of visible global objects.
// Without properly encapsulating your code, your interdependencies can run rampant! The more you tightly couple parts of your codebase, the more likely something unexpectedly breaks when making code changes. This is further complicated by large teams with multiple developers because everyone needs to fully understand the interdependencies, which on very large teams may be an impossible task.

// - Large types
// Large types are classes, structs, protocols and enums that have long public interfaces due to having many public methods and/or properties. They also have very long implementations, often hundreds or even thousands of lines of code.
// Adding code to an existing type is much easier than coming up with a new type. When creating a new type, you have to think about so many things: What should the type be responsible for? How long should instances of this type live for? Should any existing code be moved to this type? What if this new type needs access to state held by another type?
// Designing object-oriented systems takes time. When you’re under pressure to deliver a feature making this tradeoff can be difficult. The opportunity cost is hard to see. The thing is, many problems are caused by large types – problems that will slow you down and problems that will affect your code’s quality. Its important to know that breaking large types into smaller types is a great way to improve your codebase’s architecture.


// MARK: - Examining the problems

// The following are some of the problems that can cause slow team velocity and fragile code quality.
// If you’re looking to boost your team’s velocity and to strengthen your code’s quality, addressing the root causes is a good start. But you might be wondering how the root causes affect team velocity and code quality.

// - My app’s codebase is hard to understand
/*
 Have you ever spent hours trying to figure out how a view controller works? Code is inherently difficult to understand because code is textual. The connections between files and types are hard to see. Having a solid understanding of how parts in your codebase are connected really helps you reason about how your code works. Therefore, the way an app is architected plays a huge role in the ease of code readability.
 
 There are several ways in which architecture can impact readability:
 
 How long are your class implementations?
 600 line view controllers are very difficult to understand. If all you need to know is how a button functions, fishing through 600 lines of view controller code will take a lot of valuable time. A good architecture breaks large chunks of code into small, modular pieces that are easy to read and understand. The more an architecture encourages locally encapsulated behavior and state, the easier the code will be to read. Think about the current app you’re working on. If a new team member joins your team tomorrow and needs to understand a single view controller, what percentage of the app’s overall codebase will that developer need to understand? This is a good gauge to use when evaluating how much your architecture is helping improve your code’s readability. Unfortunately, most architecture patterns don’t emphasize this point enough. The good news is that this practice can be applied to pretty much any architecture pattern. So this is more of a universal aspect of architecture.
 
 How many global variables does your codebase have, and how many objects are instantiated directly in another object?
 The more your objects directly depend on each other and the more your objects depend on global state, the less information a developer will have when reading a single file. This makes it incredibly difficult to know how a change in a file might affect code living in another file. This forces developers to Command-click into tons of files in order to piece together the control flow. This takes a lot of time. Similar to class size, carefully managing dependencies is unfortunately not emphasized enough by popular architecture patterns. Carefully managing dependencies is a universal aspect that can be applied to any architecture pattern.
 
 How differently are your view controllers implemented across your app’s codebase?
 Developers, including your future self, will spend a lot of time figuring things out if different features are implemented using different architecture patterns. Human brains are amazing at identifying patterns. You can take advantage of this ability by ensuring your codebase follows similar architecture patterns throughout. Having a consistent structure drastically reduces the cognitive overhead required to understand code. In turn, developers will feel more comfortable changing and improving older parts of an app’s codebase because they’ll understand the common patterns.
 In addition, using consistent architecture patterns allows you to establish a common vocabulary. Speaking the same vocabulary helps everyone easily discuss and understand each other’s code.
 Those are just a few ways in which architecture impacts code readability. Improving your code’s readability by applying architecture patterns and concepts will help you and your team boost productivity and prevent accidental bugs from creeping into your app.
 */

// - Changing my app’s codebase sometimes causes regressions
/*
Have you ever seen a small, innocent-looking code change unexpectedly break some unrelated part of your app? The probability of this happening grows as code grows and as changes are made over time. If this problem is left unchecked, you’re likely to recommend a complete project rewrite. In today’s agile world, developers are constantly changing code. Therefore, architecting code that’s resilient to change is more important than ever.
 
The main architectural cause for this problem is highly interdependent code. Say that you’re fixing a bug in a content view controller. This view controller manages the display and animation of an activity indicator. The activity indicator should stop animating when the view controller finishes loading. However, the indicator keeps animating forever. To fix this, you toggle the indicator off by stopping the animation. You do so by adding code to the content view controller that turns the animation off. The fix then gets shipped to users. Before long, you discover a new bug. The indicator stops animating, but it starts animating again soon thereafter. As it turns out, the indicator is a public property that is also being managed by a container view controller. On completion of some work, the container view controller was incorrectly turning the indicator’s animation on, when it should have been turning it off…! Ultimately, the problem here is that the control of the indicator is not encapsulated within the content view controller. There’s an interdependency between the container view controller, the content view controller and the activity indicator.
 
You can’t see the effects of code changes easily when you’re working in a codebase that’s highly interdependent. Ideally, you should be able to easily reason about how the current file you’re editing is connected to the rest of your codebase. The best way to do this is to limit object dependencies and to make the required dependencies obvious and visible.
 
This situation really slows teams down because any time any feature is built or any bug is fixed there’s a chance for something to go wrong. If something does go wrong, it might be all hands on deck to figure out the root cause. In a really fragile codebase, the change-break-fix cycle can snowball out of control. You end up spending more time fixing issues than improving your app. Not only is this a team velocity problem, it is also a code quality problem. The chances of shipping a bug to users is much higher when the connections between code are hard to see and understand. Code that’s hard to understand leads to code that easily breaks when changed. All to say, a good modular architecture can help you avoid accidentally introducing bugs when making changes.
*/

// - My app exhibits fragile behavior when running
/*
Apps can be complex systems running in complex environments. Things like multi-core programming and sharing data with app extensions contribute to the complexities involved in building iOS apps. Consequently, apps are susceptible to problems that are hard to diagnose such as race conditions and state inconsistency.
 
For example, you might notice many crash reports arriving due to a race condition associated with some mutable state. This kind of crash can take days to diagnose and fix. Enough of these kinds of issues can really grind a team to a halt. Some architecture patterns and concepts attempt to address these kinds of issues by designing constraints that act as guard rails to help teams avoid the most common pitfalls. They help you stay out of trouble. Therefore, if you find yourself working in a fairly complex environment, try establishing architecture patterns as a means to manage complexity. The more you can make your app behave in deterministic ways, the less likely users are to experience strange bugs and the less time you and your team will have to spend chasing these strange bugs.
*/

// My code is hard to re-use
/*
The structure of a codebase determines how much code you can re-use. The structure also determines how easily you can add new behavior to existing code. You might want to focus on this problem if you feel like you’re having to make similar decisions over and over again every time you build a new feature. That is, if you feel like you’re building each feature from scratch.
 
Large types can prevent your code from being reusable. For example, a huge 2,000-line class is unlikely to be reusable because you might only need part of the class.
 
The part you need might be tightly coupled with the rest of the class, making the part you need impossible to use without the rest of the class. Types that are smaller and that have less responsibility are more likely to be reusable.
 
Writing code takes more time if you can’t re-use any code. If you’re solving complex UI problems that are applicable in many different ways, it makes sense to spend time to refactor your code to be reusable. Making code reusable not only helps you build new things quicker, it helps you make modifications to existing behaviors. But what if you don’t need to re-use most of your code? For example, you probably don’t instantiate most of your view controllers from more than one place. This is important: Reusability is not just about being able to re-use code. It’s also about being able to move code around when making changes to your app. The more reusable everything is, the easier it is to shuffle code around without needing to do risky refactors.
 
Also, a codebase with code that’s not reusable can result in code quality problems. For instance, say you have field validation logic in several screens where users enter information. The validation error UI logic is duplicated in each screen’s view controller. Because similar logic is duplicated, perhaps each screen displays validation errors slightly differently, resulting in an inconsistent user experience. If someone discovers a bug, you’ll have to find all the view controllers that show validation errors. You might miss one instance and end up continuing to ship the same bug…! Ultimately, making code reusable allows you to ship a consistent user experience and allows you to tweak your app’s behavior easily.
*/

// Changes require large code refactors
/*
// How many times have you thought a feature change would be simple, yet you found yourself doing a large refactor instead? Architecture patterns not only help you re-use code, they also help you replace parts of your code without needing to do a big refactor. In a well-architected codebase, you should be able to easily make isolated changes without affecting the rest of the codebase. So what makes code hard to replace? Yep, you guessed it: large types and highly interdependent code.

// Updating the types in your code to be easily replaceable really speeds up team velocity because it allows multiple people to work on multiple parts of a codebase at the same time.
*/

// _ My teammates step on each other’s toes
/*
Your app’s architecture also impacts how easily you can work in parallel with your teammates. When a codebase doesn’t lend itself to parallel work-streams, teammates either accidentally step on each others toes or become idle waiting for a good time to start committing code again.
 
Ideally, a codebase has small enough units that each person on a team can write code in a separate file while building a feature. Otherwise, you’ll run into issues such as merge conflicts that can take a long time to resolve. For example, if your app’s main screen is completely implemented in a single view controller, the developer building the UI’s layout will probably conflict with the person building the network refresh. It’s amazing when you can meet as a team and self-organize around different aspects of building a feature. Someone can build the layout, someone else can build the networking, someone else can build the caching, someone else can build the validation logic and so on and so forth. Good architecture enables you to do this.
 
If multiple developers are building the same feature, having small types is not enough because the code that one developer is building might depend on unwritten code from other developers. While developers could hardcode fake data while they wait on other developers, they could move even faster if they agreed on APIs upfront. You can design and write protocols for those dependencies so developers can call into systems that are not built yet. This allows developers to write unit tests and even complete implementations without needing to do a large integration once all systems are built. Also, this guarantees that UI code does not depend on implementation details of networking, caching, etc.
 
Back in the day, apps were built by one- to five-person teams. Today, many apps are built by twenty or more iOS developers. Some are even built by more than a hundred developers!
 
Companies who hire lots of developers are looking for ways to maximize the productivity of large development groups by organizing developers into cross-functional feature teams. Many folks call this the “squad model.”
 
The squad model was popularized by Spotify. As your team and company grows, there comes a point where coordinating among teams takes a lot of time. The more dependent one team’s code is on another team’s code, the more these teams will have to depend on each other in order to ship. Because of this dependency, developers will start stepping on each other’s toes. This is where architecture comes into the picture. The trick is to design an app architecture that allows developers to build features in isolation.
 
An architecture that loosely couples each feature into separate Swift modules. This gives each squad a container that the squad can use to build their feature however they need. In turn, squads can ship features much faster because this kind of architecture gives squads the autonomy they need to move fast.
 
To summarize, you’ll be able to build features much faster if your app’s architecture allows your team to easily parallelize work by loosely coupling layers and features that make up your codebase.
*/

// My app’s codebase is hard to unit test
/*
Code is notoriously hard to unit test because codebases are commonly made up of parts that are tightly coupled together. This makes the different parts impossible to isolate during test. For example, a view controller might persist some data with CoreData. Because the persistence is embedded into the view controller, the persistence and view controller are tightly coupled. This means you won’t be able to unit test the view controller without having to stand-up a full CoreData stack. If your unit tests require a ton of set up, or if your unit tests perform uncontrollable side effects such as networking and persistence, then your app’s codebase could benefit from an architectural refactor.
*/

// My app takes a long time to compile
/*
While building a new feature, how many times do you build and run your app? Several dozen or more, right? A long compile time can really slow you down. A fast feedback loop can really speed things up. That sounds good, but what does compile time have to do with architecture? A modular app architecture helps the Xcode build system from recompiling code that hasn’t changed.
 
Swift language designers made a big decision when designing the Swift language. They decided against using header files. They did this to reduce duplication and to make the language easier to learn. Because Swift does not use header files, the Swift compiler has to read all of the Swift files that make up a Swift module when compiling each file. This means when you change a single file, the Swift compiler might need to parse through all the Swift files in the module. If you have lots of Swift files in a single app target, i.e. one Swift module, recompiling your app can take a while, even when you make a small change. How this works in detail is out of scope for this book, but know that the Xcode build system is getting smarter every year. Starting with Xcode 10, Xcode has the ability to do some incremental compilation.
 
Despite these improvements, breaking your app into several Swift modules can speed up your build times. This is because the Xcode build system doesn’t have to recompile modules for which Swift files have not changed. In addition, breaking your app into multiple modules results in smaller modules, i.e., modules with fewer Swift files. This means the Xcode build system has to do less work to build each module. Architectures that enable multi-module apps help you to speed up build times so you can spend less time waiting for your app to run.
 
Speeding up your local build times is great, but if that’s not good enough, you can speed up your build times even more by using a different build system that can use a distributed build cache. Build systems, such as Google’s Bazel, let you cache, download and re-use Swift modules that were compiled on someone else’s machine. Imagine building a pull request branch you just pulled only to find the app’s .ipa downloaded and installed onto your simulator without any source needing to be compiled. All because one of your co-workers already built the code found in this pull request branch. Wouldn’t that be amazing? What’s better than a zero-compile-time build?
 
These build time benefits are only possible when you have an architecture that allows for multi-module Swift codebases.
*/

// My team has a hard time breaking user stories into tasks
/*
 A good architecture can even help you plan software development projects. Breaking user stories into tasks can be very difficult. Breaking user stories into tasks that everyone on your team understands is even more difficult. For instance, if you’re planning a feature that will be implemented in a single view controller, how will you create clearly defined tasks? An app architecture that categorizes types into responsibilities creates a common vocabulary.
A common vocabulary enables you to build a shared understanding with other teammates about what kinds of objects are used to build features. This allows you to easily break down user stories into the different kinds of objects needed. For example you could break a user story up into tasks for building the UIView, the UIViewController, the RemoteAPI for networking, the DataStore for caching and so on. The quicker your team can self organize, the less time your team spends planning, and therefore, the more time your team spends building awesome features.
*/

// MARK: - Increasing code agility
// In addition to boosting your team’s velocity and strengthening your code’s quality, architecture can increase your code’s agility. Code that is agile is code that can be easily changed to meet an objective without requiring a massive re-write. Code agility buys you a lot of flexibility. It enables you to quickly respond to changes in the technology landscape. It also enables you to quickly respond to changes in user needs.

// How do you know if your code is not agile? What problems would you face?
// Here are some problems that can be solved with architecture in order to increase your code’s agility:

// 1- You find myself locked into a technology.
/*
 Have you ever needed to plan a big migration project to migrate your code from one technology to another? Or have you wanted to migrate your code from one technology to another but couldn’t because the effort would be too big? Being locked into technology can put a pause on feature development and can prevent you from taking advantage of the benefits that new technologies have to offer. This problem is especially relevant to mobile development because, as you’ve experienced, mobile technology is constantly changing.
 
 For example, if you used Parse, a once-popular yet now-defunct mobile backend as a service, you know this pain well. Third parties come and go. Many times, you’re expected to respond to these changes quickly. Your app’s architecture can help you do so.
 
 You can be locked into technology when your higher-level types, such as view controllers, are tightly coupled to lower-level system implementations. This happens when the higher-level code makes calls into implementation specific types as opposed to making calls to protocol types. For instance, if your view controllers were making direct calls to NSURLConnection, pre iOS 7, then you probably had to go into every view controller and update your code to use NSURLSession. If you have a very large codebase, you might wait until the last minute possible to migrate because of the effort involved.
 
 This is just one of many possible ways your higher-level code can be tightly coupled to lower-level systems.
 You can also be locked into a technology when your higher-level types depend on specific data formats. You typically need to work with data formats when communicating with servers and when persisting information. The server communications data format situation is the trickiest because you probably don’t control the server backend. The team that builds and maintains the backend app servers might come knocking on your door one day asking to use a different data format or even a different networking paradigm such as GraphQL.
 
 Say your app servers are sending JSON today and say your view controllers are deserializing and serializing JSON. If your server team decides to use a different format, such as Protocol Buffers, you might need to reimplement every single view controller!
 
 While the previous example is somewhat straight forward, data format issues can be a bit more nuanced though. For instance, the chat app from one of my previous projects needed to relay chat messages from chat servers to the app’s UI. Chat messages were encoded using XML. We knew not to pass XML straight to the view controllers. That wasn’t enough. The structure of the chat messages were defined by yet another standard called XMPP. We could have easily modeled the struct that carries chat messages in a way that mirrors the XMPP spec. We decided to model the struct based on the appearance properties of chat messages so that our view controllers would not be tightly coupled to the chat server technology. We didn’t want to be locked into XMPP.
 
 These are just a few ways in which your architecture can either lock you into technologies or give you the freedom to easily switch to new technologies.
 
 */

// 2- You're forced to make big decisions early in a project.
/*
 Choosing which technologies to use when starting a new project is tempting. Some of these technology choices are big decisions that feel like one-way doors. Once you’ve made a choice, there’s no looking back. As apps get more complex, developers find themselves needing to make more technology decisions. You need a lot of technologies to build modern iOS apps. Wouldn’t it be nice to be able to start building apps without having to make all the big decisions up front? You might even find that you didn’t need a certain technology after all. A good architecture allows you to make technology decisions at the most opportune time.
 The database is the classic example. Have you ever been in a CoreData versus Realm discussion? A lot of the time, these discussions happen before a single line of code is written. The problem is, these database technologies add a lot of complexity. And, if you make this decision early on, chances are good that you’ll be locked into one of these technologies. The thing is, you probably don’t have all the information you need to make this decision at the beginning of a project. In one of my previous projects we decided to design DataStore protocols and use NSCoding to serialize Objective-C objects to disk. We did this as a temporary measure until we got time to incorporate CoreData. It turned out we didn’t even need CoreData! The simplest solution was good enough. We ended up shipping the app to millions of users and never had any issues with persistence.
 Now, we could have just as easily needed a database like CoreData. The point is that you can architect to allow your team to build significant portions of your app without needing to make big, upfront decisions.
 */

// 3- Adding feature flags is difficult.
/*
 Software teams are starting to use data-driven and lean approaches to app development. To take these approaches, developers use feature flags to A/B test features and to toggle unfinished features off. Your app’s architecture can make it easy or difficult to incorporate feature flags into your app’s codebase. You’ll be able to add feature flags easily if your app’s codebase is broken down into small loosely coupled pieces. A good app architecture gives you the flexibility needed to switch between behaviors and the flexibility to turn specific things on and off.
 */


// MARK: - Surveying architecture patterns
/*
After you’ve identified the problems you’d like to solve, a good next step is to survey architecture patterns. The good news is, there are a ton of architecture patterns to chose from. The bad news is, there are a ton of architecture patterns to chose from!

 Most of the patterns are very similar to each other and you will need to figure out what order to use when exploring existing architecture patterns.
 
Since UIKit is designed with Model View Controller (MVC) in mind, any pattern other than MVC will need to be retrofitted into UIKit. Therefore, when surveying patterns, MVC is a great place to start.

Once you’ve looked at MVC, the next place to look are any of the MV- patterns, such as MVVM and MVP. The notable exception is MVI; you’ll see why in a bit. MV- patterns are the next natural place to look because these patterns are so similar to MVC. They have models and views, so they map easily to most of UIKit‘s MVC structure. With non-MVC MV- architectures, you’ll have to figure out how to connect view controllers to their equivalent types in whatever MV- pattern you’re using. For instance, you’ll have to figure out how to map view models to view controllers when using MVVM.

Clean Architecture and Ports & Adapters is a good place to look next. These concepts by themselves are very high level and abstract. You’ll need to do a lot of reading and thinking in order to apply Clean Architecture and Ports & Adapters to iOS app development. If you have time, I recommend you go down this route before jumping into any of the specific patterns derived from these concepts.
A deep understanding will help you tweak any of the derived patterns. If you want to explore the iOS architecture patterns derived from Clean Architecture and Ports & Adapters, check out VIPER and RIBs. RIBs is Uber’s take on VIPER. Clean Architecture and Ports & Adapters patterns fit really well into apps that have a lot of local business logic. If your app is presentation heavy and doesn’t have a whole lot of local business logic, these patterns might not work well for you.

Next, I recommend looking at unidirectional architecture patterns. These patterns are all about reactive UIs and state management. These are probably the hardest patterns to put into practice. However, when applied well, you get a lot of guarantees, such as state consistency, that you don’t get out of other patterns. Unidirectional patterns are definitely worth considering. If you’re interested, take a look at Flux, Redux, RxFeedback, and Model-View-Intent (MVI). Redux is the unidirectional pattern that I’ve seen applied the most in iOS app development.

One of the common properties of all these patterns is the components they define are all interconnected. They’re fairly inflexible, i.e., they’re not designed to be mixed. You might feel like you have to take one pattern over the other. But in reality they can be combined, and you can use an approach that we call Elements.

Elements is a collection of smaller architecture patterns that are designed to be independent. You can adopt one pattern, two patterns, or all of the patterns. They’re also designed to work together. The goal was to take everything we learned about applying architecture patterns to iOS and come up with a flexible approach where developers could apply bits and pieces without having to refactor entire codebases.

This gives you a bird’s eye view of some patterns you can use to shape your app’s architecture. This is by no means a comprehensive list.

New patterns pop up all the time, so it’s worth looking around to see if you can find something else that works best for you.
*/

// MARK: - Selecting a pattern
/*
 
 Once you become familiar with the patterns that look promising, you’ll want to decide which pattern(s) to use. Choosing a pattern is not easy because we tend to feel a strong connection with one pattern or another. In all honesty, which pattern you select is less important than how you put the pattern to practice.
 
 I’ve seen really well-architected MVC iOS apps, and I’ve seen very poorly architected MVVM iOS apps and vice versa. Yes, view models can be as massive as view controllers. The reality is, many patterns don’t go deep into each of their layers. For example, what exactly does a model look like in any of the MV- patterns? There’s really not a single way to design a model layer in MV- patterns. It’s very open-ended. Not only that, most patterns were not designed with mobile apps in mind — let alone today’s complex iOS environment. Therefore, most patterns only scratch the surface. Because of this, selecting the “right” pattern will not automatically result in a well-architected codebase.
 
 Hopefully, this gives you a sense of freedom! The next time you find yourself in a hotly debated discussion about architecture, remember that the patterns themselves aren’t that important. I’m not suggesting patterns are not important at all, I’m just saying that choosing a particular pattern isn’t the single most important decision. You can have a well architected app using any of the patterns.
 
 The best way to decide which pattern to use is to try a couple of the patterns in your codebase. This will give you the best information about how well a pattern will meet your needs. When trying different patterns, don’t be afraid to experiment a bit with each. Also, search the internet to see what other people’s experience has been with the patterns you’re considering.
 
 In addition, don’t forget to consider the human aspects. How big is your team? How experienced are your teammates? What patterns are your teammates most familiar with? How tight are your deadlines? And of course, consider the technical aspects such as, what constraints are you looking to design into your codebase? If you’re short on time, MVC is probably your best bet when it comes to iOS app development because you won’t have to spend time figuring how to incorporate a foreign pattern into UIKit’s MVC structure.
 
 Are there any “gotchas” to watch out for while trying out different patterns? Absolutely! Here are things you should think of:
 // - Do you end up with a lot of boilerplate code? If so, does the boilerplate at least make the code easier to understand?
 // - Do you end up with a lot of empty files that only proxy method calls to other objects?
 // - Is the pattern hard to understand?
 // - How much will you need to refactor to apply the pattern?
 // - Is the pattern adding a lot of new concepts and vocabulary?
 // - Will you need to import a library to use the pattern?
 
 These aren’t necessarily bad things. They’re just things to think about as you survey and compare different patterns. Also, don’t feel like you have to pick one pattern over another. Even though these patterns were not designed to be mixed and matched, there’s no reason you can’t combine them. For example, if you really like unidirectional pattens, but your codebase is built using MVVM, you could easily layer MVVM over something like Redux. Just have your view models dispatch actions and have your view models listening to the Redux store… In case that didn’t make any sense — no worries!
 All this to say, architecture is more of an art than science. Go experiment, learn and be creative. There’s no right way to do it. Just remember, there are many good ways to architect and there are many not-so-great ways to architect — but not a single right way.
*/

// MARK: - Putting patterns into practice
// You might be wondering what general things to look for when putting any pattern into practice. Here are some to keep in your back pocket:
// 1- Loosely coupled parts: Whether you’re using MVC, MVVM, Redux, VIPER, etc. make sure your code is broken down into small loosely coupled parts.
// 2- Cohesive types: Make sure your types exhibit high cohesion, i.e., the properties and methods that make up each type belong together. If you have small types that have very focused responsibilities, your types probably exhibit high cohesion.
// 3- Multi-module apps: Make sure your app is broken down into several Swift modules.
// 4- Object dependencies: Make sure you’re managing object dependencies using patterns such as Dependency Injection containers and Service Locators.

// These are the aspects of architecture that make a real difference.

// MARK: - Key points
// - There’s no such thing as a perfect universal app architecture.
// - You can use architecture to boost your team’s velocity, to strengthen your code’s quality and to increase your code’s agility.
// - Selecting the “right” architecture pattern won’t guarantee your codebase will be well-architected. Which pattern you select is less important than how you put the pattern to practice.
// - When putting patterns to practice make sure:
//      1- Your code is broken down into small loosely coupled parts.
//      2- Your types exhibit high cohesion.
//      3- Your app is broken down into several Swift modules.
//      4- You’re managing object dependencies using patterns such as Dependency Injection containers and Service Locators.
// - Feel free to mix and match different architecture patterns.
// - Architecture is more of an art than a science. Go experiment, learn and be creative.
