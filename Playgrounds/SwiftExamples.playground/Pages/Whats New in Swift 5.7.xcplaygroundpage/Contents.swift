// https://www.hackingwithswift.com/articles/249/whats-new-in-swift-5-7
// https://www.swift.org/blog/swift-language-updates-from-wwdc22/

import Foundation


// Unwrap optionals
var name: String? = "Linda"
if let name {
    print("Hello, \(name)!")
}

// Closure Type Inference
let scores = [100, 80, 85]
let results = scores.map { score in
    if score >= 85 {
        return "\(score)%: Pass"
    } else {
        return "\(score)%: Fail"
    }
}
print(results)

// Regex
let message = "the cat sat on the mat"
print(message.ranges(of: "at"))
print(message.replacing("cat", with: "dog"))
print(message.trimmingPrefix("the "))

print(message.ranges(of: /[a-z]at/))
print(message.replacing(/[a-m]at/, with: "dog"))
print(message.trimmingPrefix(/The/.ignoresCase()))

// Regex Literals
let search1 = /My name is (.+?) and I'm (\d+) years old./
let greeting1 = "My name is Taylor and I'm 26 years old."
if let result = try search1.wholeMatch(in: greeting1) {
    print("Name: \(result.1)")
    print("Age: \(result.2)")
}

let search2 = /My name is (?<name>.+?) and I'm (?<age>\d+) years old./
let greeting2 = "My name is Taylor and I'm 26 years old."
if let result = try search2.wholeMatch(in: greeting2) {
    print("Name: \(result.name)")
    print("Age: \(result.age)")
}
