//
//  DependencyInjectionTests.swift
//  DemoProjectTests
//
//  Created by GEORGE QUENTIN on 11/05/2019.
//  Copyright © 2019 GEORGE QUENTIN. All rights reserved.
//

import XCTest

@testable import DemoProject

// Preferences
protocol UserDefaults {
    func stringForKey(key: String) -> String
}

class Preferences {
    let userDefaults: UserDefaults
    
    init(userDefaults: UserDefaults) {
        self.userDefaults = userDefaults
    }
    
    var username: String {
        return userDefaults.stringForKey(key: "Username")
    }
}

// Preferences logger
protocol LogOutput {
    func logMessage(message: String)
}

class PreferencesLogger {
    let preferences: Preferences
    let output: LogOutput
    
    init(preferences: Preferences, output: LogOutput) {
        self.preferences = preferences
        self.output = output
    }
    
    func log() {
        output.logMessage(message: "Username: \(preferences.username)")
    }
}

// Dummy/Mock classes
class UserDefaultsSpy: UserDefaults {
    var stringForKeyResult = ""
    private(set) var didCallStringForKey = false
    private(set) var keyPassedToStringForKey = ""
    func stringForKey(key: String) -> String {
        didCallStringForKey = true
        keyPassedToStringForKey = key
        return stringForKeyResult
    }
}

class LogOutputSpy: LogOutput {
    private(set) var loggedMessage = ""
    
    func logMessage(message: String) {
        loggedMessage = message
    }
}

// UserDefaults real implementation
class SystemUserDefaultsAdapter: UserDefaults {
    let systemUserDefaults: UserDefaults!
    
    init(systemUserDefaults: UserDefaults) {
        self.systemUserDefaults = systemUserDefaults
    }
    
    func stringForKey(key: String) -> String {
        if let string = systemUserDefaults?.stringForKey(key: key) {
            return string
        } else {
            fatalError("Could not find string for key: \(key)")
        }
    }
}

// LogOutput real implementation
class SystemConsoleOutput: LogOutput {
    func logMessage(message: String) {
        print(message)
    }
}

/*
 
 // Usage
 NSUserDefaults.standardUserDefaults().setObject("john", forKey: "Username")
 
 let userDefaults = SystemUserDefaultsAdapter(systemUserDefaults: NSUserDefaults.standardUserDefaults())
 let preferences = Preferences(userDefaults: userDefaults)
 let preferencesLogger = PreferencesLogger(preferences: preferences, output: SystemConsoleOutput())
 preferencesLogger.log()
 
 NSUserDefaults.standardUserDefaults().removeObjectForKey("Username")
 
 */

class DependencyInjectionTests: XCTestCase {
    
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
    
    func testGetsUsernameFromUserDefaults() {
        let userDefaultsSpy = UserDefaultsSpy()
        userDefaultsSpy.stringForKeyResult = "john"
        let preferences = Preferences(userDefaults: userDefaultsSpy)
        
        let username = preferences.username
        
        XCTAssertTrue(userDefaultsSpy.didCallStringForKey)
        XCTAssertEqual(userDefaultsSpy.keyPassedToStringForKey, "Username")
        XCTAssertEqual(username, "john")
    }
    
    func testLogsUsername() {
        let userDefaultsStub = UserDefaultsSpy()
        userDefaultsStub.stringForKeyResult = "john"
        let preferences = Preferences(userDefaults: userDefaultsStub)
        let logOutputSpy = LogOutputSpy()
        let preferencesLogger = PreferencesLogger(preferences: preferences, output: logOutputSpy)
        
        preferencesLogger.log()
        
        XCTAssertEqual(logOutputSpy.loggedMessage, "Username: john")
    }
}
