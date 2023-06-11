import Foundation

/*
 Repository pattern is a software design pattern that provides an abstraction of data, so that your application can work with a simple abstraction that has an interface. Using this pattern can help achieve loose coupling and can keep domain objects persistence ignorant.
 
 The Repository design pattern is a widely used pattern in software development that helps to separate the business logic from the persistence layer. to its basic terms, it provides an abstraction of data sources and acts as a mediator between the data access layer and your app business logic.
 In Swift, this pattern can be implemented using protocols, structs, and classes.

 A repository is an object that encapsulates the logic required to access a data source, such as a database or web service. By using a repository, the business logic can work with an abstraction of the data source, rather than directly interacting with the data source itself.
 
 Its primary goal, is to create separation of concerns between the data access and business logic layer, in addition it allow for easier maintenance of the codebase.

 In a Swift implementation of the Repository pattern, you would typically create a protocol that defines the interface for a repository. The protocol would define methods for adding, updating, and deleting data, as well as methods for querying the data.

 When compared with other patterns, the repository pattern is essentially a representaion of the Facade patter by providing a facade like struture for networking, persistence and in-memory caching. A described above, this facade creates, reads, updates and deletes data on disk and in the cloud. The repository doesn’t expose to consumers how it retrieves or stores the data but rather provides a protocol inteface.
 
 When combined with MVVM, view models use the repository facade, instead of performing these operations themselves. In turn, view models transform and expose model data to views to display on-screen.
 
 We will create a concrete implementation of the repository protocol.
 
 */


// MARK: - Repository structure
// The repository provides a set of asynchronous CRUD methods.
// The underlying implementations can be either stateless or stateful.
// Stateless implementations don’t keep data around after retrieving it, whereas stateful implementations save data for later.
// The components are usually stateful and keep data in-memory for quick access.

// Under the hood, the repository has multiple layers of data access. Each implementation of a repository may implement all or only one of these layers:
// 1) - The "cloud-remote-API" layer makes calls to a server to read and update data. This may make REST calls, get data from a socket connection or another means. The data at this layer always comes from outside of the app.
// 2) - The "persistent-store" layer puts data in a local database. The database can be Core Data, Realm or a Plist file on disk. The data at this layer always comes from the app. The data gets persisted after the app closes.
// 3) The "in-memory-cache" layer stores data in objects that stay around for the lifetime of the repository. The cache doesn’t persist between app sessions. The in-memory cache is useful for showing pre-fetched data before making a network call to the cloud.
                                                   

// MARK: - repository example
// Using a protocol, the repository pattern also makes code more testable as it allows us to inject as a dependency a mock repository that implements that defined interface.
protocol Repository {
    associatedtype T
    func getAll() -> [T]
    func getById(_ id: Int) -> T?
    func add(_ item: T)
    func update(_ item: T)
    func delete(_ item: T)
}

struct Item {
    var id: Int
    var name: String
}

class ItemRepository: Repository {
    typealias T = Item
    
    var items: [Item] = []
    
    func getAll() -> [Item] {
        return items
    }
    
    func getById(_ id: Int) -> Item? {
        return items.first(where: { $0.id == id })
    }
    
    func add(_ item: Item) {
        items.append(item)
    }
    
    func update(_ item: Item) {
        if let index = items.firstIndex(where: { $0.id == item.id }) {
            items[index] = item
        }
    }
    
    func delete(_ item: Item) {
        items.removeAll(where: { $0.id == item.id })
    }
}

let repository = ItemRepository()
repository.add(Item(id: 28, name: "Samson"))
repository.add(Item(id: 58, name: "Abdd"))
print("First 2 items")
repository.getAll().forEach { print("-Item \($0.id) with name \($0.name)") }
repository.update(Item(id: 58, name: "Banana"))
repository.add(Item(id: 8, name: "Banana"))
repository.add(Item(id: 3, name: "Pear"))
print("\nAn item got updated and another added")
repository.getAll().forEach { print("-Item \($0.id) with name \($0.name)") }
repository.delete(Item(id: 28, name: "Pear"))
print("\nAn item got deleted")
repository.getAll().forEach { print("-Item \($0.id) with name \($0.name)") }
