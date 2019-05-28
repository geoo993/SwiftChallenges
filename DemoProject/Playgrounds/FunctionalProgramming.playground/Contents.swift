import UIKit

// =============== PART 1 =========
/*
 A difference of Imperative programming, functional programming takes a Declarative approach, a good example of the difference between Imperative and Declarative is writing a for loop instead of using the map function where the second one is declarative coding. Sometimes this may make some code a bit hard to read, but to help with this we can apply function composition to make code more readable.

 */

//Let’s start by creating a function type…..

typealias Filter = (CIImage) -> CIImage?

/*
 Functional programming in Swift also emphasize the use of enums in our programs so that’s what we are going to do now, we are going to have an enum with associated values that will return a filter based on each case….
 */
enum FilterType {
    case gaussianBlur(_ image: CIImage, _ radius: Double)
    case colorGenerator(_ color: CIColor)
    case compositeSourceOver(_ overlay: CIImage, image: CIImage)
    var filter: CIFilter? {
        switch self {
        case .gaussianBlur(let image, let radius):
            let parameters:  [String : Any] = [
                kCIInputRadiusKey: radius,
                kCIInputImageKey: image
            ]
            return CIFilter(name: "CIGaussianBlur", parameters: parameters)
        case .colorGenerator(let color):
            let parameters: [String: Any] = [
                kCIInputColorKey: color
            ]
            return CIFilter(name: "CIConstantColorGenerator", parameters: parameters)
        case .compositeSourceOver(let overlay, let image):
            let parameters: [String: Any] = [
                kCIInputBackgroundImageKey: image,
                kCIInputImageKey: overlay
            ]
            return CIFilter(name: "CISourceOverCompositing", parameters: parameters)
        }
    }
}

/*
 This enum not only will help us improve readability at the time of consumption but also will help us avoid handling those strings names everywhere when creating filters which can end in unexpected bugs if we misspell it by mistake.
 */

struct FilterManagerAPI {
    func blur(radius: Double) -> Filter {
        return { image in
            return FilterType.gaussianBlur(image, radius).filter?.outputImage
        }
    }
    func colorGenerator(color: UIColor) -> Filter {
        return { _ in
            let inputColor = CIColor(color: color)
            return FilterType.colorGenerator(inputColor).filter?.outputImage
        }
    }
    func colorOverlay(color: UIColor) -> Filter {
        return { image in
            guard let overlay =  self.colorGenerator(color: color)(image),
                let compositeIamge = self.compositeSourceOver(overlay: overlay)(image) else {
                    return nil
            }
            return compositeIamge
        }
    }
    func compositeSourceOver(overlay: CIImage) -> Filter {
        return { image in
            let filter = FilterType.compositeSourceOver(overlay, image: image).filter
            let cropRect = image.extent
            return filter?.outputImage?.cropped(to: cropRect)
        }
    }
    
    // function composition
    func composeFilters(filter1: @escaping Filter, filter2: @escaping Filter) -> Filter {
        return { img in
            guard let firstFilteredImage = filter1(img) else { return nil }
            return filter2(firstFilteredImage)
        }
    }
    
}

//These functions returns function types and if you wonder how you will use them lets see an example…
let myImage = UIImage()
let inputImage = CIImage(image: myImage) ?? CIImage()
let overLayColor = UIColor(red: 0.3647058904, green: 0.06666667014, blue: 0.9686274529, alpha: 0.1143877414)

let filterAPI = FilterManagerAPI()
if let blurredImage = filterAPI.blur(radius: 3.0)(inputImage),
    let outputImage = filterAPI.colorOverlay(color: overLayColor)(blurredImage) {
    // do something with the outputImage
}


//Now you can call it like…
let blurRadius = 20.0
let outputImage = filterAPI.composeFilters(filter1: filterAPI.blur(radius: blurRadius),
                                           filter2: filterAPI.colorOverlay(color: overLayColor))(inputImage)
// Do something with the outputImage




// =============== PART 2 =========

// When you first learned to code, you probably learned imperative style. How does imperative style work?
var thing = 3
//some stuff
thing = 4


// by creating and y changing the variable, you create mutable state.
func superHero() {
    print("I'm batman")
    thing = 5
}

print("original state = \(thing)")
superHero()
print("mutated state = \(thing)")

/*
 Holy mysterious change! Why is thing now 5? That change is called a side effect. The function superHero() changes a variable that it didn’t even define itself.
 */

/*
In Functional Programming languages, functions are first-class citizens. You treat functions like other objects that you can assign to variables. Because of this, functions can also accept other functions as parameters or return other functions. Functions that accept or return other functions are called higher-order functions. There are three of the most common higher-order functions in Functional Programming languages: filter, map and reduce.
 */


// Filter: In Swift, filter(_:) is a method on Collection types, such as Swift arrays. It accepts another function as a parameter. This other function accepts a single value from the array as input, checks whether that value belongs and returns a Bool. filter applies the input function to each element of the calling array and returns another array. The output array contains only the array elements whose parameter function returns true.
let fruits = ["🍎", "🍏", "🍎", "🍋", "🍏", "🍌", "🍏", "🍏", "🍍", "🍌", "🍋", "🍏"]
let greenapples = fruits.filter { $0 == "🍏"}
print(greenapples)


// Map: The Collection method map(_:) accepts a single function as a parameter. It outputs an array of the same length after applying that function to each element of the collection. The return type of the mapped function does not have to be the same type as the collection elements.

let oranges = fruits.map { _ in "🍊" }
print(oranges)


// Sort: You can also sort to sort an array whether its strings or number etc… You use the sorted(by:) method on the Collection type to perform the sorting. The Collection method sorted(by:) takes a function that compares two elements and returns a Bool as a parameter. Because the operator < is a function in fancy clothing, you can use Swift shorthand for the trailing closure { $0 < $1 }. Swift provides the left- and right-hand sides by default.

let indexes = fruits.enumerated().map({ $0.offset })
print(indexes.sorted(by: >))


// Reduce: The Collection method reduce(_:_:) takes two parameters: The first is a starting value of an arbitrary type T and the second is a function that combines a value of that same type T with an element in the collection to produce another value of type T. The input function applies to each element of the calling collection, one by one, until it reaches the end of the collection and produces a final accumulated value.

let juice = oranges.reduce("") { juice, orange in juice + "🍹"}
print("fresh 🍊 juice is served – \(juice)")


// To take it further, there are some more function theory.
enum FruitCategory: String, CustomStringConvertible {
    case pear               = "🍐"
    case orange             = "🍊"
    case banana             = "🍌"
    case redapple           = "🍎"
    case greenapple         = "🍏"
    case lemon              = "🍋"
    case mango              = "🥭"
    case tomato             = "🍅"
    case cucumber           = "🍆"
    case pineaple           = "🍍"
    
    var description: String {
        switch self {
        case .pear:         return "pear"
        case .orange:       return "orange"
        case .banana:       return "banana"
        case .redapple:     return "redapple"
        case .greenapple:   return "greenapple"
        case .lemon:        return "lemon"
        case .mango:        return "mango"
        case .tomato:       return "tomato"
        case .cucumber:     return "cucumber"
        case .pineaple:     return "pineaple"
        }
    }
}

// Partial functions allow you to encapsulate one function within another.
func filter(fruits: [[FruitCategory]], for category: FruitCategory) -> [FruitCategory] {
    return fruits.filter { $0.contains(category) }.flatMap({ $0 })
}

// Pure Functions are a primary concept in Functional Programming which lets you reason about program structure, as well as test program results, is the idea of a pure function. A function is pure if it meets two criteria: 1) The function always produces the same output when given the same input, e.g., the output only depends on its input. 2) The function creates zero side effects outside of it.

func fruitNameUnder(_ lettersCount: Int, from fruits: [FruitCategory]) -> [FruitCategory] {
    return fruits.filter { $0.description.count < lettersCount }
}

let fruitsCategory = fruits.compactMap({ FruitCategory(rawValue: $0) })
print(fruitNameUnder(6, from: fruitsCategory))


// pure functions are related to the concept of Referential Transparency. An element of a program is referentially transparent if you can replace it with its definition and always produce the same result. It makes for predictable code and allows the compiler to perform optimizations. Pure functions satisfy this condition.
func fruitNamesUnder(_ filter:(_ lettersCount: Int, _ fruits: [FruitCategory]) -> [FruitCategory]) {
    let lettersCount = 5
    let fruits: [FruitCategory] = [.redapple, .orange, .cucumber, .pear]
    let namesUnderLettersCount = filter(lettersCount, fruits)
    print("fruits less than \(lettersCount) letters in:\n\(fruits)")
    let sortedFruits = namesUnderLettersCount.map { $0.description }.sorted(by: <)
    print("sorted filter result: \(sortedFruits)")
}

// You can verify that the function fruitNameUnder(_:from:) is referentially transparent by passing its body to fruitNamesUnder(_:):
// Referential transparency comes in handy when you’re refactoring some code and you want to be sure that you’re not breaking anything. Referentially transparent code is not only easy to test, but it also lets you move code around without having to verify implementations.
fruitNamesUnder({ letters, fruits in
    return fruits.filter{ $0.description.count < letters }
})

// The final concept to discuss is recursion. Recursion occurs whenever a function calls itself as part of its function body. In functional languages, recursion replaces many of the looping constructs that you use in imperative languages. When the function’s input leads to the function calling itself, you have a recursive case. To avoid an infinite stack of function calls, recursive functions need a base case to end them.

extension FruitCategory: Comparable {
    public static func <(lhs: FruitCategory, rhs: FruitCategory) -> Bool {
        return lhs.description.count < rhs.description.count
    }
    
    public static func ==(lhs: FruitCategory, rhs: FruitCategory) -> Bool {
        return lhs.description == rhs.description
    }
}

// In this extension, you use operator overloading to create functions that allow you to compare two FruitCategory. You can also see the full function declaration for the < operator that you used earlier in sorted(by:).
extension Array where Element: Comparable {
    func quickSorted() -> [Element] {
        if self.count > 1 {
            let (pivot, remaining) = (self[0], dropFirst())
            let lhs = remaining.filter { $0 <= pivot }
            let rhs = remaining.filter { $0 > pivot }
            return lhs.quickSorted() + [pivot] + rhs.quickSorted()
        }
        return self
    }
}
// This extension allows you to sort an array as long as the elements are Comparable.

// to verify the function works
let quickSortedFruits = fruits.quickSorted()
print("\(quickSortedFruits)")
