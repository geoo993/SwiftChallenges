import UIKit

/// The Abstract Protocol and its extension defines a template method (notice it has no instance variable) that
/// contains a skeleton of some algorithm, composed of calls to (usually)
/// abstract primitive operations.
///
/// Concrete subclasses should implement these operations, but leave the
/// template method itself intact.
protocol AbstractProtocol {
    
    /// The template method defines the skeleton of an algorithm.
    func templateMethod()
    
    /// These operations already have implementations.
    func baseOperation1()
    
    func baseOperation2()
    
    func baseOperation3()
    
    /// These operations have to be implemented in subclasses.
    func requiredOperation1()
    func requiredOperation2()
    
    /// These are "hooks." Subclasses may override them, but it's not mandatory
    /// since the hooks already have default (but empty) implementation. Hooks
    /// provide additional extension points in some crucial places of the
    /// algorithm.
    func hook1()
    func hook2()
    
}

// default implementation of AbstractProtocol operations
extension AbstractProtocol {
    func templateMethod() {
        baseOperation1()
        requiredOperation1()
        baseOperation2()
        hook1()
        requiredOperation2()
        baseOperation3()
        hook2()
    }
    
    /// These operations already have implementations.
    func baseOperation1() {
        print("AbstractProtocol says: I am doing the bulk of the work\n")
    }
    
    func baseOperation2() {
        print("AbstractProtocol says: But I let subclasses override some operations\n")
    }
    
    func baseOperation3() {
        print("AbstractProtocol says: But I am doing the bulk of the work anyway\n")
    }
    
    func hook1() {}
    func hook2() {}
}

/// Concrete classes have to implement all abstract operations of the base
/// class. They can also override some operations with a default implementation.
class ConcreteClass1: AbstractProtocol {
    
    func requiredOperation1() {
        print("ConcreteClass1 says: Implemented Operation1\n")
    }
    
    func requiredOperation2() {
        print("ConcreteClass1 says: Implemented Operation2\n")
    }
    
    func hook2() {
        print("ConcreteClass1 says: Overridden Hook2\n")
    }
}

/// Usually, concrete classes override only a fraction of base class'
/// operations.
class ConcreteClass2: AbstractProtocol {
    
    func requiredOperation1() {
        print("ConcreteClass2 says: Implemented Operation1\n")
    }
    
    func requiredOperation2() {
        print("ConcreteClass2 says: Implemented Operation2\n")
    }
    
    func hook1() {
        print("ConcreteClass2 says: Overridden Hook1\n")
    }
}


/*
enum Genre {
    case fiction
    case nonfiction
    case phylosophy
    case biology
    case novel
    case romance
    case crime
    case horror
    case mystery
}
enum Stars {
    case five
    case four
    case three
    case two
    case one
}

protocol Book {
    var title: String { set get }
    var authors: String { set get }
    var coverImage: String { set get }
    var publisher: String { set get }
    var releaseDate: Date { get }
    var language: String { get }
    var pages: Int { get }
    var stars: Stars { get }
    var genre: Genre { get }
    func printSummary()
}
*/
