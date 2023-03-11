// https://alisoftware.github.io/swift/closures/2016/07/25/closure-capture-1/
// https://www.donnywals.com/closures-in-swift-explained/

import Foundation
import Combine

final class Pokemon: CustomDebugStringConvertible {
    let name: String
    init(name: String) {
        self.name = name
    }
    var debugDescription: String { return "<Pokemon \(name)>" }
    deinit { print("\(self) escaped!") }
}

func delay(_ seconds: Int, closure: @escaping ()->()) {
    let time = DispatchTime.now() + .seconds(seconds)
    DispatchQueue.main.asyncAfter(deadline: time) {
        print("🕑")
        closure()
    }
}


// default closure semantics
func demo1() -> Future<Void, Never>  {
    Future { promise in
        let pokemon = Pokemon(name: "Mewtwo")
        print("before closure: \(pokemon)")
        delay(1) {
            print("inside closure: \(pokemon)")
            promise(.success(()))
        }
        print("bye")
    }
}


// captured variables are evaluated at the closure execution’s time
func demo2() -> Future<Void, Never> {
    Future { promise in
        var pokemon = Pokemon(name: "Pikachu")
        print("before closure: \(pokemon)")
        delay(1) {
            print("inside closure: \(pokemon)")
            promise(.success(()))
        }
        pokemon = Pokemon(name: "Mewtwo")
        print("after closure: \(pokemon)")
    }
}


// captured value types like Int
func demo3() -> Future<Void, Never> {
    Future { promise in
        var value = 42
        print("before closure: \(value)")
        delay(1) {
            print("inside closure: \(value)")
            promise(.success(()))
        }
        value = 1337
        print("after closure: \(value)")
    }
}

// you can modify captured values in closures
func demo4() -> Future<Void, Never> {
    Future { promise in
        var value = 42
        print("before closure: \(value)")
        delay(1) {
            print("inside closure 1, before change: \(value)")
            value = 1337
            print("inside closure 1, after change: \(value)")
        }
        delay(2) {
            print("inside closure 2: \(value)")
            promise(.success(()))
        }
    }
}

// Capturing a variable as a constant copy, If you want to capture the value of a variable at the point of the closure creation, instead of having it evaluate only when the closure executes, you can use a CAPTURE LIST.
func demo5() -> Future<Void, Never> {
    Future { promise in
        var value = 42
          print("before closure: \(value)")
          delay(1) { [constValue = value] in
              print("inside closure: \(constValue)")
              promise(.success(()))
          }
          value = 1337
          print("after closure: \(value)")
    }
}

// the closure is somehow capturing a copy of the original instance, hence the closure does not really strongly capture the variable reference
func demo6() -> Future<Void, Never> {
    Future { promise in
        var pokemon = Pokemon(name: "Pikachu")
        print("before closure: \(pokemon)")
        delay(1) { [pokemonCopy = pokemon] in
            print("inside closure: \(pokemonCopy)")
            promise(.success(()))
        }
        pokemon = Pokemon(name: "Mewtwo")
        print("after closure: \(pokemon)")
    }
}

// Mixing it all
func demo7() -> Future<Void, Never> {
    Future { promise in
        var pokemon = Pokemon(name: "Mew")
        print("➡️ Initial pokemon is \(pokemon)")
        
        delay(1) { [capturedPokemon = pokemon] in
            print("closure 1 — pokemon captured at creation time: \(capturedPokemon)")
            print("closure 1 — variable evaluated at execution time: \(pokemon)")
            pokemon = Pokemon(name: "Pikachu")
            print("closure 1 - pokemon has been now set to \(pokemon)")
        }
        
        pokemon = Pokemon(name: "Mewtwo")
        print("🔄 pokemon changed to \(pokemon)")
        
        delay(2) { [capturedPokemon = pokemon] in
            print("closure 2 — pokemon captured at creation time: \(capturedPokemon)")
            print("closure 2 — variable evaluated at execution time: \(pokemon)")
            pokemon = Pokemon(name: "Charizard")
            print("closure 2 - value has been now set to \(pokemon)")
            promise(.success(()))
        }
    }
}

// demos
var cancellables = Set<AnyCancellable>()

Just( { print("DEMO 1") }() )
    .flatMap(demo1)
    .handleEvents(receiveOutput: { print("\nDEMO 2") })
    .flatMap(demo2)
    .handleEvents(receiveOutput: { print("\nDEMO 3") })
    .flatMap(demo3)
    .handleEvents(receiveOutput: { print("\nDEMO 4") })
    .flatMap(demo4)
    .handleEvents(receiveOutput: { print("\nDEMO 5") })
    .flatMap(demo5)
    .handleEvents(receiveOutput: { print("\nDEMO 6") })
    .flatMap(demo6)
    .handleEvents(receiveOutput: { print("\nDEMO 7") })
    .flatMap(demo7)
    .sink { _ in }
    .store(in: &cancellables)

// Closure capture semantics can sometimes be tricky, especially with that last contrived example. Just remember these key points:
// - Swift closures capture a reference to the outer variables that you happen to use inside the closure.
// - That reference gets evaluated at the time the closure itself gets executed.
// - Being a capture of the reference to the variable (and not the variable’s value itself), you can modify the variable’s value from within the closure (if that variable is declared as var and not let, of course)
// - You can instead tell Swift to evaluate a variable at the point of the closure creation and store that value in a local constant, instead of capturing the variable itself. You do that using capture lists expressed inside brackets.
