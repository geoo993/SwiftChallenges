//: [Previous](@previous)
import Foundation

// Enum - allows you to create multiple cases of a value, similar bool that gives you 2 cases (true/false) but enum allows you to create more case of a particular type or value
enum Fruit {
    case banana
    case apple
    case strawberry
    case mango
}

let fruit: Fruit = .strawberry
let fruits: [Fruit] = [.strawberry, .banana]

for fruit in fruits {
    switch fruit {
    case .apple:
        print("apple")
    case .banana:
        print("banana")
    case .mango:
        print("mango")
    case .strawberry:
        //    print("strawberry")
        break
    }
}

let resultt = fruit == .banana ? "Booo" : "Woow"

struct UploadOptions: OptionSet {
    let rawValue: UInt

    static let waitsForConnectivity    = UploadOptions(rawValue: 1 << 0)
    static let allowCellular  = UploadOptions(rawValue: 1 << 1)
    static let multipathTCPAllowed   = UploadOptions(rawValue: 1 << 2)

    static let standard: UploadOptions = [.waitsForConnectivity, .allowCellular]
    static let all: UploadOptions = [.waitsForConnectivity, .allowCellular, .multipathTCPAllowed]
}
