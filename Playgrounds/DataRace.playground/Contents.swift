import UIKit

//Once you know what a Data Race is, you might get better at detecting potential issues in your code. However, sometimes it’s less clear that code could potentially lead to a Data Race. Therefore, a few examples to show you what a Data Race is.

// In the following piece of code, two different threads access the same String property:

let myData = MyDataRace()
myData.updateName()

// An example Data Race captured by the Thread Sanitizer
// As the background thread is writing to the name, we have at least one write access. The behavior is unpredictable as it depends on whether the print statement or the write is executed first. This is an example of a Data Race, which the Thread Sanitizer confirms.


// A lazy variable delays the initialization of an instance to the moment it gets called for the first time. This means that a data write will happen at the first moment a lazy variable is accessed. When two threads access this same lazy variable for the first time, a Data Race can occur:
myData.printName()


// we could write a solution to data race using dispatch queues locks
let myDataSolution = MyDataRaceSolution()
myDataSolution.updateNameSync()
// Using a lock queue, we synchronized access and ensured that only one thread at a time accessed the name variable. This is a fundamental solution to our problem. If you want to know more about solving this more efficiently with better performance,
