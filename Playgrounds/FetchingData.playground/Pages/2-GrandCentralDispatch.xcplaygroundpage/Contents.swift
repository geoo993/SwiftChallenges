// https://medium.com/@almalehdev/concurrency-visualized-part-1-sync-vs-async-c433ff7b3ebe
// https://medium.com/@almalehdev/concurrency-visualized-part-2-serial-vs-concurrent-fd04e32c20a9
import Foundation

/* ---- Grand Central Dispatch
 When it comes to asynchronous programming — sometimes we have code that doesn’t immediately execute as part of our program’s main control flow, but rather is dispatched onto a different queue of execution.
 GDC allows us to execute blocks of code on things called 'queues' queues which can both be queues we created ourselves (such as serial queues), and ones provided to us by the system (such as concurrent queues like DispatchQueue.global).
 */

/* --- What are queues in GCD
// A DispatchQueue is the abstraction layer on top of the GCD queue that allows us to perform tasks asynchronously (unpredictable amount of time) and concurrently (multiple tasks at once) in our application.
 Its important to understand the difference between the type of queues we can run in our application,
 We have 'Concurrent' and 'Serial' queues, they help us to manage how we execute tasks and help to make our applications run faster, more efficiently, and with improved responsiveness.
 */

/*
 //----- Serial Queue

 In a serial queue, tasks are executed one at a time in a sequential order. Only one task runs at any given moment. This means that any previous work that was started has to be completed before any new work will begin. It is useful when you want to ensure that tasks are executed in a specific order.
 In GCD, the DispatchQueue(label: "CacheQueue") is a by default a serial queue.
*/
let serialQueue = DispatchQueue(label: "com.example.mySerialtQueue")
serialQueue.async {
    print("Serial task running asynchronously")
}

/*
//----- Concurrent Queue
 
In a concurrent queue, multiple tasks can run simultaneously. These are dispatch queues that allows us to execute multiple tasks at the same time, meaning that multiple pieces of work can be executed simultaneously.
Tasks are still started in the order they are added, but they can finish in a different order and respond at different times since some task may take longer than others. This is why they may overlap at the en of their execution.
Using concurrent queue can improve performance if the tasks don’t have to execute in sequential order. This is why using concurrency is one the most applied techniques when building applications.
*/

let concurrentQueue = DispatchQueue.global()
concurrentQueue.async {
    print("Concurrent task running asynchronously")
}

/* ---- DispatchQueue running Synchronously or Asynchronously
 Another important thing to understand is that a DispatchQueue task can be run synchronously or asynchronously.
 Synchronous tasks are those that will block the calling thread until the task is finished.
 Asynchronous task are those that will directly return on the calling thread without blocking.
 This is why when adding tasks to the queue from the main thread, you want to prevent yourself from using the sync method for long-running tasks which would block the main thread and makes your UI unresponsive.
 
 System queues like DispatchQueue.main queue is the queue that all of our UI code is (actually must be) executed on. This main dispatch queue is a globally available serial queue executing tasks on the application’s main thread.
 */

let mainApplicationQueue = DispatchQueue.main
mainApplicationQueue.async {
    print("Running tasks asynchronously in the main thread")
}

//---- Example of GCD DispatchQueue
// Completion handlers are commonly used in GCD code to allow us to send back values after a function returns value, but they had tricky syntax as you’ll see.
// if we wanted to write code that fetched 1000 weather records from a server,
// processes them to calculate the average temperature over time,
// then uploaded the resulting average back to a server, we might have written this:

func fetchWeatherHistory(completion: @escaping @Sendable ([Double]) -> Void) {
    // Complex networking code here; we'll just send back 1000 random temperatures
    DispatchQueue.global().async {
        let results = (1...1000).map { _ in Double.random(in: -10...30) }
        completion(results)
    }
}

func calculateAverageTemperature(for records: [Double], completion: @escaping @Sendable (Double) -> Void) {
    // Sum our array then divide by the array size
    DispatchQueue.global().async {
        let total = records.reduce(0, +)
        let average = total / Double(records.count)
        completion(average)
    }
}

func upload(result: Double, completion: @escaping @Sendable (String) -> Void) {
    // More complex networking code; we'll just send back "OK"
    DispatchQueue.global().async {
        completion("OK with result: \(result)")
    }
}

fetchWeatherHistory { records in
    calculateAverageTemperature(for: records) { average in
        upload(result: average) { response in
            print("Server response for GCD: \(response)")
        }
    }
}

/* ---- Best practices
- When we want to perform some form of heavy operation (such as a network request, a database query, or loading files) it’s often better to use a background queue, rather than the app’s main queue since it lets our UI continue to function while we’re performing our task.
- When a long running task is completed and needed to be brought back in the app main queue, we need to run those tasks back in the app main queue DispatchQueue.main
- To prevent Race condition or Data race implement Data synchronisation techniques with Serial Queues where access to data can be done one at a time.
- Use the global concurrent queue which can optionally have a specified quality of service, to tell the system how important/urgent the code we submit onto it is. userDefined is the highest priority quality of service.
*/
