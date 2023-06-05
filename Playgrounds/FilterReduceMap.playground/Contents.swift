import Foundation

//filter always takes a closure i.e {}, its argumenet is based on the element of the sequence (i.e. string, int). the filter takes the element of the sequence and retuns a bool based on the argument of the filter
//map mainly transforms elements
//flatmap does the tranformation of observables sequences
// DoOn, DoOnNext and SubscribeNext are side effect function, were to want to pass on instructions

//https://medium.com/@mimicatcodes/simple-higher-order-functions-in-swift-3-0-map-filter-reduce-and-flatmap-984fa00b2532
//http://sketchytech.blogspot.co.uk/2015/06/swift-what-do-map-and-flatmap-really-do.html
//https://useyourloaf.com/blog/swift-guide-to-map-filter-reduce/

let a = [1, 2, 3, 4, 5, 6, 7, 8, 9]

var b : [Int] = []

for x in a {
    b.append(x * 2)
}

let const = 12

func timesTwo(_ x:Int ) -> Int{
    let y = 23
    return x * const
}

timesTwo(149)

a
let c = a
    .map { x in x * 2 }
    .map { x in "Number \(x)" }
    .map { str in str + " George" }
let d = a
    .map { x in "\(x)" }
    .map { str in Double(str)! }
    .filter { x in x <= 3 }
    .reduce(0.0) { (acc, x) in return acc + x }


let arr = [1.0,2,3,4,5,13,70,49,38]

let nOdds = arr.reduce(0) { acc, x in
    
    if (Int(x) % 2) != 0 {
        return acc + 1
    } else {
        return acc
    }
    
}


// Tasks for George.
// 1. Implement min with reduce

let arr2 = [4.0, 3, 78, -1000] // result = -2

let minn = arr2.reduce(Double.infinity) { acc, x in
    if acc < x {
        return acc
    } else {
        return x
    }
}

// 2. implment string concatenation with reduce

let arr3 = ["Hello", "George"] // result = "Hello George"

let string = arr3.reduce("") { acc, x in
    if acc == "" { return x }
    else         { return acc + " " + x }
}


////FILTER
let digits = [1,4,10,15,32, 45, 99, 66, 23,33]
let evenDigits = digits.filter { $0 % 2 == 0 }
evenDigits// [4, 10,32,66]

let dic1 = ["bear","cat","dog","fish"]
let dic2 = ["horse","cat","dog","bird"]
let f = dic1.filter{dic2.contains($0)}

//        let random = [1,5,-3,5,7,2,10]
//        let drops =
//            zip(random, random.dropFirst()).enumerated().filter { $1.1 < $1.0 }.map { $0.offset }
//        print(drops)


//REDUCE
let summing = a.reduce ( 0, {$0 + $1} )
summing//45

let summingeasy = a.reduce ( 0, + )
summingeasy//45

let attachThese = ["hello", "motto", "mobile"].reduce ( "", {$0 + " " + $1}  )
attachThese//45

let numbitems = [2.0,4.0,5.0,7.0]
let totalitems = numbitems.reduce(_:0,_: +)
let totalitems2 = numbitems.reduce(0.0) { (acc, x) in return acc + x }
totalitems// 28.0

let codes = ["abc","def","ghi"]
let textres = codes.reduce(_:"", _: +)
textres// "abcdefghi"

let namesinnames = ["alan","brian","charlie"]
let csv = namesinnames.reduce("===") {text, name in "\(text),\(name)"}
csv// "===,alan,brian,charlie"

////MAP
let dvalues = [2.0,4.0,5.0,7.0]
var squares1: [Double] = []
for value in dvalues {
    squares1.append(value*value)
}

let squares2 = dvalues.map {$0 * $0}
squares2// [4.0, 16.0, 25.0, 49.0]
let squares3 = dvalues.map {value in value * value}
let squares4 = dvalues.map({
    (value: Double) -> Int in
    return Int(value) * Int(value)
})
squares4// [4.0, 16.0, 25.0, 49.0]
let words = squares4
    .map { num in NumberFormatter.localizedString(from: NSNumber(value: num), number: NumberFormatter.Style.spellOut) }
words// ["zero", "twenty-eight", "one hundred twenty-four"]

let milesToPoint = ["point1":120.0,"point2":50.0,"point3":70.0]
let kmToPoint = milesToPoint.map { name,miles in miles * 1.6093 }
kmToPoint

let lengthInMeters: Set = [4.0,6.2,8.9]
let lengthInFeet = lengthInMeters.map {meters in meters * 3.2808}
lengthInFeet


let mapArr1 = a.map{ $0 * 2 }
mapArr1 // [2, 4, 6, 8, 10, 12]

let mapArr2 = a.map{ Double($0) * 2.5 }
mapArr2 // [2.5, 5, 7.5, 10, 12.5, 15]

let mapArr3 = a.map{$0 > 4}
mapArr3 // [false, false, true, true, true, true]

let mapArr4 = a.map{ ($0 % 2) == 0 }
mapArr4// [false, true, false, true, false, true]

let mapArr5 = a.map{ $0 > 2 ? $0 as Int? : nil}
mapArr5 // [nil, nil, {Some 3}, {Some 4}, {Some 5}, {Some 6}]



//FLATMAPS
let arrayy = [[1,2,3],[4,5,6]]
let flatMapArr1 = arrayy.flatMap{ $0 }
flatMapArr1 // [1, 2, 3, 4, 5, 6]

let flatMapArr2 = arrayy.flatMap{$0.map{$0 * 2}}
flatMapArr2 // [2, 4, 6, 8, 10, 12]

let arrayyy = [[[1],[2,3]],[[4,5],[6]]]
let flatMapArr3 = arrayyy.flatMap{ $0 }
flatMapArr3 // [[1], [2, 3], [4, 5], [6]]

let arraystr = [["one"],["three","four"]]
let mapArr6 = arraystr.compactMap{ ($0).count }
mapArr6 // 2

let dict1 = [["one":1],["three":3,"four":4]]
let mapDict1 = dict1.flatMap{ $0 }
mapDict1 // ["one": 1, "three": 3, "four": 4]

let peoplenames: [String?] = ["Tom",nil,"Peter",nil,"Harry"]
let validnames = peoplenames.compactMap {$0}
validnames// ["Tom", "Peter", "Harry"]

func randomNumber(_ MIN: Int, _ MAX: Int)-> Int{
    return Int(arc4random_uniform(UInt32(MAX)) + UInt32(MIN));
}

let array = (0 ..< 1000).map { _ -> Array<Double> in
    let r = Double(randomNumber(0,100))
    if r > 90.0 { return [r] }
    else { return [r,r] }
}

array.count
let array2 = array.flatMap { $0 }
array2.count




let doubleArray = [[30..<40].flatMap{ $0 },[20..<30].flatMap{ $0 },[0..<10].flatMap{ $0 }, [10..<20].flatMap{ $0 }]
doubleArray.compactMap{print($0)}
let flattenArray = doubleArray.flatMap{ $0 }
print(flattenArray)
print()

let nilAndIntArray = [nil, 29, 12, 6, nil, 2, 30, nil, nil, 15]
nilAndIntArray.compactMap{ print($0) }
let removeNil = nilAndIntArray.compactMap{ $0 }
print(removeNil)



//CHAINING
let totalmarks = [4,5,8,2,9,7,11]
let totalPass = totalmarks.filter{$0 >= 7}.reduce(_:0,_: +)
totalPass// 35

let numbersss = [20,17,35,4,12]
let evenSquares = numbersss.map{$0 * $0}.filter{$0 % 2 == 0}
evenSquares// [400, 16, 144]


/*
=map returns an Array containing results of applying a transform to each item.
=filter returns an Array containing only those items that match an include condition.
=reduce returns a single value calculated by calling a combine closure for each item with an initial value.
 */
