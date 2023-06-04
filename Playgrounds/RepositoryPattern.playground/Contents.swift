import Foundation

/*
 
 The Repository design pattern is a widely used pattern in software development that helps to separate the business logic from the persistence layer. In Swift, this pattern can be implemented using protocols, structs, and classes.

 A repository is an object that encapsulates the logic required to access a data source, such as a database or web service. By using a repository, the business logic can work with an abstraction of the data source, rather than directly interacting with the data source itself. This allows for better separation of concerns and easier maintenance of the codebase.

 In a Swift implementation of the Repository pattern, you would typically create a protocol that defines the interface for a repository. The protocol would define methods for adding, updating, and deleting data, as well as methods for querying the data.

 Next, you would create a concrete implementation of the repository protocol. This implementation would typically use a persistence layer, such as Core Data or SQLite, to store and retrieve data.
 */

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
