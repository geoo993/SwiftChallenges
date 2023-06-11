import UIKit

// Find all repeated network requests that occur over a time period.

var requests = [
    "1 123.455.922 5000",
    "2 141.525.242 5500",
    "3 123.455.922 5300",
    "4 141.525.242 6000",
    "5 134.325.344 5300",
    "6 124.225.265 4400"
]

struct Request {
    var id: Int = 0
    var address: String = ""
    var timestamp: Int = 0
}

struct Stack<Element> {
    private var storage: [Element] = []
    
    init() { }
    
    init(_ elements: [Element]) {
        storage = elements
    }
    
    mutating func push(_ element: Element) {
        storage.append(element)
    }
    
    @discardableResult
    mutating func pop() -> Element? {
        storage.popLast()
    }
    
    func peek() -> Element? {
        storage.last
    }

    var isEmpty: Bool {
        peek() == nil
    }
}

extension Request {
    init?(model: String) {
        var stack = [Character]()
        
        var word = 1
        var idValue: Int?
        var addressValue = ""
        var timestampValue: Int?
        
        var index = 0
        while index < model.count {
            let stringInd = model.index(model.startIndex, offsetBy: index)
            let char = model[stringInd]
            if char == " " {
                let str = String(stack)
                if word == 1 {
                    idValue = Int(str)
                } else {
                    addressValue = str
                }
                stack = []
                word += 1
            } else {
                stack.append(char)
                if index >= model.count - 1 {
                    let str = String(stack)
                    timestampValue = Int(str)
                }
            }
            index += 1
        }
        guard let id = idValue, let timestamp = timestampValue else { return nil }
        self.init(id: id, address: addressValue, timestamp: timestamp)
    }
}

func getRejectedRequets(from requests: [String], timePerSeond: Int) -> [Int] {
    let values = requests.compactMap(Request.init)
    var current = [Request]()
    var rejected = [Int]()
    
    for item in values {
        for request in current.filter({ $0.address == item.address }) {
            let timediff = request.timestamp - item.timestamp
            let timeInMs = timePerSeond * 1000
            if timediff < timeInMs {
                rejected.append(item.id)
                break
            }
        }
        current.append(item)
    }
    return rejected
}

let rejected = getRejectedRequets(from: requests, timePerSeond: 1)
print(rejected)
