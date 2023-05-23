import Foundation

// From an architectural standpoint, scalability is how easy it is to make changes to your app.
// From a database standpoint, scalability is about how long it takes to save or retrieve data to the database.
// For algorithms, scalability refers to how the algorithm performs in terms of execution time and memory usage as the input size increases.

// When you’re working with a small amount of data, an expensive algorithm may still feel fast. However, as the amount of data increases, an expensive algorithm becomes crippling. So how bad can it get? Understanding how to quantify this is an important skill for you to know.

func example(of description: String, action: () -> Void) {
  print("\n--- Example of:", description, "---")
  action()
}


// Time complexity
// For small amounts of data, even the most expensive algorithm can seem fast due to the speed of modern hardware.
// However, as data increases, cost of an expensive algorithm becomes increasingly apparent.
// Time complexity is a measure of the time required to run an algorithm as the input size increases.


example(of: "Time complexity - Constant time") {

    // Constant time
    // A constant time algorithm is one that has the same running time regardless of the size of the input. Consider the following:
    func checkFirst(names: [String]) {
        if let first = names.first {
            print(first, "is the first item")
            print("We always get the first item regardless of the input")
        } else {
            print("no names")
        }
    }
    
    // The size of the names array has no effect on the running time of this function. Whether the input has 10 items or 10 million items, this function only checks the first element of the array.
    // For brevity, programmers use a notation known as Big O notation to represent various magnitudes of time complexity.
    // The Big O notation for constant time is O(1).
    checkFirst(names: ["sam", "dexter", "paul"])
}


example(of: "Time complexity - Linear time") {
    
    // Consider the following snippet of code:
    func printNames(names: [String]) {
        for name in names {
            print(name)
        }
    }
    
    //This function prints out all the names in a String array.
    // As the input array increases in size, the number of iterations that the for loop makes is increased by the same amount.
    // This behavior is known as linear time complexity.
    // Linear time complexity is usually the easiest to understand. As the amount of data increases, the running time increases by the same amount.
    // The Big O notation for linear time is O(n).
    var values: [String] = Array(0...43).map { String($0) }
    printNames(names: values)
}



example(of: "Time complexity - Quadratic time") {
    // More commonly referred to as n squared, this time complexity refers to an algorithm that takes time proportional to the square of the input size.
    func printNames(names: [String]) {
        for _ in names {
            for name in names {
                print(name)
            }
        }
    }
    
    // This time, the function prints out all the names in the array for every name in the array. If you have an array with 10 pieces of data, it will print the full list of 10 names 10 times. That’s 100 print statements.
    
    // If you increase the input size by one, it will print the full list of 11 names 11 times, resulting in 121 print statements.
    
    // As the size of the input data increases, the amount of time it takes for the algorithm to run increases drastically. Thus, n squared algorithms don’t perform well at scale.
    
    // The Big O notation for quadratic time is O(n²).
    var values: [String] = Array(0...14).map { String($0) }
    printNames(names: values)
}


example(of: "Time complexity - Logarithmic time") {
    // So far, you’ve learned about the linear and quadratic time complexities wherein each element of the input is inspected at least once. However, there are scenarios in which only a subset of the input needs to be inspected, leading to a faster runtime.
    
    // Algorithms that belong to this category of time complexity are ones that can leverage some shortcuts by making some assumptions about the input data.
    
    // For instance, if you had a sorted array of integers, what is the quickest way to find if a particular value exists?
    
    // A naive solution would be to inspect the array from start to finish to check every element before reaching a conclusion. Since you’re inspecting each of the elements once, that would be a O(n) algorithm.
    // Linear time is fairly good, but you can do better. Since the input array is sorted, there is an optimization that you can make.
    var iterating = 0
    let number = 2
    let numbers = [1, 3, 5, 8, 10, 14, 15, 17, 19, 20, 21, 24, 25, 27, 29, 32, 33, 36, 38, 39, 40,
                   41, 44, 45, 46, 48, 50, 51, 53, 55, 56, 58, 59, 61, 63, 65, 66, 67, 68, 70, 71,
                   73, 74, 76, 77, 80, 81, 83, 86, 87, 88, 90, 93, 95, 97, 98, 99, 105, 150, 153
    ]

    func naiveContains(_ value: Int, in array: [Int]) -> Bool {
        for element in array {
            print("iterating at", iterating)
            iterating += 1
            if element == value {
                return true
            }
        }
        return false
    }
    
    print("Part one")
    let calculate = naiveContains(65, in: numbers)
    print("contains \(number)", calculate)
    
    // If you were checking if the number 451 existed in the array, the naive algorithm would have to iterate from the beginning to end, making a total of nine inspections for the nine values in the array. H
    // However, since the array is sorted, you can, right off the bat, drop half of the comparisons necessary by checking the middle value:
    iterating = 0
    func naiveContains2(_ value: Int, in array: [Int]) -> Bool {
        guard !array.isEmpty else { return false }
        let middleIndex = array.count / 2
        
        if value <= array[middleIndex] {
            for index in 0...middleIndex {
                print("iterating at", iterating)
                iterating += 1
                if array[index] == value {
                    return true
                }
            }
        } else {
            for index in middleIndex..<array.count {
                print("iterating at", iterating)
                iterating += 1
                if array[index] == value {
                    return true
                }
            }
        }
        
        return false
    }
    // the above function makes a small but meaningful optimization wherein it only checks half of the array to come up with a conclusion.
    // The algorithm first checks the middle value to see how it compares with the desired value. If the middle value is bigger than the desired value, the algorithm won’t bother looking at the values on the right half of the array; since the array is sorted, values to the right of the middle value can only get bigger.
    print("\nPart two")
    let calculate2 = naiveContains2(78, in: numbers)
    print("contains \(number)", calculate2)
    
    
    // you can take it even further with recursion
    iterating = 0
    func naiveContains3(_ value: Int, in array: [Int]) -> Bool {
        guard !array.isEmpty else { return false }
        let middleIndex = array.count / 2
        let threshold = 5
        if value <= array[middleIndex] {
            let numbersOfIndexes = Array(0..<middleIndex)
            let remainingArray = Array(array.dropLast(numbersOfIndexes.count))
            guard numbersOfIndexes.count < threshold else {
                print("iterating at", iterating)
                iterating += 1
                return naiveContains3(value, in: remainingArray)
            }
            for index in numbersOfIndexes {
                print("iterating at", iterating)
                iterating += 1
                if array[index] == value {
                    return true
                }
            }
        } else {
            let numbersOfIndexes = Array(middleIndex..<array.count)
            let remainingArray = Array(array.dropFirst(numbersOfIndexes.count))
            guard numbersOfIndexes.count < threshold else {
                print("iterating at", iterating)
                iterating += 1
                return naiveContains3(value, in: remainingArray)
            }
            for index in numbersOfIndexes {
                print("iterating at", iterating)
                iterating += 1
                if array[index] == value {
                    return true
                }
            }
        }
        return false
    }
    
    print("\nPart three")
    let calculate3 = naiveContains3(78, in: numbers)
    print("contains \(number)", calculate3)
    
    //When you have an input size of 100, halving the comparisons means you save 50 comparisons.
    // If input size was 100,000, halving the the comparisons means you save 50,000 comparisons.
    // The more data you have, the more the halving effect scales. Thus, you can see that the graph appears to approach horizontal.
    
   // Algorithms in this category are few, but extremely powerful in situations that allow for it.
    // The Big O notation for logarithmic time complexity is O(log n).
}


example(of: "Space complexity") {
    // The time complexity of an algorithm can help predict scalability, but it isn’t the only metric.
    // Space complexity is a measure of the resources required for the algorithm to run.
    // For computers, the resources for algorithms is memory. Consider the following code
    func printSorted(_ array: [Int]) {
        let sorted = array.sorted()
        for element in sorted {
            print(element)
        }
    }
    
    // The above function will create a sorted copy of the array and print the array. To calculate the space complexity, you analyze the memory allocations for the function.
    // Since array.sorted() will produce a brand new array with the same size of array, the space complexity of printSorted is O(n).
    let numbers = [1, 3, 5, 8, 10, 14, 15, 17, 19, 20, 21, 24, 25, 27, 29, 32, 33, 36, 38, 39, 40,
                   41, 44, 45, 46, 48, 50, 51, 53, 55, 56, 58, 59, 61, 63, 65, 66, 67, 68, 70, 71,
                   73, 74, 76, 77, 80, 81, 83, 86, 87, 88, 90, 93, 95, 97, 98, 99, 105, 150, 153
    ]
    print("\nprintSorted")
    printSorted(numbers)
    
    
    // You could revise the above function to the following:
    // This implementation respects space constraints.
    // The overall goal is to iterate through the array multiple times, printing the next smallest value for each iteration.
    func printSorted2(_ array: [Int]) {
        // 1 - Check for the case if the array is empty. If it is, there’s nothing to print.
        guard !array.isEmpty else { return }
        
        // 2 - currentCount keeps track of the number of print statements made . minValue stores the last printed value.
        var currentCount = 0
        var minValue = Int.min
        
        // 3 - The algorithm begins by printing out all values matching the minValue, and updates the currentCount according to the number of print statements made.
        for value in array {
            if value == minValue {
                print(value)
                currentCount += 1
            }
        }
        
        while currentCount < array.count {
            
            // 4 - Using the while loop, the algorithm finds the lowest value bigger than minValue and stores it in currentValue.
            var currentValue = array.max()!
            
            for value in array {
                if value < currentValue && value > minValue {
                    currentValue = value
                }
            }
            
            // 5 - The algorithm then prints all values of currentValue inside the array while updating currentCount.
            for value in array {
                if value == currentValue {
                    print(value)
                    currentCount += 1
                }
            }
            
            // 6 - minValue is set to currentValue so the next iteration will try to find the next minimum value
            minValue = currentValue
        }
    }
    
    // This implementation respects space constraints. The overall goal is to iterate through the array multiple times, printing the next smallest value for each iteration.
    //the above algorithm only allocates memory to keep track of a few variables, so the space complexity is O(1).
    // This is in contrast with the previous function, which allocates an entire array to create the sorted representation of the source array.
    print("\nprintSorted2")
    printSorted2(numbers)
}
