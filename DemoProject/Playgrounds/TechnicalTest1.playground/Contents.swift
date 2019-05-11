import UIKit

//var str = "Hello, playground"

/*
 
 hat, given an array A of N integers, returns the smallest positive integer (greater than 0) that does not occur in A.
 
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


// you can write to stderr for debugging purposes, e.g.
// fputs("this is a debug message\n", stderr)
//
//public func solution(_ N : Int) {
//    // write your code in Swift 4.2.1 (Linux)
//    let isPositive = (N % 2 == 0)
//    if isPositive == false {
//        print("Please enter a positive number")
//        return
//    }
//    for index in 1..<N {
//        let divisibleCount = divisibleCounter(index: index)
//        switch divisibleCount {
//        case 0:
//            print(index)
//        case 1:
//            print("Codility")
//        case 2:
//            print("CodilityTest")
//        case 3:
//            print("CodilityTestCoders")
//        default:
//            print("")
//        }
//    }
//}
//
//func divisibleCounter(index: Int) -> Int {
//    let dividers = [2, 3, 5]
//    return dividers
//        .map({ index.isMultipleNumber(of: $0) ? true : false })
//        .filter({ $0 == true }).count
//}
//
//extension Int {
//    func isMultipleNumber(of number: Int) -> Bool {
//        return self % number == 0
//    }
//}
////let number = 2003
//
////number.isMultipleNumber(of: 5)
////number.isMultiple(of: 5)
//solution(24)
