// https://medium.com/swift2go/mastering-generics-with-protocols-the-specification-pattern-5e2e303af4ca

enum Color {
    case red, green, blue, black
}

enum Size {
    case small, medium, large
}

protocol Sized {
    var size: Size { get set }
}

protocol Colored {
    var color: Color { get set }
}

struct Product {
    var name: String
    var color: Color
    var size: Size
}

extension Product : CustomStringConvertible, Colored, Sized  {
    var description: String {
        return "\(size) \(color) \(name)"
    }
}

// PART-1
// filter on a particular criteria
struct ProductFilter {
    //filter by color
    func byColor(products: [Product], color: Color) -> [Product] {
        return products.filter { $0.color == color }
    }
    
    // The problem is we voilated the OCP, by coming back to this file and adding filter bySize
    
    //filter by size
    func bySize(products: [Product], size: Size) -> [Product] {
        return products.filter { $0.size == size }
    }
    
    // somewhere down the line someone is also going to want to filter  byColorAndSize which will continue to voilate the OCP and create a rigid and fragile design.
    // this becomes a problematic problem in the future as this class grows.
    
    //filter by color and size
    func byColorSize(products: [Product], color: Color, size: Size) -> [Product] {
        return products.filter { $0.color == color && $0.size == size }
    }
    
}

/// PART-2
// Open Closed principle states that your system should opened to extension, by inheritance or extension for example, and closed for modification
// we can build a better product filter by following a better pattren that would allow us to meet OCP requirements
protocol Specification {
    associatedtype T
    func isSatisfied(item: T) -> Bool
}

// this is the interface that needs to be implemented by whoever wants to build a filter.
protocol Filter {
    associatedtype T
    //func filter(items: [T], spec: Specification) -> [T]
    func filter<S: Specification>(items: [T], spec: S) -> [T] where S.T == T
}

struct BetterFilter: Filter {
    typealias T = Product
    func filter<S: Specification>(items: [Product], spec: S) -> [Product]
        where BetterFilter.T == S.T  {
        return items.filter{ spec.isSatisfied(item: $0) }
    }
}

//if we want a color specification you would define it like this
struct ColorSpecification: Specification, Colored {
    typealias T = Product
    var color: Color
    func isSatisfied(item: Product) -> Bool {
        return item.color == self.color
    }
}
//if we want a size specification you would define it like this
struct SizeSpecification: Specification, Sized {
    typealias T = Product
    var size: Size
    func isSatisfied(item: Product) -> Bool {
        return item.size == self.size
    }
}

// specification combinator
struct AndSpecification<T, SpecA: Specification, SpecB: Specification>: Specification where SpecA.T == T, SpecB.T == T {
    typealias S = T
    var first: SpecA
    var second: SpecB
    init(first: SpecA, second: SpecB) {
        self.first = first
        self.second = second
    }
    func isSatisfied(item: S) -> Bool {
        return first.isSatisfied(item: item) && second.isSatisfied(item: item)
    }
}

let ferrari = Product(name: "Ferrari", color: .red, size: .medium)
let apple = Product(name: "Apple", color: .green, size: .small)
let tree = Product(name: "Tree", color: .green, size: .large)
let house = Product(name: "House", color: .blue, size: .large)
let phone = Product(name: "Phone", color: .black, size: .small)

let products = [ferrari, apple, tree, house, phone]

// old way of filtering through products, which voilated the OCP
//let productFilter = ProductFilter()
//let greenThings = productFilter.byColor(products: products, color: .green)
//for item in greenThings {
//    print("\(item.name) is green")
//}

// better way of filtering through products, which does not voilates OCP
let betterFilter = BetterFilter()
let greenSpecification = ColorSpecification(color: .green)
for item in betterFilter.filter(items: products, spec: greenSpecification) {
    print("\(item.name) is green")
}

let large = SizeSpecification(size: .large)

// our specification combinator allows for greater flexibility and reusability
// the goal of OCP is to avoid having to jump into code that you have already written and the solution is to create new specification by extending our interfaces by creating combinators and more reusable specifications
let greenAndLarge = AndSpecification<Product, ColorSpecification, SizeSpecification>(first: greenSpecification, second: large)
for item in betterFilter.filter(items: products, spec: greenAndLarge) {
    print("\(item.name) is green and large")
}
