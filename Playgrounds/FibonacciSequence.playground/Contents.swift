import Foundation

/*
 Fibonacci Sequence
 the series of numbers: 0, 1, 1, 2, 3, 5, 8, 13, 21, 34
 
 */

func fibonacci(until value: Int) {
    print(0)
    print(1)
    var first = 0
    var second = 1
    
    for _ in 0...value {
        
        let iterator = first + second
        print(iterator)
        
        first = second
        second = iterator
    }
}

fibonacci(until: 5)
