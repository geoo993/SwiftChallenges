import Foundation
import XCTest

// https://medium.com/@asilbekdjamaldinov/test-driven-development-tdd-in-ios-24e96ff310f8

/* WHAT IS TEST DRIVEN DEVELOPMENT (TDD)
 - Test-driven development is a well-known and commonly-used development methodology by which (failing) tests are initially created, and only then is the actual software code created, which aims to pass the newly-generated tests.
 - In essense it aim to promote testing, where you first write tests before writing any code, as expected those test should fail, so then you write code to make the tests pass, and then you refactor your code to be as simple as possible.
*/

/* PROCESS OF APPLYING TDD?
- 1) Writing tests: test-driven development encourages you to write the smallest possible test.
- 2) Confirm the Test Fails: Once the test is created, the next step is to confirm that the test fails.
- 3) Write Code to Pass Test: After confirming that the test fails, you now must write the code that will allow the test to pass
- 4) Confirm the Test Passes: Once your new code is written, confirm that the test now passes.
- 5) Refactor: even though you now have a test that passes, the process of writing the code necessary to allow said test to pass may have introduced some duplications or inconsistencies. That’s perfectly normal and expected, but the importance of the refactoring step is to take the time to locate those problem areas and to focus on simplifying the codebase.
- 6) Repeat All Steps: If everything is kept small (small use cases, small tests, small code changes, small confirmations, etc), then the entire process, from writing a failing test to confirming a passing test and refactoring, can often take only a few minutes. Thus, the process is repeated over and over
- Red-Green-Refactor is another way of referring to the basic steps outlined above.
    RED – Write a failing test
    GREEN – Write the minimum amount of code to make the test pass
    REFACTOR – Refactor both the app code and test code
 basically a red test is a failing test, while a green test is a passing test, and the overall meaning is to create a failing test, make it pass, and then refactor.
*/

/* WHAT IS SUT
 - SUT is a term used in testing to highlight the entity or object of reference that is being tested.
 - When writing our tests, we need to identify which object is being tested and what piece of code we want to test from it. SUT simply refers to this object as the “system under test”.
*/

/* What is GIVEN, WHEN, THEN?
 - TDD often refers to Given, When, Then to provide a structure to how you should write tests.
 - Following this order during test-driven development will make things so much easier when writing tests: (1) When, (2) Then, (3) Given.
 
 */



// EXAMPLE of Calculator Tests
struct Calculator {
    func addBefore(a: Int, to b: Int) -> Int {
        // write code for adding
        return 0
    }
    
    func addAfter(a: Int, to b: Int) -> Int {
        let addition = a + b
        return addition
    }
}

final class CalculatorTests: XCTestCase {

    // Failing test or Red test
    func test_add_failing() {
        // Given
        let sut = Calculator()
        
        // When you add 2 to 5
        let result = sut.addBefore(a: 2, to: 5)
        
        // Then we expect 7
        XCTAssertEqual(result, 7)
    }
    
    // Passing test or Green test
    func test_add_passing() {
        // Given
        let sut = Calculator()
        
        // When you add 2 to 5
        let result = sut.addAfter(a: 2, to: 5)
        
        // Then we expect 7
        XCTAssertEqual(result, 7)
    }
}

CalculatorTests.defaultTestSuite.run()
