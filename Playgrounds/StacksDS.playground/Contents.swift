import Foundation

func example(of description: String, action: () -> Void) {
  print("\n--- Example of:", description, "---")
  action()
}

// Stacks are everywhere. Here are some common examples of things you would stack:
// - pancakes
// - books
// - paper
// - cash
// The stack data structure is identical, in concept, to a physical stack of objects. When you add an item to a stack, you place it on top of the stack. When you remove an item from a stack, you always remove the top-most item.

// Stacks are useful, and also exceedingly simple. The main goal of building a stack is to enforce how you access your data. If you had a tough time with the linked list concepts, you’ll be glad to know that stacks are comparatively trivial.
// There are only two essential operations for a stack:
// - push: Adding an element to the top of the stack.
// - pop: Removing the top element of the stack.
// This means that you can only add or remove elements from one side of the data structure. In computer science, a stack is known as a LIFO (last-in first-out) data structure. Elements that are pushed in last are the first ones to be popped out.

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

extension Stack: ExpressibleByArrayLiteral {
    public init(arrayLiteral elements: Element...) {
        storage = elements
    }
}

extension Stack: CustomStringConvertible {
    public var description: String {
    """
    ----top----
    \(storage.map { "\($0)" }.reversed().joined(separator: "\n"))
    -----------
    """
    }
}

example(of: "using a stack") {
  var stack = Stack<Int>()
  stack.push(1)
  stack.push(2)
  stack.push(3)
  stack.push(4)

  print(stack)
  
  if let poppedElement = stack.pop() {
    assert(4 == poppedElement)
    print("Popped: \(poppedElement)")
  }
}

example(of: "initializing a stack from an array") {
  let array = ["A", "B", "C", "D"]
  var stack = Stack(array)
  print(stack)
  stack.pop()
}

example(of: "initializing a stack from an array literal") {
  var stack: Stack = [1.0, 2.0, 3.0, 4.0]
  print(stack)
  stack.pop()
}


// Stacks are crucial to problems that search trees and graphs. Imagine finding your way through a maze. Each time you come to a decision point of left, right or straight, you can push all possible decisions onto your stack. When you hit a dead end, simply backtrack by popping from the stack and continuing until you escape or hit another dead end.

// Key points
// - A stack is a LIFO, last-in first-out, data structure.
// - Despite being so simple, the stack is a key data structure for many problems.
// - The only two essential operations for the stack are the push method for adding elements and the pop method for removing elements.

// ======= Print in reverse
// One of the prime use cases for stacks is to facilitate backtracking. If you push a sequence of values into the stack, sequentially popping the stack will give you the values in reverse order.

func printInReverse<T>(_ array: [T]) {
    var stack = Stack<T>()
    for value in array {
        stack.push(value)
    }
    while let value = stack.pop() {
        print(value)
    }
}

// The time complexity of pushing the nodes into the stack is O(n). The time complexity of popping the stack to print the values is also O(n). Overall, the time complexity of this algorithm is O(n).
// Since you’re allocating a container (the stack) inside the function, you also incur a O(n) space complexity cost.

printInReverse(["Sam", "Tom", "Mum"])

// ======= Balance the parentheses
func checkParentheses(_ string: String) -> Bool {
    var stack = Stack<Character>()
    
    for character in string {
        if character == "(" {
            stack.push(character)
        } else if character == ")" {
            if stack.isEmpty {
                return false
            } else {
                stack.pop()
            }
        }
    }
    return stack.isEmpty
}

// The time complexity of this algorithm is O(n), where n is the number of characters in the string. This algorithm also incurs an O(n) space complexity cost due to the usage of the Stack data structure.

checkParentheses("h((e))llo(world)()") // balanced parentheses
checkParentheses("(hello world") // unbalanced parentheses
