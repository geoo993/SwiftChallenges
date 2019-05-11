//
//  DemoProjectTests.swift
//  DemoProjectTests
//
//  Created by GEORGE QUENTIN on 11/05/2019.
//  Copyright © 2019 GEORGE QUENTIN. All rights reserved.
//

import XCTest

@testable import DemoProject

class DemoProjectTests: XCTestCase {
    
    var myApp = DemoApp()
    
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
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    // Test all attributes that should be present in Place model.
    func testAttributes() {
        let attributes: [String : Any] = ["name": "Cafe De Latina", "movieImageName":"Belle view", "genre":"Action", "vicinity": "Bengaluru", "rating": 4.8, "opening_hours": ["open_now": false]]
        let place = Area(attributes: attributes)
        XCTAssertEqual(place.name, "Cafe De Latina")
        XCTAssertEqual(place.address, "Bengaluru")
        XCTAssertEqual(place.rating, 4.8)
        XCTAssertEqual(place.openStatus, false)
    }
    
    func testGenerateShouldReturnNilWithNilFirstAndLastName()
    {
        
        // Given
        
        // When
        let greeting = myApp.generate(firstName: nil, lastName: nil)
        
        // Then
        XCTAssertNil(greeting, "generate(firstName:lastName:) should return nil without first and last names")
    }
    
    func testCalculateAreaOfSquare() {
        
        // Given
        let w = 2
        let h = 2
        // When
        let add = myApp.calculateAreaOfSquare(w: w, h: h)
        
        // Then
        XCTAssertEqual(add, 4, "Given w=2, h=2, Expect area to be 4. In this case, the test will fail because the implementation is not done yet.")
    }
    
    func testCalculateAreaOfSquareWithPositiveValues() {
        
        // Given
        let w = 2
        let h = 2
        // When
        let add = myApp.calculateAreaOfSquareWithPossitiveValues(w: w, h: h)
        
        // Then
        XCTAssertEqual(add, 4, "Given w=2, h=2, Expect area to be 4. In this case, the test will fail because the implementation is not done yet.")
    }
    
}
