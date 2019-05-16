//
//  DemoProjectAlgorithmTests.swift
//  DemoProjectTests
//
//  Created by GEORGE QUENTIN on 15/05/2019.
//  Copyright © 2019 GEORGE QUENTIN. All rights reserved.
//

import XCTest

@testable import DemoProject

class DemoProjectAlgorithmTests: XCTestCase {
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceOfSolution1() {
        // This is an example of a performance test case.
        var currentPosition = 10
        let interator = 30
        let resistance = 900000000
        
        func solution(_ X : Int, _ Y : Int, _ D : Int) -> Int {
            let max = 1000000000
            var counter = X
            var steps = 0
            while counter < max && counter < Y {
                counter += D
                steps += 1
            }
            return steps
        }
        
        self.measure {
            let result = solution(currentPosition, resistance, interator)
            print(result)
            // Put the code you want to measure the time of here.
        }
    }
    
    func testPerformanceOfSolution2() {
        var currentPosition = 10
        let interator = 30
        let resistance = 900000000
        
        func solution(_ X : Int, _ Y : Int, _ D : Int) -> Int {
            // Faster answer
            let max = 1000000000
            let resistance = Y < max ? Y : max
            let gap = (resistance - X)
            let minimumTimes = gap / D
            let remainder = gap % D
            return remainder > 0 ? minimumTimes + 1 : minimumTimes
        }

        self.measure {
            let result = solution(currentPosition, resistance, interator)
            print(result)
            // Put the code you want to measure the time of here.
        }
    }

}
