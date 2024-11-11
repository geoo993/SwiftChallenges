import Foundation

/*
 Encapsulation: is the mechanism to restrict access to certain data, variables or fields. 
 By restricting access to data we prevent unexpected changes.
 Swift encapsulates data through properties and use the following mechanisms to do so.
    1) Access levels: Swift provides 5 access levels that are Open, Public, Internal, File-private, Private. Open access is the highest (least restrictive) access level and private access is the lowest (most restrictive) access level.
    2) Abstraction: is an OOP concept by which we expose relevant data and methods of an object hiding their internal implementation.
    3) Namespacing: is a way to hide objects and properties in another object without necessarily requiring access level
 */

// Open access and public access — Entities with this access level can be accessed within the module that they are defined as well as outside their module.

open class ReadMe {
    private let name: String
    
    public init(name: String) {
        self.name = name
    }
    
    open func testThis() {
        
    }
}

class TestFile {
    let readme = ReadMe(name: "George")
}

class ReadAgain: ReadMe {
    
    override func testThis() {}
}


// Internal access — Entities with this access level can be accessed by any files within the same module but not outside of it. Also by defautl swift uses internal as access level
internal let name = "George"


// File-private access — Entities with this access level can only be accessed within the defining source file.

public struct MyPrivateFiles {
    public let name: String
    
    public init(name: String) {
        self.name = name
    }

    fileprivate var repeatName: String {
        name
    }
}

public struct MainsFiles {
    public let file: MyPrivateFiles
    
    public init(file: MyPrivateFiles) {
        self.file = file
    }
    
    private var getRepeatName: String {
        file.repeatName
    }
}


// Private access — Entities with this access level can be accessed only within the defining enclosure.
let value = MainsFiles(file: MyPrivateFiles(name: "ahshs"))
//print(value.getRepeatName)


// Abstraction
protocol Producting {
    var name: String { get set }
    func calculate ()
}

struct Inventory {
    
    // implementation detail is hidden
    let product: Producting
}


// Namespacing

struct ProductScreen {
    struct ViewModel {
        let value: String
        let values = [String]()
        
        func text() {
            values.forEach { _ in
                //
            }
        }
    }
}

extension ProductScreen {
    struct ViewModel2 {
        let value: String
        let values = [String]()
    }
}

// name space of view model
extension ProductScreen.ViewModel2 {
    func text2() {
        values.forEach { _ in
            
        }
    }
}
