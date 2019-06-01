/*
 
 The  Visitor design pattern is used to separate a relatively complex set of structured data classes from the functionality that may be performed upon the data that they hold. It essentially separates the algorithms from the objects on which they operate i.e. the operational logic is moved from each elements of a group into a new class. The new class will perform the operational logic using the data from those elements.
 Each element accepts a visitor which does the logic in another class. So the structure of the visited class is not changed at all. Each visitable class should be able to accept a visitor. So we declare a protocol named Visitable which has a method to accept a Visitor, then we can define concrete classes of visitable objects.
 */

protocol Visitable {
    func accept(visitor: Visitor)
}

/*
 The Visitor Pattern allows you to separate two concerns:
 - Iterating over an object tree.
 - Performing some operation on each element of that tree.
 In order to implement it, we’ll need a new protocol that our visitors will implement:
 
 This is the reason why we use the Visitor protocol because in order to meet these requirements of the Visitor pattern, we’ll need to have this Visitor protocol and the Visitable objects/classes that conform to the Visitable protocol will have access to this Visitor to implement their our visitor method from the visitor protocol.

 */
protocol Visitor {
    func visit(country: India)
    func visit(country: Brazil)
    func visit(country: China)
    func visit(country: Nigeria)
    func visit(country: Canada)
}

class India: Visitable {
    func accept(visitor: Visitor) {
        visitor.visit(country: self)
    }
}

class Brazil: Visitable {
    func accept(visitor: Visitor) {
        visitor.visit(country: self)
    }
}

class China: Visitable {
    func accept(visitor: Visitor) {
        visitor.visit(country: self)
    }
}

class Nigeria: Visitable {
    func accept(visitor: Visitor) {
        visitor.visit(country: self)
    }
}

class Canada: Visitable {
    func accept(visitor: Visitor) {
        visitor.visit(country: self)
    }
}


// As you can see, we have split the responsibilities of iterating over the countries objects and actually done something with them.
class VisitableCountries: Visitor {
    func visit(country: India) {
        print("Pavel discovered India for the first time")
    }
    func visit(country: Brazil) {
        print("Ramesh attended the world cup in Brazil")
    }
    func visit(country: China) {
        print("Nathan was impressed by the work done in Shenzen")
    }
    func visit(country: Nigeria) {
        print("Max went to Nigeria for the first time")
    }
    func visit(country: Canada) {
        print("Antonio visited Canada")
    }
}

let india = India()
let brazil = Brazil()
let china = China()
let nigeria = Nigeria()
let canada = Canada()

let travelLog = VisitableCountries()
india.accept(visitor: travelLog)
canada.accept(visitor: travelLog)
