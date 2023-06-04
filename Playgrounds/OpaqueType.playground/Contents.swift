import Foundation

func example(of description: String, action: () -> Void) {
  print("\n--- Example of:", description, "---")
  action()
}


//   An opaque type refers to one specific type, although the caller of the function isn’t able to see which type;
// a protocol type can refer to any type that conforms to the protocol.
// Generally speaking, protocol types give you more flexibility about the underlying types of the values they store, and opaque types let you make stronger guarantees about those underlying types.

example(of: "Simple Opaque functions") {
    
    // consider a function that returned some Equatable like this:
    
    func makeInt() -> some Equatable {
        Int.random(in: 1...10)
    }
    
    //When we call that, all we know is that it is some sort of Equatable value, however if call it twice then we can compare the results of those two calls because Swift knows for sure it will be the same underlying type:
    
    let int1 = makeInt()
    let int2 = makeInt()
    print(int1 == int2)
    
    // The same is not true if we had a second function that returned some Equatable, like this:
    
    func makeString() -> some Equatable {
        "Red"
    }
    
    // Even though from our perspective both send us back an Equatable type, and we can compare the results of two calls to makeString() or two calls to makeInt(),
    // Swift won’t let us compare the return value of makeString() to the return value of makeInt() because it knows comparing a string and an integer doesn’t make any sense.
    
    let myString = makeString()
    // print(int1 == myString) cannot compare
}

// When developing modules, you can use opaque types to hide concrete types that you don’t want to expose to implementors.
// For example using a protocol associated type as opaque type

protocol Shape {
    func draw() -> String
}

struct Triangle: Shape {
    var size: Int
    func draw() -> String {
        """
          *
         ***
        *****
        """
    }
}

struct Square: Shape {
    var size: Int
    func draw() -> String {
        """
        ******
        *    *
        ******
        """
    }
}

struct JoinedShape<T: Shape, U: Shape>: Shape {
    var top: T
    var bottom: U
    func draw() -> String {
       return top.draw() + "\n" + bottom.draw()
    }
}

example(of: "Opaque type part 2") {
    func makeRandomShape() -> some Shape {
        let smallTriangle = Triangle(size: 3)
        let squareShape = Square(size: 4)
        return JoinedShape(top: smallTriangle, bottom: squareShape)
    }
    print(makeRandomShape().draw())
}

protocol Vehicle {
    associatedtype Value
    func model() -> Value
}

class Tesla: Vehicle {
    typealias Value = Int
    
    func model() -> Value {
        201902
    }
}

class Volvo: Vehicle {
    typealias Value = String

    func model() -> Value {
        "Volvoo"
    }
}

class Vaxaul: Vehicle {
    typealias Value = String

    func model() -> Value {
        "Vaxaul Car"
    }
}

example(of: "Opaque Type with Protocols") {
    var tesla = Tesla()
    var volvo = Volvo()
    var vaxaul = Vaxaul()
    
    var cars: [any Vehicle] = [tesla, vaxaul, volvo]
    for car in cars {
        print(car.model())
    }
    
    // opaque type
    var aution: some Vehicle = vaxaul
    print(aution.model())
}

