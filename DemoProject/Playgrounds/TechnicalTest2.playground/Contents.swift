
/*
 A binary gap within a positive integer N is any maximal sequence of consecutive zeros that is surrounded by ones at both ends in the binary representation of N.
 
 For example, number 9 has binary representation 1001 and contains a binary gap of length 2. The number 529 has binary representation 1000010001 and contains two binary gaps: one of length 4 and one of length 3. The number 20 has binary representation 10100 and contains one binary gap of length 1. The number 15 has binary representation 1111 and has no binary gaps. The number 32 has binary representation 100000 and has no binary gaps.
  write a function that given a positive integer N, returns the length of its longest binary gap. The function should return 0 if N doesn't contain a binary gap.

func solution(n: Int) -> Int {
    let binaryString = String(number, radix: 2)
    if let result = Int(binaryString) {
        let intArray = binaryString.map{ ($0) }.compactMap({ Int("\($0)") })
        print(result)
        print(intArray)
        
        var biggestGap = 0
        var gapCounter = 0
        for val in intArray {
            if val == 1 && gapCounter != 0 && gapCounter > biggestGap {
                biggestGap = gapCounter
                gapCounter = 0
            }
            if val == 0 {
                gapCounter += 1
            }
        }
        return biggestGap
    }
    return 0
}

// N is an integer within the range [1..2,147,483,647].
let number = 647
let biggestGap = solution(n: number)
print(biggestGap)
*/


/*
 
 A non-empty array A consisting of N integers is given. The array contains an odd number of elements, and each element of the array can be paired with another element that has the same value, except for one element that is left unpaired.
 
 For example, in array A such that:
 
 A[0] = 9  A[1] = 3  A[2] = 9
 A[3] = 3  A[4] = 9  A[5] = 7
 A[6] = 9
 the elements at indexes 0 and 2 have value 9,
 the elements at indexes 1 and 3 have value 3,
 the elements at indexes 4 and 6 have value 9,
 the element at index 5 has value 7 and is unpaired
 
 write a function that, given an array A consisting of N integers fulfilling the above conditions,
 returns the value of the unpaired element.
 
 For example, given array A such that:
 
 A[0] = 9  A[1] = 3  A[2] = 9
 A[3] = 3  A[4] = 9  A[5] = 7
 A[6] = 9
 the function should return 7, as explained in the example above.
 */

/*
var array = [9, 3, 9, 3, 9, 7, 9]
//let array = ["FOO", "FOO", "BAR", "FOOBAR"]
//let uniquesElements = Array(Set(array))
//print(uniquesElements)
//
//let occurrences = array.reduce(into: [:]) { counts, word in counts[word, default: 0] += 1 }
//print(occurrences)

public func solution(_ array : inout [Int]) -> Int {
    return array.reduce(into: [:]) { (acc, element) in
        acc[element] = acc[element]?.advanced(by: 1) ?? 1
    }.first { ($0.value % 2 == 1) }?.key ?? 0 //.first(where: { ($0.value % 2 == 0) })
}
let oddValues = solution(&array)
print(oddValues)
*/


/*
 An array A consisting of N integers is given. Rotation of the array means that each element is shifted right by one index, and the last element of the array is moved to the first place. For example, the rotation of array A = [3, 8, 9, 7, 6] is [6, 3, 8, 9, 7] (elements are shifted right by one index and 6 is moved to the first place).
 
 The goal is to rotate array A K times; that is, each element of A will be shifted to the right K times.
 For example, given
 
 A = [3, 8, 9, 7, 6]
 K = 3
 the function should return [9, 7, 6, 3, 8]. Three rotations were made:
 
 [3, 8, 9, 7, 6] -> [6, 3, 8, 9, 7]
 [6, 3, 8, 9, 7] -> [7, 6, 3, 8, 9]
 [7, 6, 3, 8, 9] -> [9, 7, 6, 3, 8]
 
 */
var array = [4, 6, 9, 20, 15, 82, 2]

public func solution(_ A : inout [Int], _ K : Int) -> [Int] {
    let numberOfElements = A.count
    var tempArray = A
    let rotateBy = K
    if K > 0 && K < 100 && K < numberOfElements {
        for index in (0..<numberOfElements).reversed() {
            let gap = numberOfElements - (numberOfElements - rotateBy)
            var rotate = index - rotateBy
            if rotate < 0 {
                rotate = index + numberOfElements - rotateBy
            }
            tempArray[index] = A[rotate]
            print(index, rotate, gap, index - gap)
        }
    }
    return tempArray
}

let result = solution(&array, 3)
print(array)
print(result)
