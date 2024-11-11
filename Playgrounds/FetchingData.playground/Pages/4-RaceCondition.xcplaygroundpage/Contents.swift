// https://www.avanderlee.com/swift/race-condition-vs-data-race/
import Foundation


/*
 --- Race Condition
 A race condition occurs when the timing or order of events affects the correctness of a piece of code.
*/

//----- Issues causes by Race conditions
// Race conditions occur when multiple threads access and modify shared resources concurrently, without proper synchronization.
// For example, if two threads try to write to the same variable at the same time, the order in which the writes occur is not guaranteed, and the final value of the variable may not be what was expected.

//---- How to figure our and solve Data condition
// - We can solve both race condition and data race by adding a locking mechanism with dispatch queue that defaults to a serial queue to ensure that only one thread at a time can access our data.
// - The locking mechanism eliminates the data race as there can’t be multiple threads accessing the same data anymore. Though, race conditions can still occur as the order of execution is still undefined. However, race conditions are acceptable and won’t break your application as long as you make sure data races can’t occur.


//--- Example 1 - Race condition in GCD
print("--Example 1 - Race condition problem")
protocol BankProviding {
    func transfer(amount: Int, from fromAccount: BankAccount, to toAccount: BankAccount)
}

class BankAccount {
    var balance: Int

    init(balance: Int) {
        self.balance = balance
    }
}

struct Bank: BankProviding {
    func transfer(amount: Int, from fromAccount: BankAccount, to toAccount: BankAccount) {
        guard fromAccount.balance >= amount else {
            return
        }
        toAccount.balance += amount
        fromAccount.balance -= amount
    }
}

let bank = Bank()
var bankAccountOne = BankAccount(balance: 100)
var bankAccountTwo = BankAccount(balance: 100)

// In the case of a single-threaded application, we can precisely predict the outcome of the following two transfers:
bank.transfer(amount: 50, from: bankAccountOne, to: bankAccountTwo)
print(bankAccountOne.balance) // 50 euros
print(bankAccountTwo.balance) // 150 euros

// In the case of a multi-threaded application, we will first witness a race condition.
// When multiple threads trigger different transfers, we can’t predict which thread executes first.
// The order of the same two transfers is unpredictable and can lead to two different outcomes based on the order of execution.
// Simulate multiple threads accessing the shared resource concurrently

let concurrentQueue = DispatchQueue.global()
bankAccountOne = BankAccount(balance: 100)
bankAccountTwo = BankAccount(balance: 100)
for _ in 0..<500 {
    DispatchQueue.global().async { // concurrent queue
        bank.transfer(amount: 2, from: bankAccountOne, to: bankAccountTwo)
        bank.transfer(amount: 3, from: bankAccountTwo, to: bankAccountOne)
        bank.transfer(amount: 3, from: bankAccountOne, to: bankAccountTwo)
        bank.transfer(amount: 2, from: bankAccountTwo, to: bankAccountOne)
    }
}
// Wait for executions to happen
Thread.sleep(forTimeInterval: 2)

//--- What is the problem in this example
// In this example, multiple threads are attempting to deposit and withdraw money from the same BankAccount object.
// The balance is shared by all the threads, but there is no synchronization around reads or writes to the balance variable.
// Depending on the timing of the thread execution, deposits and withdrawals might happen in an unexpected order, leading to incorrect results (e.g., insufficient funds despite a deposit happening).
// Since the execution order of the threads is non-deterministic (unpredictable), the outcome is not guaranteed. Different runs of the program might produce different results.
print("BANK One:", bankAccountOne.balance) // unpredictable result
print("BANK Two:", bankAccountTwo.balance) // unpredictable result


//--- Example 2 - Fixing Race condition in GCD
print("\n--Example 2 - Fixing Race condition")
// To prevent race conditions, you can synchronize access to shared resources using various synchronization techniques like serial queues, locks, or dispatch barriers.
// Using a serial DispatchQueue for synchronization ensures that only one thread can modify the balance at a time.
class SafeBankAccount: BankProviding {
    private let queue = DispatchQueue(label: "com.example.bankAccountQueue")  // Serial queue

    func transfer(amount: Int, from fromAccount: BankAccount, to toAccount: BankAccount) {
        queue.sync {
            guard fromAccount.balance >= amount else {
                return
            }
            toAccount.balance += amount
            fromAccount.balance -= amount
        }
    }
}

let safeBank = SafeBankAccount()
bankAccountOne = BankAccount(balance: 100)
bankAccountTwo = BankAccount(balance: 100)
for _ in 0..<500 {
    DispatchQueue.global().async { // concurrent queue
        safeBank.transfer(amount: 2, from: bankAccountOne, to: bankAccountTwo)
        safeBank.transfer(amount: 3, from: bankAccountTwo, to: bankAccountOne)
        safeBank.transfer(amount: 3, from: bankAccountOne, to: bankAccountTwo)
        safeBank.transfer(amount: 2, from: bankAccountTwo, to: bankAccountOne)
    }
}

// Adding a delay to give async tasks time to finish
Thread.sleep(forTimeInterval: 2)
print("BANK One:", bankAccountOne.balance) // predictable result
print("BANK Two:", bankAccountTwo.balance) // predictable result


// --- Example 3 - Fixing Race condition in GCD
print("\n--Example 3 -- Locking")
// Locks or in Swift called NSLock is another methods to prevent Race Conditions.
// You can use locks to enforce exclusive access to shared resources.
// A lock ensures that only one thread can access the critical section at a time.

class SafeBankAccountWithLock: BankProviding {
    private let lock = NSLock()

    func transfer(amount: Int, from fromAccount: BankAccount, to toAccount: BankAccount) {
        lock.lock() // lock the current thread
        guard fromAccount.balance >= amount else {
            return
        }
        toAccount.balance += amount
        fromAccount.balance -= amount
        lock.unlock() // unlock the current thread
    }
}

let safeBankLock = SafeBankAccountWithLock()
bankAccountOne = BankAccount(balance: 100)
bankAccountTwo = BankAccount(balance: 100)
for _ in 0..<100 {
    DispatchQueue.global().async { // concurrent queue
        safeBankLock.transfer(amount: 2, from: bankAccountOne, to: bankAccountTwo)
        safeBankLock.transfer(amount: 3, from: bankAccountTwo, to: bankAccountOne)
        safeBankLock.transfer(amount: 3, from: bankAccountOne, to: bankAccountTwo)
        safeBankLock.transfer(amount: 2, from: bankAccountTwo, to: bankAccountOne)
    }
}

// Adding a delay to give async tasks time to finish
Thread.sleep(forTimeInterval: 2)
print("BANK One:", bankAccountOne.balance) // predictable result
print("BANK Two:", bankAccountTwo.balance) // predictable result
