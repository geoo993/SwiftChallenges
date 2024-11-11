// https://www.linkedin.com/pulse/synchronous-asynchronous-ios-sajjad-ahmed
// https://medium.com/@frentebw/the-conception-of-sync-vs-async-serial-vs-concurrent-afda7d0830fa
import Foundation

//---- Difference between synchronous and asynchronous programming
// Synchronous programming involves executing tasks one after the other in a single thread, meaning that the program waits for one task to complete before starting another.
// In contrast, asynchronous programming allows multiple tasks to execute simultaneously in separate threads, enabling the program to continue running other tasks while waiting for a task to complete.

// Asynchronous programming is particularly useful in iOS development because it enables the creation of responsive and efficient applications. For example, when an app needs to access a remote server, using asynchronous programming can prevent the app from stalling while it waits for a response from the server. Instead, the app can continue running other tasks while waiting for the server to respond.
//On the other hand, synchronous programming can simplify certain tasks and make it easier to reason about program flow. It can also help avoid issues such as race conditions that can arise when multiple threads are accessing shared resources simultaneously. However, it can also lead to performance issues and unresponsiveness, particularly in iOS development where devices have limited resources.

// In summary, asynchronous and synchronous programming are two different approaches to executing tasks in iOS development, with asynchronous programming being the preferred technique due to its ability to make applications more responsive and efficient.



//---- Synchronous example

print("\nFunction that simulates a time-consuming task")
func fetchDataSynchronously() {
    print("Sync: Fetching data...")
    Thread.sleep(forTimeInterval: 3) // Simulate a 3-second delay
    print("Sync: Data fetched!")
}
print("Sync: Start")
fetchDataSynchronously()  // This will block the thread until it's done
print("Sync: End - Will only print after the 3 seconds are over")
// In summary synchronous programming:
// - code is executed in a blocking manner meaning when a function is called, the program will wait for the function to complete before moving on to the next line of code.
// - code is easier to write and debug because the execution order is predictable
// - can lead to performance issues if the code takes a long time to execute. such event can block the main thread, leading to potential slowdowns or freezing in our app UI.
// - can help avoid issues such as race conditions


//---- Asynchronous example
print("\nFunction that simulates a time-consuming task asynchronously")
func fetchDataAsynchronously() {
    print("Async: Fetching data...")
    DispatchQueue.global().async { // the queue is in the background
        Thread.sleep(forTimeInterval: 3)  // Simulate a 3-second delay
        DispatchQueue.main.async {
            print("Async: Data fetched!")
        }
    }
}

print("Async: Start")
fetchDataAsynchronously()  // This doesn't block the main thread
print("Async: End - Will print immediately, even before 'Data fetched!' because the fetch is asynchronous")

// In summary Asynchronous programming:
// - code is executed in a non-blocking manner meaning that when a function is called, the program does not wait for the function to complete before moving on to the next line of code.
// - involves multi-threading, allowing your app to run other tasks while waiting for the server to respond
// - can lead to better performance, enabling the creation of responsive and efficient applications.
// - prone to data race and race condition issues due to multiple threads being able to access shared resources simultaneously

