// The abstract factory pattern is used to provide a client with a set of related or dependant objects. The "family" of objects created by the factory are determined at run-time.
// The abstract factory pattern is very similar to the one factory method, except that it’s used to create a group of objects. The pattern cannot forecast which implementation will be used, but it helps you select the appropriate specific object.

protocol BurgerDescribing {
    var ingredients: [String] { get }
}

struct CheeseBurger: BurgerDescribing {
    let ingredients: [String]
}

protocol BurgerMaking {
    func make() -> BurgerDescribing
}


final class BigMacBurger: BurgerMaking {
    func make() -> BurgerDescribing {
        return CheeseBurger(ingredients: ["Beef", "Bacon","Cheese", "Lettuce", "Tomato", "Barbecue Sause"])
    }
}

final class BigKahunaBurger: BurgerMaking {
    func make() -> BurgerDescribing {
        return CheeseBurger(ingredients: ["Cheese", "Burger", "Lettuce", "Tomato"])
    }
}

final class JackInTheBox: BurgerMaking {
    func make() -> BurgerDescribing {
        return CheeseBurger(ingredients: ["Cheese", "Burger", "Tomato", "Onions"])
    }
}

enum BurgerFactoryType: BurgerMaking {
    
    case bigmac
    case bigKahuna
    case jackInTheBox
    
    func make() -> BurgerDescribing {
        switch self {
        case .bigmac:
            return BigMacBurger().make()
        case .bigKahuna:
            return BigKahunaBurger().make()
        case .jackInTheBox:
            return JackInTheBox().make()
        }
    }
}
