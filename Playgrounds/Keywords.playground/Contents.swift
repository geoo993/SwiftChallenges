// Resources
// - https://www.geeksforgeeks.org/swift-keywords/
// - https://www.hackingwithswift.com/glossary
// - https://github.com/swiftlang/swift-syntax/blob/df88f3f5d1c5dcad57d99acfad195c2bb763a499/CodeGeneration/Sources/SyntaxSupport/KeywordSpec.swift#L104

// Every programming language has some set of reserved words that are used for some internal process or represent some predefined actions.
// Such words are known as keywords or reserve words.

// MOST COMMON TYPES OF KEY WORDS IN SWIFT

/*  Keywords used in the declaration */

// Declare an object
// - class
// - enum
// - struct
// - typealias

struct Product {
    let name: String
}

typealias Home = Product

func getProduct(product: Product) {}

let home = Home(name: "sam")
getProduct(product: home)

// Declare a property or variable
// - var
// - let

// Declare function and parameters
// - inout
// - func

// Declare a property or function
// - static

// Declare initialisers and handle de
// - init
// - deinit

class Prod {
    let name: String
    
    init(name: String) {
        self.name = name
        print("I am initialised")
    }
    
    deinit {
        print("Tell me when this is de allocated \(name)")
    }
}

var copyValue: Prod?
copyValue = Prod(name: "george")
print(copyValue?.name)

var copyValue2 = Prod(name: "1234")
copyValue = copyValue2 // Prod(name: "shirin")
print(copyValue?.name)

// Declare access level
// - fileprivate
// - private
// - internal
// - open
// - public

// Declare protocols and their values
// - protocol
// - associatedtype
protocol Me {
    associatedtype Demo
    func makeDemo() -> Demo
}

struct AddMe: Me {
    typealias Demo = String
    
    func makeDemo() -> String {
        ""
    }
}

struct DeleteMe: Me {
    typealias Demo = Int
    
    func makeDemo() -> Int {
        100
    }
}

// Declare extension - allows you to extend the functionality of an object
// - extension

// Import library or packacge
// - import


/*  Keywords used in statements */

// For condition statements which are switch statements or if statements
// - if
// - else
// - guard

// For enums conditions
// - case
// - switch
// - default
// - continue
// - fallthrough

// For error do catch blocks conditions
// - do
// - catch
// - throw

// For loops and closures
// - for
// - in
// - repeat
// - while

// Combine of different statements
// - where
// - break
// - return
let array = [1, 2, 4, 33]
let one = array.first(where: { $0 == 1 })

print("\nChecking where statement")
for value in array where value > 2 {
    print("value: \(value)")
}

let isThreshold = false
array.forEach { value in
    switch value {
    case 33 where isThreshold:
        print("33 is happening")
    case 4:
        print("4 is happening")
    default:
        print("Not 33 and 4")
    }
}

// Defer statement - a code block to indicate that this logic in the code block should happen last or when the current scope is exited.
// - defer

func doSomething() {
    defer { print("calculation complete") }
    let one = 3
    let number = 70
    
    let calculate = one * number
    print("Number result:", calculate)
}
doSomething()

/*  Keywords used in expression and type */
// Data type related
// - Any
// - false
// - true
// - nil
// - Self - its basically a data type alias of the current object
// - self
var useAny: Any? = "george"
var conditionTrue = true
var conditionFalse = false

class Hello {
    var name: String
    var names = ["george", "alex"]
    
    required init(name: String, names: [String]) {
        self.name = name
        self.names = names
    }
    
    func changeName(name: String) {
        self.name = name
    }
}

extension Hello {
    static func createHello() -> Self {
        self.init(name: "", names: [])
    }
}

// Type casting
// as
// is

let valueString = useAny as? Int
print(valueString)

let checkIfString: Bool = useAny is Int
print(checkIfString)

// Error related
// - catch
// - rethrows
// - throw
// - throws
// - try

// Classes inheritance
// - super

class Child: Hello {
    init() {
        super.init(name: "", names: [])
    }
    
    required init(name: String, names: [String]) {
        fatalError("init(name:names:) has not been implemented")
    }
}

/*  Keywords used in the specific context */

// Classes context
// - convenience
// - final
// - weak
// - unowned
// - override
// - required

// Properties context
// - didSet
// - willSet
// - dynamic
// - get
// - set
// - lazy

// Functions context
// - mutating
// - nonmutating
// - right
// - left

// Optionals context
// - none
// - some
// - optional

// Enums context
// - indirect

// Protocol context
// - Protocol

// Data Type context
// - Type
