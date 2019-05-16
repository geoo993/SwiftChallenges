/*
 var array = (0..<100).compactMap({ $0 })
 
 let index = Int(arc4random_uniform(UInt32(array.count - 1)))
 let chunk = 5
 let val = stride(from: 0, to: array.count, by: chunk).map {
 Array(array[$0..<Swift.min($0 + chunk, array.count)])
 }
 
 var counter = 0
 for index in 0..<val.count {
 defer { counter += 1 }
 print(index)
 }
 print(val)
 print("counter \(counter)")
 */

/*
 
 That, given an array A of N integers, returns the smallest positive integer (greater than 0) that does not occur in A.
 
 For example, given A = [1, 3, 6, 4, 1, 2], the function should return 5.
 
 Given A = [1, 2, 3], the function should return 4.
 
 Given A = [−1, −3], the function should return 1.
 
 Write an efficient algorithm for the following assumptions:
 
 N is an integer within the range [1..100,000];
 each element of array A is an integer within the range [−1,000,000..1,000,000].
 Copyright 2009–2019 by Codility Limited. All Rights Reserved. Unauthorized copying, publication or disclosure prohibited.
 
 */
public func solution(_ A : inout [Int]) -> Int {
    let min = 0
    let max = 100000
    // write your code in Swift 4.2.1 (Linux)
    guard let smallest = getSmallest(A), smallest > min, smallest < max else {
        return 1
    }
    return smallest + 1
}

public func getSmallest(_ array : [Int]) -> Int? {
    let sorted = array.sorted(by: { $0 > $1 })
    var unique = Array(Set(sorted))
    if unique.contains(0) == false {
        unique.insert(0, at: 0)
    }
    return unique.enumerated().first { (arg) -> Bool in
        let (_, element) = arg;
        if let _ = unique.firstIndex(of: element + 1) {
            return false
        }
        return true
    }?.element
}

var arr = [1, 2, 3]//[-1, -3]// [1, 3, 6, 4, 1, 2]
solution(&arr)
