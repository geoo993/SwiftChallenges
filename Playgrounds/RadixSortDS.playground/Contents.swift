import Foundation

func example(of description: String, action: () -> Void) {
  print("\n--- Example of:", description, "---")
  action()
}

// Radix sort

// Radix sort is a non-comparative algorithm for sorting integers in linear time. There are multiple implementations of radix sort that focus on different problems.

// We will focus on sorting base 10 integers while investigating the LEAST SIGNIFICANT DIGIT (LSD) variant of radix sort.

// To show how radix sort works, you’ll sort the following array:
var array = [88, 410, 1772, 20]

// Radix sort relies on the positional notation of integers.
// Here, you’ve added a radixSort method to arrays of integers via an extension.

extension Array where Element == Int {
    // Start implementing the radixSort method using the following:
    public mutating func radixSort() {
        // 1 - You’re sorting base 10 integers in this instance. Since you’ll use this value multiple times in the algorithm, you store it in a constant base.
        let base = 10
        // 2 - ou declare two variables to track your progress. Radix sort works in multiple passes, so done serves as a flag that determines whether the sort is complete. The digits variable keeps track of the current digit you’re looking at.
        var done = false
        var digits = 1
        while !done {
            done = true
            // Now we write the logic that sorts each element into buckets (also known as Bucket sort).
            // 1 - You instantiate the buckets using a two-dimensional array. Because you’re using base 10, you need 10 buckets.
            var buckets: [[Int]] = .init(repeating: [], count: base)
            // 2 - You place each number in the correct bucket.
            forEach { number in
                let remainingPart = number / digits
                let digit = remainingPart % base
                buckets[digit].append(number)
                if remainingPart > 0 {
                    done = false
                }
            }
            // 3 - You update digits to the next digit you wish to inspect and update the array using the contents of buckets. flatMap will flatten the two-dimensional array to a one-dimensional array, as if you’re emptying the buckets into the array.
            digits *= base
            self = buckets.flatMap { $0 }
            
            
            // Your while loop currently runs forever, so you’ll need a terminating condition somewhere.
            // You’ll do that as follows:
            // - At the beginning of the while loop, add done = true.
            // - Inside the closure of forEach, add the following: done = false
            // Since forEach iterates over all the integers, as long as one of the integers still has unsorted digits, you’ll need to continue sorting.
        }
    }
}

example(of: "radix sort") {
    var array = [88, 410, 1772, 20]
    print("Original array: \(array)")
    array.radixSort()
    print("Radix sorted: \(array)")
}

// Radix sort is one of the fastest sorting algorithms.
// The average time complexity of radix sort is O(k × n), where k is the number of significant digits of the largest number, and n is the number of integers in the array.
// Radix sort works best when k is constant, which occurs when all numbers in the array have the same count of significant digits. Its time complexity then becomes O(n). Radix sort also incurs a O(n) space complexity, as you need space to store each bucket.

// Key points
// - Unlike other searches that you’ve been working on in the previous chapter, radix sort is a non-comparative sort that doesn’t rely on comparing two values. Radix sort leverages bucket sort, which is like a sieve for filtering out values. A helpful analogy is how some of the vending machines accept coins — the coins are distinguished by size.
// - Radix sort can be one of the fastest sorting algorithms for sorting values with positional notation.
// - This chapter covered the least significant digit radix sort. Another way to implement radix sort is the most significant digit form. This form sorts by prioritizing the most significant digits over the lesser ones and is best illustrated by the sorting behavior of the String type.


// Challenge 1: Find Most significant digit

// The implementation discussed above used a least significant digit radix sort.
// See if you can implement a MOST SIGNIFICANT DIGIT radix sort.
// This sorting behavior is called lexicographical sorting and is also used for String sorting.


// MSD radix sort is closely related to LSD radix sort, in that both utilize bucket sort.
// The difference is that MSD radix sort needs to carefully curate subsequent passes of the bucket sort.
// In LSD radix sort, bucket sort ran repeatedly using the whole array for every pass.
// In MSD radix sort, you run bucket sort with the whole array only once.
// Subsequent passes will sort each bucket recursively.
extension Int {
    // digits is a computed property that returns the number of digits that the Int has. For example, the value 1024 has four digits.
    var digits: Int {
        var count = 0
        var num = self
        while num != 0 {
            count += 1
            num /= 10
        }
        return count
    }
    
    // digit(atPosition:) returns the digit at a given position.
    // Like arrays, the leftmost position is zero. Thus, the digit for position zero of the value 1024 is 1. The digit for position 3 is 4. Since there are only four digits, the digit for position five will return nil.
    func digit(atPosition position: Int) -> Int? {
        guard position < digits else { return nil }
        var num = self
        let correctedPosition = Double(position + 1)
        
        // The implementation of digit(atPosition:) works by repeatedly chopping a digit off the end of the number, until the requested digit is at the end. It is then extracted using the remainder operator.
        while num / Int(pow(10.0, correctedPosition)) != 0 {
            num /= 10
        }
        return num % 10
    }
}

extension Array where Element == Int {
    private var maxDigits: Int {
        self.max()?.digits ?? 0
    }
    
    mutating func lexicographicalSort() {
        self = msdRadixSorted(self, 0)
    }
    
    private func msdRadixSorted(_ array: [Int], _ position: Int) -> [Int] {
        // This ensures that if the position is equal or greater than the array’s maxDigits, you’ll terminate recursion.
        guard position < array.maxDigits else {
            return array
        }
        // 1 - Similar to LSD radix sort, you instantiate a two dimensional array for the buckets.
        var buckets: [[Int]] = .init(repeating: [], count: 10)
        // 2 - The priorityBucket is a special bucket that stores values with fewer digits than the current position. Values that go in the priorityBucket will be sorted first.
        var priorityBucket: [Int] = []
        
        // 3 - For every number in the array, you find the digit of the current position and place the number in the appropriate bucket.
        array.forEach { number in
            guard let digit = number.digit(atPosition: position) else {
                priorityBucket.append(number)
                return
            }
            buckets[digit].append(number)
        }
        
        // Next, you need to recursively apply MSD radix sort for each of the individual buckets.
        // This statement calls reduce(into:) to collect the results of the recursive sorts and appends them to the priorityBucket. That way, the elements in the priorityBucket always go first.
        priorityBucket.append(
            contentsOf: buckets.reduce(into: []) { result, bucket in
                guard !bucket.isEmpty else {
                    return
                }
                result.append(contentsOf: msdRadixSorted(bucket, position + 1))
            }
        )
        return priorityBucket
    }
}

example(of: "Sort Mechanism") {
    var array = [500, 1345, 13, 459, 44, 999]
    array.lexicographicalSort()
    print(array) // outputs [13, 1345, 44, 459, 500, 999]
}

example(of: "Most significant digit sort") {
    var array: [Int] = (0...10).map { _ in Int(arc4random()) }
    array.lexicographicalSort()
    print(array)
}
