import Foundation

// TODO: Imperative Programming Style
// When you first learned to code, you probably learned imperative style.
var numberOfProducts = 5

numberOfProducts = 3

// This code is normal and reasonable.
// First, you create a variable called numberOfProducts that equals 5, then you command numberOfProducts to be 3 later in time.
// That’s imperative style in a nutshell. You create a variable with some data, then you tell that variable to be something else.


// TODO: Problem with Mutable states
// Many papers that discuss FP single out "immutable state" and "lack of side effects" as the most important aspects of FP.

// No matter which programming language you learned first, one of the initial concepts you likely learned was that a variable represents data, or state. If you step back for a moment to think about the idea, variables can seem quite odd.

// The term “variable” implies a quantity that varies as the program runs. Thinking of the quantity numberOfProducts from a mathematical perspective, you’ve introduced time as a key parameter in how your software behaves.
// By changing the variable, you create mutable state.

// Lets take another example
var heroScore = 100

func superHero() {
    print("I'm batman")
    heroScore = 50
}

print("original state = \(heroScore)")
superHero()
print("mutated state = \(heroScore)")
// Why is heroScore now 5? That change is called a side effect. The function superHero() changes a variable that it didn’t even define itself.


// TODO: Immutable states and side effects
// Imagine if you could write code where state never mutated.
// A whole slew of issues that occur in concurrent systems would vanish.
// Systems that work like this have immutable state, meaning that state is not allowed to change over the course of a program.

// The key benefit of using immutable data is that the units of code that use it are free of side effects.
// The functions in your code don’t alter elements outside of themselves, and no spooky effects appear when function calls occur.
// Your program works predictably because, without side effects, you can easily reproduce its intended effects.

// TODO: Functional programming
// creating an ammusement park with functional programming
// Set up the data structure by adding this code to your playground:

enum RideCategory: String, CustomStringConvertible {
    case family
    case kids
    case thrill
    case scary
    case relaxing
    case water

    var description: String {
        return rawValue
    }
}

typealias Minutes = Double
struct Ride: CustomStringConvertible {
    let name: String
    let categories: Set<RideCategory>
    let waitTime: Minutes

    var description: String {
        return "Ride –\"\(name)\", wait: \(waitTime) mins, categories: \(categories)\n"
    }
}

let parkRides = [
  Ride(name: "Raging Rapids", categories: [.family, .thrill, .water], waitTime: 45.0),
  Ride(name: "Crazy Funhouse", categories: [.family], waitTime: 10.0),
  Ride(name: "Spinning Tea Cups", categories: [.kids], waitTime: 15.0),
  Ride(name: "Spooky Hollow", categories: [.scary], waitTime: 30.0),
  Ride(name: "Thunder Coaster", categories: [.family, .thrill], waitTime: 60.0),
  Ride(name: "Grand Carousel", categories: [.family, .kids], waitTime: 15.0),
  Ride(name: "Bumper Boats", categories: [.family, .water], waitTime: 25.0),
  Ride(name: "Mountain Railroad", categories: [.family, .relaxing], waitTime: 0.0)
]

func sortedNamesImp(of rides: [Ride]) -> [String] {
    // 1 - Create a variable to hold the sorted rides.
    var sortedRides = rides
    var key: Ride
    
    // 2 - Loop over all the rides passed into the function.
    for i in (0..<sortedRides.count) {
        key = sortedRides[i]
        
        // 3 - Sort the rides using an Insertion Sort sort algorithm.
        for j in stride(from: i, to: -1, by: -1) {
            if key.name.localizedCompare(sortedRides[j].name) == .orderedAscending {
                sortedRides.remove(at: j + 1)
                sortedRides.insert(key, at: j)
            }
        }
    }
    
    // 4 - Loop over the sorted rides to gather the names.
    var sortedNames: [String] = []
    for ride in sortedRides {
        sortedNames.append(ride.name)
    }
    
    return sortedNames
}

let sortedNames1 = sortedNamesImp(of: parkRides)

func testSortedNames(_ names: [String]) {
    let expected = [
        "Bumper Boats",
        "Crazy Funhouse",
        "Grand Carousel",
        "Mountain Railroad",
        "Raging Rapids",
        "Spinning Tea Cups",
        "Spooky Hollow",
        "Thunder Coaster"
    ]
    assert(names == expected)
    print("✅ test sorted names = PASS\n-")
}

print(sortedNames1)
testSortedNames(sortedNames1)
// You now know that if you change your sorting routine in the future (for example, to make it functional :]), that you can detect any bug that occurs.

// You can prove this with another test:

var originalNames: [String] = []
for ride in parkRides {
    originalNames.append(ride.name)
}

func testOriginalNameOrder(_ names: [String]) {
    let expected = [
        "Raging Rapids",
        "Crazy Funhouse",
        "Spinning Tea Cups",
        "Spooky Hollow",
        "Thunder Coaster",
        "Grand Carousel",
        "Bumper Boats",
        "Mountain Railroad"
    ]
    assert(names == expected)
    print("✅ test original name order = PASS\n-")
}

print(originalNames)
testOriginalNameOrder(originalNames)
// In the results area and console, you’ll see that sorting rides inside of sortedNamesImp(of:) didn’t affect the input list. The modular function you’ve created is semi-functional. The logic of sorting rides by name is a single, testable, modular and reusable function.

// The imperative code inside sortedNamesImp(of:) made for a long and unwieldy function. The function is hard to read and you cannot easily work out what it does

// TODO: First-Class and Higher-Order Functions
// In FP languages, functions are first-class citizens. You treat functions like other objects that you can assign to variables.
// Because of this, functions can also accept other functions as parameters or return other functions.
// Functions that accept or return other functions are called higher-order functions.


//============================== Filters
// In Swift, filter(_:) is a method on Collection types, such as Swift arrays.
// It accepts another function as a parameter. This other function accepts a single value from the array as input, checks whether that value belongs and returns a Bool.
// filter(_:) applies the input function to each element of the calling array and returns another array. The output array contains only the array elements whose parameter function returns true.

let apples = ["🍎", "🍏", "🍎", "🍏", "🍏"]
let greenapples = apples.filter { $0 == "🍏"}
print(greenapples)

// Think back to your list of actions that sortedNamesImp(of:) performs:

// - we Loop over all the rides passed to the function.
// - we Sort the rides by name.
// - we gathers the names of the sorted rides.
// Instead of thinking about this imperatively, think of it declaratively, i.e. by only thinking about what you want to happen instead of how.
// Start by creating a function that has a Ride object as an input parameter to the function:

func waitTimeIsShort(_ ride: Ride) -> Bool {
  return ride.waitTime < 15.0
}

// The function waitTimeIsShort(_:) accepts a Ride and returns true if the ride’s wait time is less than 15 minutes; otherwise, it returns false.

// If we call filter(_:) on your park rides and pass in the new function you just created:

let shortWaitTimeRides = parkRides.filter(waitTimeIsShort)
print("rides with a short wait time:\n\(shortWaitTimeRides)")

//============================= Map

// The Collection method map(_:) accepts a single function as a parameter.
// It outputs an array of the same length after applying that function to each element of the collection.
// The return type of the mapped function does not have to be the same type as the collection elements.

let oranges = apples.map { _ in "🍊" }
print(oranges)

// You can apply map(_:) to the elements of your parkRides array to get a list of all the ride names as strings:
let rideNames = parkRides.map { $0.name }
print(rideNames)
testOriginalNameOrder(rideNames)

// You can also sort the ride names as shown below, when you use the sorted(by:) method on the Collection type to perform the sorting:
print(rideNames.sorted(by: <))

// You can now reduce the code to extract and sort the ride names to only two lines, thanks to map(_:) and sorted(by:).
func sortedNamesFP(_ rides: [Ride]) -> [String] {
    let rideNames = parkRides.map { $0.name }
    return rideNames.sorted(by: <)
}

let sortedNames2 = sortedNamesFP(parkRides)
testSortedNames(sortedNames2)
// Your declarative code is easier to read and you can figure out how it works without too much trouble

//=============================== Reduce
// The Collection method reduce(_:_:) takes two parameters:
// - The first is a starting value of an arbitrary type T and
// - the second is a function that combines a value of that same type T with an element in the collection to produce another value of type T.

// For example, you can reduce those oranges to some juice:
let juice = oranges.reduce("") { juice, orange in juice + "🍹"}
print("fresh 🍊 juice is served – \(juice)")

// To be more practical, add the following method that lets you know the total wait time of all the rides in the park.
let totalWaitTime = parkRides.reduce(0.0) { (total, ride) in
    total + ride.waitTime
}
print("total wait time for all rides = \(totalWaitTime) minutes")
// As you can see, the resulting total carries over as the initial value for the following iteration.
// This continues until reduce iterates through every Ride in parkRides.

// TODO: Advanced Techniques
// Now it’s time to take things a bit further with some more function theory.


//========================== Partial Functions
// Partial functions allow you to encapsulate one function within another.

func filter(for category: RideCategory) -> ([Ride]) -> [Ride] {
    return { rides in
        rides.filter { $0.categories.contains(category) }
    }
}

// Here, filter(for:) accepts a RideCategory as its parameter and returns a function of type ([Ride]) -> [Ride].
// The output function takes an array of Ride objects and returns an array of Ride objects filtered by the provided category.

let kidRideFilter = filter(for: .kids)
print("some good rides for kids are:\n\(kidRideFilter(parkRides))")

//============================ Pure Functions
// A primary concept in FP which lets you reason about program structure, as well as test program results, is the idea of a pure function.
// A function is pure if it meets two criteria:
//  1) The function always produces the same output when given the same input, e.g., the output only depends on its input.
//  2) The function creates zero side effects outside of it.
// consider

func ridesWithWaitTimeUnder(_ waitTime: Minutes, from rides: [Ride]) -> [Ride] {
    return rides.filter { $0.waitTime < waitTime }
}

// ridesWithWaitTimeUnder(_:from:) is a pure function because its output is always the same when given the same wait time and the same list of rides.
// it’s easy to write a good unit test against the function.
let shortWaitRides = ridesWithWaitTimeUnder(15, from: parkRides)

func testShortWaitRides(_ testFilter: (Minutes, [Ride]) -> [Ride]) {
    let limit = Minutes(15)
    let result = testFilter(limit, parkRides)
    print("rides with wait less than 15 minutes:\n\(result)")
    let names = result.map { $0.name }.sorted(by: <)
    let expected = ["Crazy Funhouse", "Mountain Railroad"]
    assert(names == expected)
    print("✅ test rides with wait time under 15 = PASS\n-")
}

testShortWaitRides(ridesWithWaitTimeUnder(_:from:))


//========================== Referential Transparency
// Pure functions are related to the concept of referential transparency.
// An element of a program is referentially transparent if you can replace it with its definition and always produce the same result.
// It makes for predictable code and allows the compiler to perform optimizations. Pure functions satisfy this condition.

// You can verify that the function ridesWithWaitTimeUnder(_:from:) is referentially transparent by passing its body to testShortWaitRides(_:):

testShortWaitRides { waitTime, rides in
    return rides.filter{ $0.waitTime < waitTime }
}

// you took the body of ridesWithWaitTimeUnder(_:from:) and passed that directly to the test testShortWaitRides(_:) wrapped in closure syntax.
// That’s proof that ridesWithWaitTimeUnder(_:from:) is referentially transparent.

// Referential transparency comes in handy when you’re refactoring some code and you want to be sure that you’re not breaking anything.
// Referentially transparent code is not only easy to test, but it also lets you move code around without having to verify implementations.

//============================== Recursion
// Recursion occurs whenever a function calls itself as part of its function body.
// In functional languages, recursion replaces many of the looping constructs that you use in imperative languages.

// When the function’s input leads to the function calling itself, you have a recursive case.
// To avoid an infinite stack of function calls, recursive functions need a base case to end them.

// consider
extension Ride: Comparable {
    // In this extension, you use operator overloading to create functions that allow you to compare two rides with the < and == operator
    public static func <(lhs: Ride, rhs: Ride) -> Bool {
        return lhs.waitTime < rhs.waitTime
    }
    
    public static func ==(lhs: Ride, rhs: Ride) -> Bool {
        return lhs.name == rhs.name
    }
}

// Now, extend Array to include a quickSorted method:
// This extension allows you to sort an array as long as the elements are Comparable.
extension Array where Element: Comparable {
    
    // The Quick Sort algorithm first picks a pivot element. You then divide the collection into two parts. One part holds all the elements that are less than or equal to the pivot, the other holds the remaining elements greater than the pivot. Recursion is then used to sort the two parts. Note that by using recursion, you don’t need to use a mutable state.
    func quickSorted() -> [Element] {
        if self.count > 1 {
            let (pivot, remaining) = (self[0], dropFirst())
            let lhs = remaining.filter { $0 <= pivot }
            let rhs = remaining.filter { $0 > pivot }
            return lhs.quickSorted() + [pivot] + rhs.quickSorted()
        }
        return self
    }
}

// Verify your function works by entering the following code:

let quickSortedRides = parkRides.quickSorted()
print("\(quickSortedRides)")

func testSortedByWaitRides(_ rides: [Ride]) {
    let expected = rides.sorted(by:  { $0.waitTime < $1.waitTime })
    assert(rides == expected, "unexpected order")
    print("✅ test sorted by wait time = PASS\n-")
}

testSortedByWaitRides(quickSortedRides)

// Keep in mind that recursive functions have extra memory usage and runtime overhead. You won’t need to worry about these problems until your data sets become much larger.


// TODO: Problem
// Consider the following situation:
/*
A family with young kids wants to go on as many rides as possible between frequent bathroom breaks. They need to find which kid-friendly rides have the shortest lines. Help them out by finding all family rides with wait times less than 20 minutes and sort them by the shortest to longest wait time.
*/

//=============== Solving the Problem with the Imperative Approach
// Think about how you would solve this problem with an imperative algorithm.
// Have a try at implementing your own solution to the problem.

var ridesOfInterest: [Ride] = []
for ride in parkRides where ride.waitTime < 20 {
    for category in ride.categories where category == .family {
        ridesOfInterest.append(ride)
        break
    }
}
let sortedRidesOfInterest1 = ridesOfInterest.quickSorted()
print(sortedRidesOfInterest1)

// As written, the imperative code is fine, but a quick glance does not give a clear, immediate idea of what it’s doing.
// You have to pause to look at the algorithm in detail to grasp it.
// Would the code be easy to understand when you return to do maintenance six months later, or if you’re handing it off to a new developer?

func testSortedRidesOfInterest(_ rides: [Ride]) {
    let names = rides.map { $0.name }.sorted(by: <)
    let expected = [
        "Crazy Funhouse",
        "Grand Carousel",
        "Mountain Railroad"
    ]
    assert(names == expected)
    print("✅ test rides of interest = PASS\n-")
}

testSortedRidesOfInterest(sortedRidesOfInterest1)

//======================== Solving the Problem with a Functional Approach
// You can make your code a lot more self-explanatory with an FP solution. Add the following code to your playground:
let sortedRidesOfInterest2 = parkRides
    .filter { $0.categories.contains(.family) && $0.waitTime < 20 }
    .sorted(by: <)
// Verify that this line of code produces the same output as the imperative code by adding:
testSortedRidesOfInterest(sortedRidesOfInterest2)

// In one line of code, you’ve told Swift what to calculate.
// You want to filter your parkRides to .family rides with wait times less than 20 minutes and then sort them.
// That cleanly solves the problem stated above.
