import UIKit

enum BurgerCooked {
    case medium
    case rare
    case welldone
}

enum Drink {
    case coke
    case fanta
    case orange
    case sprite
    case sevenup
    case water
}

enum Dessert {
    case icecream
    case cake
    case fruits
}

protocol BuilderOrderProtocol {
    func printDescription()
}

class BurgerOrderBuilder: BuilderOrderProtocol {
    private (set) var orderId: String!
    private let name: String
    init(name: String) {
        self.orderId = "#00045900"
        self.name = name
    }
    
    func printDescription() {
        print("Order \(orderId ?? "") is on its way. \(name) ")
    }
}

protocol BuilderProtocol {
    func configure()
    func setVeggie(choice: Bool)
    func setMayo(choice: Bool)
    func setCooked(choice: BurgerCooked)
    func addPatty(choice: Bool)
    func setDrink(choice: Drink)
    func setDessert(choice: Dessert)
    func buildObject(name: String) -> BurgerOrderBuilder
}

class BurgerBuilder: BuilderProtocol {
    var veggie: Bool!
    var mayo: Bool!
    var cooked: BurgerCooked!
    var patty: Bool!
    var dessert: Dessert!
    var drink: Drink!
    
    init() {
        veggie = false
        mayo = false
        cooked = .medium
        patty = false
        dessert = .fruits
        drink = .coke
    }
    
    func setVeggie(choice: Bool) {
        
    }
    
    func setMayo(choice: Bool) {
        
    }
    
    func setCooked(choice: BurgerCooked) {
        
    }
    
    func addPatty(choice: Bool) {
        
    }
    
    func setDrink(choice: Drink) {
        
    }
    
    func setDessert(choice: Dessert) {
        
    }
    
    func buildObject(name: String) -> BurgerOrderBuilder {
        return BurgerOrderBuilder(name: name)
    }
    
    func configure() {
    
    }
}

let builder = BurgerBuilder()

//1 stage
let name = "Joe"

//2 stage
builder.setVeggie(choice: false)

//3 stage
builder.setMayo(choice: false)
builder.setCooked(choice: .rare)

//4 stage
builder.addPatty(choice: true)

//5 stage
builder.setDrink(choice: .orange)

//6 stage
builder.setDessert(choice: .icecream)

let order = builder.buildObject(name: name)
order.printDescription()
