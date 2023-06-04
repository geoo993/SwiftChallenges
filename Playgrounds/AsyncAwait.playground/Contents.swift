import Foundation

func example(of description: String, action: () -> Void) {
  print("\n--- Example of:", description, "---")
  action()
}

example(of: "GCD") {
    // Completion handlers are commonly used in Swift code to allow us to send back values after a function returns, but they had tricky syntax as you’ll see.
    
    // if we wanted to write code that fetched 1000 weather records from a server, processes them to calculate the average temperature over time, then uploaded the resulting average back to a server, we might have written this:
    
    func fetchWeatherHistory(completion: @escaping ([Double]) -> Void) {
        // Complex networking code here; we'll just send back 1000 random temperatures
        DispatchQueue.global().async {
            let results = (1...1000).map { _ in Double.random(in: -10...30) }
            completion(results)
        }
    }
    
    func calculateAverageTemperature(for records: [Double], completion: @escaping (Double) -> Void) {
        // Sum our array then divide by the array size
        DispatchQueue.global().async {
            let total = records.reduce(0, +)
            let average = total / Double(records.count)
            completion(average)
        }
    }
    
    func upload(result: Double, completion: @escaping (String) -> Void) {
        // More complex networking code; we'll just send back "OK"
        DispatchQueue.global().async {
            completion("OK")
        }
    }
    
    fetchWeatherHistory { records in
        calculateAverageTemperature(for: records) { average in
            upload(result: average) { response in
                print("Server response for GCD: \(response)")
            }
        }
    }
}

// Hopefully you can see the problems with this approach:

// - It’s possible for those functions to call their completion handler more than once, or forget to call it entirely.
// - The parameter syntax @escaping (String) -> Void can be hard to read.
// - At the call site we end up with a so-called pyramid of doom, with code increasingly indented for each completion handler.
// Until Swift 5.0 added the Result type, it was harder to send back errors with completion handlers.


example(of: "Async/Await") {
    // From Swift 5.5, we can now clean up our functions by marking them as asynchronously returning a value rather than relying on completion handlers, like this:
    @Sendable func fetchWeatherHistory() async -> [Double] {
        (1...1000).map { _ in Double.random(in: -10...30) }
    }
    
    @Sendable func calculateAverageTemperature(for records: [Double]) async -> Double {
        let total = records.reduce(0, +)
        let average = total / Double(records.count)
        return average
    }
    
    @Sendable func upload(result: Double) async -> String {
        "OK"
    }
    
// That has already removed a lot of the syntax around returning values asynchronously, but at the call site it’s even cleaner:
    Task {
        let records = await fetchWeatherHistory()
        let average = await calculateAverageTemperature(for: records)
        let response = await upload(result: average)
        print("Server response for Async/Await: \(response)")
    }
}
