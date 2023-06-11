import Foundation

func example(of description: String, action: () -> Void) {
  print("\n--- Example of:", description, "---")
  action()
}

// The facade pattern is a structural pattern that provides a simple interface to a complex system.
// It involves two types:

// 1) The facade provides simple methods to interact with the system. This allows consumers to use the facade instead of knowing about and interacting with multiple classes in the system.
// 2) The dependencies are objects owned by the facade. Each dependency performs a small part of a complex task.

// MARK: - When should you use it?
// - Use this pattern whenever you have a system made up of multiple components and want to provide a simple way for users to perform complex tasks.
// - For example, a product ordering system involves several components: customers and products, inventory in stock, shipping orders and others.
// - Instead of requiring the consumer to understand each of these components and how they interact, you can provide a facade to expose common tasks such as placing and fulfilling a new order.


// MARK: - Repository pattern
// A repository pattern is a representaion of the Facade pattern where repositories contain data access objects that can call out to a server, read from disk and do any other data access task.
// It essentially provides a facade for networking, persistence and in-memory caching. This facade creates, reads, updates and deletes data on disk and in the cloud. The repository doesn’t expose to consumers how it retrieves or stores the data.
// When combined with MVVM, view models use the repository facade, instead of performing these operations themselves. In turn, view models transform and expose model data to views to display on-screen.


// MARK: - Facade example
// lets implement part of the ordering system mentioned above.
// Here we define two simple models:
// - a Customer represents a user that can place an order
// - a Product sold by the system.
// We make both of these types conform to Hashable to enable us to use them as keys within a dictionary.
struct Customer: Hashable {
    let identifier: String
    var address: String
    var name: String

    func hash(into hasher: inout Hasher) {
        hasher.combine(identifier)
    }
    
    static func ==(lhs: Customer, rhs: Customer) -> Bool {
        lhs.identifier == rhs.identifier
    }
}

struct Product: Hashable {
    let identifier: String
    var name: String
    var cost: Double

    func hash(into hasher: inout Hasher) {
        hasher.combine(identifier)
    }
    
    static func ==(lhs: Product, rhs: Product) -> Bool {
        lhs.identifier == rhs.identifier
    }
}

// First, we declare InventoryDatabase. This is a simplified version of a database that stores available inventory, which represents the number of items available for a given Product.
class InventoryDatabase {
    var inventory: [Product: Int] = [:]
    
    init(inventory: [Product: Int]) {
        self.inventory = inventory
    }
}

// We also declare ShippingDatabase. This is likewise a simplified version of a database that holds onto pendingShipments, which represents products that have been ordered but not yet shipped for a given Customer.
// In a complex system, we would also likely define a CustomerDatabase, BillingDatabase and more
class ShippingDatabase {
    var pendingShipments: [Customer: [Product]] = [:]
}


//  - Facade
class OrderFacade {
    // Here, you declare OrderFacade and add two properties, inventoryDatabase and shippingDatabase
    let inventoryDatabase: InventoryDatabase
    let shippingDatabase: ShippingDatabase
    
    // We inject the default values via its initializer, init(inventoryDatabase:shippingDatabase:).
    init(inventoryDatabase: InventoryDatabase, shippingDatabase: ShippingDatabase) {
        self.inventoryDatabase = inventoryDatabase
        self.shippingDatabase = shippingDatabase
    }
    
    func placeOrder(for product: Product,  by customer: Customer) {
        // 1 - We first print the product.name and customer.name to the console.
        print("Place order for '\(product.name)' by '\(customer.name)'")
        
        // 2 - Before fulfilling the order, we guard that there’s at least one of the given product in the inventoryDatabase.inventory. If there isn’t any, we print that the product is out of stock.
        let count = inventoryDatabase.inventory[product, default: 0]
        guard count > 0 else {
            print("'\(product.name)' is out of stock!")
            return
        }
        
        // 3 - Since there’s at least one of the product available, we can fulfill the order. You thereby reduce the count of the product in inventoryDatabase.inventory by one.
        inventoryDatabase.inventory[product] = count - 1
        
        // 4 - We then add the product to the shippingDatabase.pendingShipments for the given customer.
        var shipments = shippingDatabase.pendingShipments[customer, default: []]
        shipments.append(product)
        shippingDatabase.pendingShipments[customer] = shipments
        
        // 5 - Finally, we print that the order was successfully placed.
        print("Order placed for '\(product.name)' " + "by '\(customer.name)'")
    }
}

example(of: "Facade example") {
    // 1 - First, we set up two products.
    let rayDoodle = Product(
        identifier: "product-001",
        name: "Ray's doodle",
        cost: 0.25
    )
    
    let vickiPoodle = Product(
        identifier: "product-002",
        name: "Vicki's prized poodle",
        cost: 1000
    )
    
    // 2 - Next, we create inventoryDatabase using the products.
    let inventoryDatabase = InventoryDatabase(
        inventory: [rayDoodle: 50, vickiPoodle : 1]
    )
    
    // 3 - Then, we create the orderFacade using the inventoryDatabase and a new ShippingDatabase.
    let orderFacade = OrderFacade(
        inventoryDatabase: inventoryDatabase,
        shippingDatabase: ShippingDatabase()
    )
    
    // 4 - Finally, you create a customer and call orderFacade.placeOrder(for:by:)
    let customer = Customer(
        identifier: "customer-001",
        address: "1600 Pennsylvania Ave, Washington, DC 20006",
        name: "Johnny Appleseed"
    )
    
    orderFacade.placeOrder(for: vickiPoodle, by: customer)
}

// MARK: - What should you be careful about?
// - Be careful about creating a “god” facade that knows about every class in your app.
// - It’s okay to create more than one facade for different use cases. For example, if you notice a facade has functionality that some classes use and other functionality that other classes use, consider splitting it into two or more facades.

// MARK: - Here are its key points:
// - The facade pattern provides a simple interface to a complex system. It involves two types: the facade and its dependencies.
// - The facade provides simple methods to interact with the system. Behind the scenes, it owns and interacts with its dependencies, each of which performs a small part of a complex task.
