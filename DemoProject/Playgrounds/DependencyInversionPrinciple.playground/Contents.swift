// dependency inversion is not the same as dependency injection, it simply is about specifying the best way to form dependency between different objects.

// this principle is split into two different ideas
// A. High-level modules should not depend on low level modules.
//    Both should depend on abstractions.
// B. Abstractions should not depend on details.
//    Details should depend on abstractions.


// generally when we talk about abstraction we talk about interfaces (protocols)
enum Relationship {
    case parent, child, sibling
}

struct Person {
    let name: String
}

// low-level module/construct that stores the relationship between people
struct Relationships {
    var relations: [(Person, Relationship, Person)] = []
    mutating func addParentAndChild(parent: Person, child: Person)  {
        self.relations.append((parent, .parent, child))
        self.relations.append((child, .child, parent))
    }
}

// high-level module which does some research on the relationship data
// the worst thing to do here that would break the DIP, is to actually take a direct dependency on a low-level module.
// worst even, this would make us access the details of that low-level module.
// if the low-level module then changes in the future or if certain access level changes, this would break our research class and the high-level code will be completely broken
struct Research {
    init(relationships: Relationships) {
        for (first, relation, second) in relationships.relations {
            if first.name == "John" && relation == .parent {
                print("\(second.name) is John child")
            }
        }
    }
}

// the DIP protects you from changes in the implementation details, and we achieve this voilation of high-level module depending on low-level module by using aabstractions (protocols)
protocol RelationshipsBrowser {
    func findAllChildren(name: String) -> [Person]
}

// new low-level module/construct that depends on abstraction
struct FamilyRelationships: RelationshipsBrowser {
    
    var relations: [(Person, Relationship, Person)] = []
    mutating func addParentAndChild(parent: Person, child: Person)  {
        self.relations.append((parent, .parent, child))
        self.relations.append((child, .child, parent))
    }
    func findAllChildren(name: String) -> [Person] {
        return relations
            .filter{ $0.0.name == name && $0.1 == .parent }
            .map { $0.2 }
    }
}

// high-level module that depends on abstraction and not on low-level module
struct FamilyResearch {
    init(relationships: RelationshipsBrowser) {
        for (children) in relationships.findAllChildren(name: "John") {
            print("\(children.name) is John child")
        }
    }
}


let parent = Person(name: "John")
let child1 = Person(name: "Abdul")
let child2 = Person(name: "Samuel")
let child3 = Person(name: "Tom")

var relationShips = Relationships()
relationShips.addParentAndChild(parent: parent, child: child1)
relationShips.addParentAndChild(parent: parent, child: child2)
Research(relationships: relationShips) // violation of DIP

var familyrelationShips = FamilyRelationships()
familyrelationShips.addParentAndChild(parent: parent, child: child1)
familyrelationShips.addParentAndChild(parent: parent, child: child3)
FamilyResearch(relationships: familyrelationShips) // not violating DIP, you want to have dependencies on abstarctions

// dependency injection allows you specify certain defaults, and plays on top of the dependency inversion principal by allowing you to specify or provide the any objects fits/conforms with the properties of our class/structs.
// example is FamilyResearch(relationships: familyrelationShips) familyrelationShips is being injected
