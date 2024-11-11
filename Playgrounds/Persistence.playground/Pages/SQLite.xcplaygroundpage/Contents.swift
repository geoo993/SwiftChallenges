// https://www.kodeco.com/6620276-sqlite-with-swift-tutorial-getting-started
// https://dontpaniclabs.com/blog/post/2022/07/26/sqlite-and-swift/
// https://github.com/stephencelis/SQLite.swift
import Foundation
import SQLite3

// SQLite: -
// It is a lightweight relational database management system that can be used in iOS apps to store data.
// It's a popular choice for apps that need to store large amounts of data, such as games or productivity apps.
// If you’ve used Core Data before, you’ve already used SQLite. Core Data is just a layer on top of SQLite that provides a more convenient API.

let sqliteVersion = sqlite3_libversion()
print("sqliteVersion: \(String(describing: sqliteVersion))")
let sqliteVersionString = NSString(utf8String: sqliteVersion! )
print("sqliteVersionString: \(String(describing: sqliteVersionString))")

enum SQLiteError: Error {
    case OpenDatabase(message: String)
    case Prepare(message: String)
    case Step(message: String)
    case Bind(message: String)
}

class SQLiteDatabase {
    private let dbPointer: OpaquePointer?
    private init(dbPointer: OpaquePointer?) {
        self.dbPointer = dbPointer
    }
    
    fileprivate var errorMessage: String {
        if let errorPointer = sqlite3_errmsg(dbPointer) {
            let errorMessage = String(cString: errorPointer)
            return errorMessage
        } else {
            return "No error message provided from sqlite."
        }
    }
    
    deinit {
        sqlite3_close(dbPointer)
    }
    
    static func open(path: String) throws -> SQLiteDatabase {
        var db: OpaquePointer?
        // 1
        if sqlite3_open(path, &db) == SQLITE_OK {
            // 2
            return SQLiteDatabase(dbPointer: db)
        } else {
            // 3
            defer {
                if db != nil {
                    sqlite3_close(db)
                }
            }
            if let errorPointer = sqlite3_errmsg(db) {
                let message = String(cString: errorPointer)
                throw SQLiteError.OpenDatabase(message: message)
            } else {
                throw SQLiteError.OpenDatabase(message: "No error message provided from sqlite.")
            }
        }
    }
}

let part2DbPath: String = ""
let db: SQLiteDatabase
do {
    db = try SQLiteDatabase.open(path: part2DbPath)
    print("Successfully opened connection to database.")
} catch SQLiteError.OpenDatabase(_) {
    print("Unable to open database.")
    //    PlaygroundPage.current.finishExecution()
}
