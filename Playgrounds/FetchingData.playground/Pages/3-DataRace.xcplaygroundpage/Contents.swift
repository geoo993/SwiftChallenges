import Foundation
// https://medium.com/@abhinay.mca09/how-to-solve-the-data-race-in-ios-a86fadf17f32
// https://www.avanderlee.com/swift/race-condition-vs-data-race/


/*
---- Data Race
 Data races occur when the same memory is accessed from multiple threads without synchronization, and at least one access is a write. It basically means when one thread accesses a mutable object while another thread is writing to it.
*/

//----- Issues causes by Data Race
// - Data Races can lead to several issues: unpredictable behaviour, memory corruption, flaky tests, weird crashes. The most common crash related to data race is when encountaring EXC_BAD_ACCESS.
// - As a Data Race is unpredictable, it can create inconsistencies when testing your app. You might have a crash on startup that is not occurring again the second time you start your app. If this is the case, you might be dealing with a Data Race.

//---- How to figure our and solve Data Race
// - To catch these data race issues in your code early, you can get some help by making use of the Thread Sanitizer.
// - To solve issues related to data race, since these are data access related bugs which occur when multiple threads access the same memory without proper synchronization. We could write a solution that uses dispatch queue locks. Using a lock queue, we synchronized access and ensured that only one thread at a time accessed our data. This is a fundamental solution to our problem.


//--- Example 1 - Data race in GCD
print("--Example 1 - Data race in GCD")

protocol Countable {
    var count: Int { get }
    func increment()
}

class Counter: Countable {
    var count = 0  // The shared resource is counter.count.
    
    // Non-thread-safe access to 'count', multiple threads may attempt to read, modify, and write the variable at the same time, leading to a race condition.
    func increment() {
        count += 1  // Thread-safe access
    }
}

class TestDataRace {
    let counter: Countable
    
    init(counter: Countable) {
        self.counter = counter
    }
    
    func runCounter() {
        // Simulating a race condition by running multiple threads
        // Multiple threads (500 async tasks) are incrementing the value of count simultaneously.
        for _ in 0..<500 {
            DispatchQueue.global().async {
                self.counter.increment()
            }
        }
    }
}

let dataRace = TestDataRace(counter: Counter())
dataRace.runCounter()

// Adding a short delay to give async tasks time to finish before accessing the value
Thread.sleep(forTimeInterval: 2)
// The final value of count may not be 500 as expected because of the data race.
print("Final count: \(dataRace.counter.count)")



//--- EXAMPLE 2 - Fixing Data Race
print("\n--Example 2 - Fixing Data Race")
class SafeCounter: Countable {
    var count = 0
    let queue = DispatchQueue(label: "com.example.counterQueue")  // Serial queue to ensure that all access to the count variable is serialized.

    func increment() {
        // By using queue.sync, we guarantee that only one thread can increment or read count at a time, avoiding a data race.
        queue.sync {
            count += 1  // Thread-safe access
        }
    }
    
    func getCount() -> Int {
        return queue.sync {
            return count
        }
    }
}

let counter = SafeCounter()
let dataRace2 = TestDataRace(counter: counter)
dataRace2.runCounter()

Thread.sleep(forTimeInterval: 2)
// Now the final count will always be 500 because no increments are lost.
print("Final count: \(counter.getCount())")

//-- In summmary
// Data races are common issues in concurrent programming, and preventing them requires ensuring that shared data is accessed in a thread-safe manner.
