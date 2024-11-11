// https://developer.apple.com/news/?id=o140tv24#:~:text=October%2010%2C%202022,tasks%20continue%20in%20the%20background
// https://swiftsenpai.com/swift/swift-concurrency-get-started/
// https://www.avanderlee.com/swift/async-let-asynchronous-functions-in-parallel/
// https://www.avanderlee.com/swift/async-await/

import Foundation

/* --- Swift Concurrency
- With Swift concurrency, you can ensure small tasks that require UI updates can be prioritized while longer tasks continue in the background.
- Throughout the years, Apple has provided various tools such as grand central dispatch (GCD), Operations, and dispatch queue that help developers in writing asynchronous code.
- But recently, Apple has taken a different approach when working with concurrency in swift. They built Swift Concurrency with 'performance' and 'efficiency' in mind, whilst addressing common pitfalls of GCD like traditional callback-based or thread-based concurrency, and avoiding issues thread explosion (overcommitting the system with more threads than cpu cores) and race conditions which also comes with performance costs (memory and scheduling overheads)
- Swift Concurrency promises asynchronous code that is simple to write, easy to understand, and the best of all, free from 'race conditions'.
- The 3 major features of Swift concurrency is 'async/await', 'structured concurrency' and 'Actors'.
 */

/* --- Problems solves by Swift Concurrency
- Code structured with swift concurrency primitives provides the runtime with clear understanding of the dependency chain between the tasks.
- Code written with swift concurrency can maintain runtime a contract that threads are always able to make forward progress. As a result, it allow us to provide our application the concurrency it needs while making sure to avoid the known pitfalls of excessive concurrency.
 - As a result of Swift Concurrence, we are therefore able to eliminate Race conditions and Data races.
*/


//------ Async / Await
/*
- This async/await provides a structured way of defining asynchronous code.
- Async stands for asynchronous and can be seen on a method attribute making it clear that a method performs asynchronous work. These methods replace the often seen closure completion callbacks.
- Await is the keyword to be used for calling async methods. You can see them as best friends in Swift as one will never go without the other. Meaning await indicates we are awaiting for the async task to return a result.
 */

/* --- Problems that async/await solve
- Async/await aim to solve a few problems
 1) it helps us handle control flow of concurrent tasks in that it helps us avoid pyramid of doom like seen in GCD. essentially helps avoid nested callbacks and makes code easier to follow.
 2) it provides better error handling - when asynchronous operations are used, error handling is required, and it is not trivial to handle errors throughout the control flow between asynchronous calls.
 3) it simplifies management of dispatch queues, since we often work with multiple concurrent flows it can be problematic in specifying which queue to operate on.
 4) overall it provides great convenience to work with asynchronous code and makes our code easier to read, since the control flow is top to bottom and we don’t have to have completionHandlers everywhere
 */

//-------- Example 1, Async/Await version of GCD
print("--Example 1 -- Async await equivalent of GCD")
// From the GCD example, hopefully you can see the problems with its approach:
// - It’s possible for those functions to call their completion handler more than once, or forget to call it entirely.
// - The parameter syntax @escaping (String) -> Void can be hard to read.
// - At the call site we end up with a so-called pyramid of doom, with code increasingly indented for each completion handler.

// From Swift 5.5, we can now clean up our functions by marking them as async and returning a value rather than relying on completion handlers.

func fetchWeatherHistory() async throws -> [Double] {
    let results = (1...1000).map { _ in
        Double.random(in: -10...30)
    }
    try await Task.sleep(nanoseconds: 2 * 1_000_000_000)  // 2 seconds
    return results
}
    
func calculateAverageTemperature(for records: [Double]) async -> Double {
    let total = records.reduce(0, +)
    let average = total / Double(records.count)
    return average
}
    
func upload(result: Double) async -> String {
    "OK with result: \(result)"
}

Task {
    do {
        let records = try await fetchWeatherHistory()
        let average = await calculateAverageTemperature(for: records)
        let response = await upload(result: average)
        print("Server response for Async/Await: \(response)")
    } catch {
        print("Failed to fetch result with error: \(error.localizedDescription)")
    }
}

//------ Structured concurrency
/*
 - One major benefit of Swift concurrency is Structured Concurrency, it makes it easier to reason about the order of execution. Methods are linearly executed without going back and forth like you would with closures.
 - Structured concurrency help us execute multiple tasks concurrently. It offers apis that you can use to work with multiple concurrent tasks, such as 'async-let' binding and 'task group'.
 - Structured concurrency ensures that tasks have a clear lifecycle, and they are automatically canceled when no longer needed.
 */


/* ---- Tasks and task groups
 - Tasks are a unit of asynchronous work, which is required when awaiting an async operation.
 - Within the context of a task, code can be suspended and run asynchronously.
 - Task and TaskGroup, allow us to run concurrent operations either individually or in a coordinated way.
 - When using a Task object and passing it the operation you want to run. This will start running on a background thread immediately, and you can use await to wait for its finished value to come back.
 - When working with more complex tasks, you should create task groups instead. A task group is a form of structured concurrency that is designed to provide a dynamic amount of concurrency. It allows you to work with a collections of tasks that will produce a finished value.
 - Tasks added to a group cannot outlive the scope of the block in which the group is defined. A child task added this way will begin executing immediately and in any order. Finally when the group object goes out of scope, the completion of all tasks within it will be implicitly awaited.
 */
print("--Example 2 -- Task groups: Simulating an asynchronous data fetches")

func fetchData(from source: String) async -> String {
    let delay = UInt64.random(in: 1_000_000_000...2_000_000_000)  // This simulates fetching data from an API with a random delay between 1 to 2 seconds.
    try? await Task.sleep(nanoseconds: delay)  // Simulate network delay
    return "Data from \(source)"
}

func fetchAllData() async -> [String] {
    let sources = ["API 1", "API 2", "API 3", "API 4", "API 5"]
    var results: [String] = []
    
    // Create a TaskGroup to run fetch multiple tasks concurrently inside the task group.
    await withTaskGroup(of: String.self) { group in
        
        // Add tasks to the task group
        for source in sources {
            group.addTask {
                await fetchData(from: source)
            }
        }
        
        // Collect results as tasks finish
        // As each task in the group finishes, its result is returned asynchronously.
        // This allows us to handle the results in the order the tasks complete.
        for await result in group {
            print(result)
            results.append(result)
        }
    }
    print("All data fetched.")
    return results
}

// Top-level code to call the function
Task {
    await fetchAllData()
    let allResults = await fetchAllData()
    print("Final results: \(allResults)")
}

/* ---- Async let
 - Async-let allows us to define child tasks in our parent task.
 - When the system encounter an async let statement, a child task is created, while the main/parent task continues running.
 - The parent task will suspend (if needed) only when it needs to get the result from the async let child task, and it does so by using the (try) await keyword. In other words, the parent task might suspend when it start using the variables that are concurrently bound.
 */
print("--Example 3 -- Async let")

func task1() async {
    try? await Task.sleep(nanoseconds: 1_000_000_000)  // Simulate 1-second delay
    print("Task 1 completed")
}

func task2() async {
    try? await Task.sleep(nanoseconds: 2_000_000_000)  // Simulate 2-second delay
    print("Task 2 completed")
}

func runConcurrentTasks() async {
    // Creating two tasks concurrently
    async let t1 = task1()  // Concurrent execution
    async let t2 = task2()  // Concurrent execution

    // Awaiting both tasks to finish
    await (t1, t2)
    print("Both tasks are done")
}

// Call the function to run tasks
Task {
    await runConcurrentTasks()
}


//------ Actors
/*
 - when working on asynchronous and concurrent code, the most common problems that we might encounter are data races and deadlock. These kinds of problems are very difficult to debug and extremely hard to fix.
 - With the inclusion of actors in Swift 5.5, we can now rely on the compiler to flag any potential race conditions in our code.
 - Actors are reference types and work similarly to classes. However, unlike classes, actors will ensure that only 1 task can mutate the actors’ state at a time, thus eliminating the root cause of a race condition (multiple tasks accessing/changing the same object state at the same time).
 - @MainActor is a special kind of actor that always runs on the main thread.
 - In Swift 5.5, all the UIKit and SwiftUI components are marked as MainActor. Since all the components related to the UI are main actors, we no longer need to worry about forgetting to dispatch to the main thread when we want to update the UI after a background operation is completed.
 - If you have a class that should always be running on the main thread, you can annotate it using the @MainActor. However, if you only want a specific function in your class to always run on the main thread, you can annotate the function using the @MainActor keyword.
 */

print("--Example 4 -- Actors")

actor BankAccount {
    var balance: Int
    
    init(balance: Int) {
        self.balance = balance
    }
    
    // Safe access to modify the balance
    func deposit(amount: Int) {
        balance += amount
        print("Deposited \(amount), new balance: \(balance)")
    }
    
    // Safe access to read the balance
    func getBalance() -> Int {
        return balance
    }
}

// Using the actor in an async context
let account = BankAccount(balance: 100)
Task {
    // Multiple tasks accessing the same actor concurrently
    await account.deposit(amount: 50)
    print("Current balance: \(await account.getBalance())")
    
    await account.deposit(amount: 100)
    print("Current balance: \(await account.getBalance())")
}
