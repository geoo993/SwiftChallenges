
/*
 An array A consisting of N different integers is given. The array contains integers in the range [1..(N + 1)], which means that exactly one element is missing.
 
 Your goal is to find that missing element.
 write a function that, given an array A, returns the value of the missing element.
 
 For example, given array A such that:
 
 A[0] = 2
 A[1] = 3
 A[2] = 1
 A[3] = 5
 the function should return 4, as it is the missing element.
 
 Write an efficient algorithm for the following assumptions:
 
 N is an integer within the range [0..100,000];
 the elements of A are all distinct;
 each element of array A is an integer within the range [1..(N + 1)].
 
 */
/*
// convert to range and see the greatest range in length
var array = [10, 20, 15, 4, 14, 2, 7, 18, 1, 16, 17, 3, 6, 19, 5, 8, 11, 13]

public func solution(_ A : inout [Int]) -> Int {
    let array = A.sorted(by: { $0 < $1 })
    let min = 1
    if array.contains(min) == false {
        return min
    }
    if let nextMissing = array.first(where: { (array.firstIndex(of: $0 + 1) == nil) }) {
        return nextMissing + 1
    }
    return 0
}

let result = solution(&array)
print(array)
print(result)
*/
/*
A non-empty array A consisting of N integers is given. Array A represents numbers on a tape.

Any integer P, such that 0 < P < N, splits this tape into two non-empty parts: A[0], A[1], ..., A[P − 1] and A[P], A[P + 1], ..., A[N − 1].

The difference between the two parts is the value of: |(A[0] + A[1] + ... + A[P − 1]) − (A[P] + A[P + 1] + ... + A[N − 1])|

In other words, it is the absolute difference between the sum of the first part and the sum of the second part.

For example, consider array A such that:

A[0] = 3
A[1] = 1
A[2] = 2
A[3] = 4
A[4] = 3
We can split this tape in four places:

P = 1, difference = |3 − 10| = 7
P = 2, difference = |4 − 9| = 5
P = 3, difference = |6 − 7| = 1
P = 4, difference = |10 − 3| = 7
Write a function:

public func solution(_ A : inout [Int]) -> Int

that, given a non-empty array A of N integers, returns the minimal difference that can be achieved.

For example, given:

A[0] = 3
A[1] = 1
A[2] = 2
A[3] = 4
A[4] = 3
the function should return 1, as explained above.
*/
/*
var array = [3, 1, 2, 4, 3]//[4, 1, 5, 8, 2, 6, 7, 3]

public func solution(_ A : inout [Int]) -> Int {
    var minimumDifference = [Int]()
    for p in 1..<A.count {
        let splitIndex = p
        let max = A.count
        let min = splitIndex < max && splitIndex > 0 ? splitIndex : 0
        let firstPart = A.dropLast(max - min)
        let secondPart = A.dropFirst(min)
        let splits = [firstPart, secondPart].compactMap({
            return $0.reduce(0, +)
        })
        if splits.count == 2, let resultMax = splits.max(), let resultMin = splits.min()  {
            minimumDifference.append(resultMax - resultMin)
        }
    }
    return minimumDifference.min() ?? 0
}
let result = solution(&array)
print(result)
*/

/*
A non-empty array A consisting of N integers is given.

A permutation is a sequence containing each element from 1 to N once, and only once.

For example, array A such that:

A[0] = 4
A[1] = 1
A[2] = 3
A[3] = 2
is a permutation, but array A such that:

A[0] = 4
A[1] = 1
A[2] = 3
is not a permutation, because value 2 is missing.

The goal is to check whether array A is a permutation.

Write a function that, given an array A, returns 1 if array A is a permutation and 0 if it is not.
For example, given array A such that:

A[0] = 4
A[1] = 1
A[2] = 3
A[3] = 2
the function should return 1.

Given array A such that:

A[0] = 4
A[1] = 1
A[2] = 3
the function should return 0.

Write an efficient algorithm for the following assumptions:

N is an integer within the range [1..100,000];
each element of array A is an integer within the range [1..1,000,000,000].
*/

/*
var array = [4, 1, 2, 3]

public func solution(_ A : inout [Int]) -> Int {
    let uniqueElements = Array(Set(A))
    let sorted = uniqueElements.sorted(by: { $0 < $1 })
    var isPermutation = false
    var previous = 0
    for element in sorted {
        defer { previous = element }
        if (element - previous) > 1 {
            isPermutation = true
            break
        }
        isPermutation  = false
    }
    print(isPermutation)
    return isPermutation ? 0 : 1
}

let result = solution(&array)
print(result)
*/


/*
 A small frog wants to get to the other side of a river. The frog is initially located on one bank of the river (position 0) and wants to get to the opposite bank (position X+1). Leaves fall from a tree onto the surface of the river.
 
 You are given an array A consisting of N integers representing the falling leaves. A[K] represents the position where one leaf falls at time K, measured in seconds.
 
 The goal is to find the earliest time when the frog can jump to the other side of the river. The frog can cross only when leaves appear at every position across the river from 1 to X (that is, we want to find the earliest moment when all the positions from 1 to X are covered by leaves). You may assume that the speed of the current in the river is negligibly small, i.e. the leaves do not change their positions once they fall in the river.
 
 For example, you are given integer X = 5 and array A such that:
 
 A[0] = 1
 A[1] = 3
 A[2] = 1
 A[3] = 4
 A[4] = 2
 A[5] = 3
 A[6] = 5
 A[7] = 4
 In second 6, a leaf falls into position 5. This is the earliest time when leaves appear in every position across the river.
 
 Write a function:
 
 public func solution(_ X : Int, _ A : inout [Int]) -> Int
 
 that, given a non-empty array A consisting of N integers and integer X, returns the earliest time when the frog can jump to the other side of the river.
 
 If the frog is never able to jump to the other side of the river, the function should return −1.
 
 For example, given X = 5 and array A such that:
 
 A[0] = 1
 A[1] = 3
 A[2] = 1
 A[3] = 4
 A[4] = 2
 A[5] = 3
 A[6] = 5
 A[7] = 4
 the function should return 6, as explained above.
 
 Write an efficient algorithm for the following assumptions:
 
 N and X are integers within the range [1..100,000];
 each element of array A is an integer within the range [1..X].
 */
/*
//// BIG POINT: The frog is initially located on one bank of the river (position 0) meaning the count starts with value zero 0
//// BIG POINT: and frog wants to get to the opposite bank (position X+1) meaning getting all values to X start from 1
//// BIG POINT: leaves appear at every position across the river from 1 to X menaing 0..<X  if x = 1, then we move 1 step
//// BIG POINT: that is, we want to find the earliest moment when all the positions from 1 to X are covered by leaves)
//// if we have X = 5, we need 1,2,3,4,5  in order to cross
//// if we have X = 2, we need 1,2  in order to cross
var array = [2, 2, 2, 2, 2, 2]//[1, 2, 3, 5, 3, 1]
let position = 2//5
public func solution(_ X : Int, _ A : inout [Int]) -> Int {
    var result = -1
    //var positionsNeeded = (1...X).map{ $0 }
    var progress = [Int]()
    let min = 0
    let max = 1000000
    for (time, element) in A.enumerated() where element > min && element < max {
        /* Solution 1
        if positionsNeeded.contains(element) {
            positionsNeeded = positionsNeeded.filter({ $0 != element})
        }
        if positionsNeeded.isEmpty || positionsNeeded.count <= 0 {
            result = time
            break
        }
         */
        
        // Solution 2
        if progress.contains(element) == false && element <= X {
            progress.append(element)
        }
        if progress.count == X {
            result = time
            break
        }
    }
    return result
}
let result = solution(position, &array)
print()
print(result)
*/

/*
 You are given N counters, initially set to 0, and you have two possible operations on them:
 
 increase(X) − counter X is increased by 1,
 max counter − all counters are set to the maximum value of any counter.
 A non-empty array A of M integers is given. This array represents consecutive operations:
 
 if A[K] = X, such that 1 ≤ X ≤ N, then operation K is increase(X),
 if A[K] = N + 1 then operation K is max counter.
 For example, given integer N = 5 and array A such that:
 
 N means the length of the returned array is 5
 
 For example, given integer N = 5 and array A such that:
 
 A[0] = 3
 A[1] = 4
 A[2] = 4
 A[3] = 6
 A[4] = 1
 A[5] = 4
 A[6] = 4
 the values of the counters after each consecutive operation will be:
 
 (0, 0, 1, 0, 0)
 (0, 0, 1, 1, 0)
 (0, 0, 1, 2, 0)
 (2, 2, 2, 2, 2)
 (3, 2, 2, 2, 2)
 (3, 2, 2, 3, 2)
 (3, 2, 2, 4, 2)
 The goal is to calculate the value of every counter after all operations.
 
 */
/*
var inputs = [3, 4, 4, 6, 1, 4, 4]
let numberOfounters = 5

public func solution(_ N : Int, _ A : inout [Int]) -> [Int] {
    var counters = (0..<N).compactMap { _ in 0 }
    let maxCounter = N + 1
    let min = 0
    let max = N < 100000 ? N + 1 : 100000
    for input in A where input > min && input <= max {
        if input == maxCounter, let max = counters.max() {
            counters = (0..<N).compactMap { _ in max }
        } else if input >= 1 && input <= N {
            counters[input-1] += 1
        }
    }
    return counters
}

let result = solution(numberOfounters, &inputs)
print(result)
*/


/*
 This is a demo task.
 
 Write a function:
 
 public func solution(_ A : inout [Int]) -> Int
 
 that, given an array A of N integers, returns the smallest positive integer (greater than 0) that does not occur in A.
 
 For example, given A = [1, 3, 6, 4, 1, 2], the function should return 5.
 
 Given A = [1, 2, 3], the function should return 4.
 
 Given A = [−1, −3], the function should return 1.
 
 Write an efficient algorithm for the following assumptions:
 
 N is an integer within the range [1..100,000];
 each element of array A is an integer within the range [−1,000,000..1,000,000].
 
 */

var array = [1, 3, 2, 5] //[-100, -5, -20, -34, -65, 1]//[1, 3, 2, 5]
public func solution(_ A : inout [Int]) -> Int {
    let min = A.min() ?? -1000000
    let max = 1000000
    var result = 1
    let sorted = Array(Set(A)).sorted()
    for element in sorted where element >= min && element <= max && sorted.contains(1) {
        if !sorted.contains(element + 1) && sorted.filter({ $0 > 0 }).contains(element) {
            result = element + 1
            break
        }
    }
    if result < 1 { result = 1 }
    return result
}

let result = solution(&array)
print(result)
