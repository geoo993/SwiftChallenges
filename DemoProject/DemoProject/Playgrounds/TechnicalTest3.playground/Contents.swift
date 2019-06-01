

/*
 A small frog wants to get to the other side of the road.
 The frog is currently located at position X and wants to get to a position greater than or equal to Y.
 The small frog always jumps a fixed distance, D.
 
 Count the minimal number of jumps that the small frog must perform to reach its target.
 
 write a function that, given three integers X, Y and D, returns the minimal number of jumps from position X to a position equal to or greater than Y.
 
 For example, given:
 
 X = 10
 Y = 85
 D = 30
 the function should return 3, because the frog will be positioned as follows:
 
 after the first jump, at position 10 + 30 = 40
 after the second jump, at position 10 + 30 + 30 = 70
 after the third jump, at position 10 + 30 + 30 + 30 = 100
 Write an efficient algorithm for the following assumptions:
 
 X, Y and D are integers within the range [1..1,000,000,000];
 X ≤ Y.
 */

public func solution(_ X : Int, _ Y : Int, _ D : Int) -> Int {
    // Slower answer
    /*
    let max = 1000000000
    var counter = X
    var steps = 0
    while counter < max && counter < Y {
        counter += D
        steps += 1
    }
    */
    
    // Faster answer
    let max = 1000000000
    let resistance = Y < max ? Y : max
    let gap = (resistance - X)
    let minimumTimes = gap / D
    let remainder = gap % D
    //let gap = (remainder + X)
    //let includingFirstPosition = gap / D
    print(minimumTimes, remainder)//, gap, includingFirstPosition)
    //let steps = minimumTimes //+ includingFirstPosition
    return remainder > 0 ? minimumTimes + 1 : minimumTimes
}


var currentPosition = 10//1
let resistance = 100//5
let interator = 30//2

let result = solution(currentPosition, resistance, interator)
print(result)
