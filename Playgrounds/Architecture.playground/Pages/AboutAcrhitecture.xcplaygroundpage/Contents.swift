// https://www.kodeco.com/books/advanced-ios-app-architecture/v3.0/chapters/1-welcome

/*
 What is a good architecture?
 A good architecture enables us and our team to easily and safely change code without a ton of risk. Making changes to code in a codebase that’s not architected well is expensive and risky.
 Furthermore, a good app architecture enables us to deliver features and bug fixes faster without compromising on quality. On the other hand, a less-than-ideal architecture would slow our team down and make our codebase very difficult to change without breaking existing functionality.
 Good architecture practices can essentially help us prevent rigid software (software that is inflexible and difficult to change, often requiring many code changes).
 */
 
/*
 What are key issues that arise from not having an architecture?
 Architecture help us solve many common problems that teams face when building an app. To understand these problems to solve with architecture patterns and before embarking on adding any architecture in our project.
 We should first identify and understand the problems we would like to solve.
 This will allow us to evaluate whether we’re getting the most out of your app’s architecture.
 The problems to identify and solve when not having good architecture practices mainly lead us to facing 2 key issues during the development of our app:
 1) slow team velocity - in scrum team velocity is a metric that measures how much work a team can complete during a sprint.
 2) fragile code quality - this refers to code that breaks in multiple places when changed, even in areas that are not related.
*/


/*
 What are problems to look for that need architecture intervention?
Here are some problems that when present, lead to slow velocity and fragile code quality:
 1) My app’s codebase is hard to understand
 2) Changing my app’s codebase sometimes causes regressions
 3) My app exhibits fragile behaviour when running
 4) My code is hard to re-use
 5) Changes require large code refactors
 6) My teammates step on each other’s toes
 7) My app’s codebase is hard to unit test
 8) My team has a hard time breaking user stories into tasks
 9) My app takes a long time to compile
 Each of these problems can be caused by two fundamental root causes:
 1- highly interdependent code - where codebase has a ton of interdependencies and connections amongst variables, objects and types.
 2- large types - are classes, structs, protocols and enums that have long public interfaces due to having many public methods and/or properties. They also have very long implementations, often hundreds or even thousands of lines of code.
 Understanding these root causes is important when creating a plan for boosting team velocity and strengthening code quality.
 */
 
/*
 What are the next step to take when identifying these problems?
 After you’ve identified the problems you’d like to solve, a good next step is to survey architecture patterns.
 The good news is, there are a ton of architecture patterns to choose from.
 However, selecting the “right” architecture pattern won’t guarantee your codebase will be well-architected.
 Which pattern you select is less important than how you put the pattern to practice. When putting patterns to practice make sure:
 1- Your code is broken down into small loosely coupled parts.
 2- Your types exhibit high cohesion.
 3- Your app is broken down into several Swift modules.
 4- You’re managing object dependencies using patterns such as Dependency Injection containers and Service Locators.
 Feel free to mix and match different architecture patterns. 
 Architecture is more of an art than a science. You should experiment, learn and be creative.
 */
