import Foundation

func example(of description: String, action: () -> Void) {
  print("\n--- Example of:", description, "---")
  action()
}


// The chain-of-responsibility pattern is a behavioral design pattern that allows an event to be processed by one of many handlers.
// It involves three types:

// - The client accepts and passes events to an instance of a handler protocol. Events may be simple, property-only structs or complex objects, such as intricate user actions.
// - The handler protocol defines required properties and methods that concrete handlers must implement. This may be substituted for an abstract, base class instead allowing for stored properties on it. Even then, it’s still not meant to be instantiated directly. Rather, it only defines requirements that concrete handlers must fulfill.
// - The first concrete handler implements the handler protocol, and it’s stored directly by the client. Upon receiving an event, it first attempts to handle it. If it’s not able to do so, it passes the event on to its next handler.

// Thereby, the client can treat all of the concrete handlers as if they were a single instance. Under the hood, each concrete handler determines whether or not to handle an event passed to it or pass it on to the next handler. This happens without the client needing to know anything about the process!

// MARK: - When should you use it?
// Use this pattern whenever you have a group of related objects that handle similar events but vary based on event type, attributes or anything else related to the event.
// Concrete handlers may be different classes entirely or they may be the same class type but different instances and configurations.
// For example, you can use this pattern to implement a VendingMachine that accepts coins:
// - The VendingMachine itself would be the client and would accept coin input events.
// - The handler protocol would require a handleCoinValidation(_:) method and a next property.
// - The concrete handlers would be coin validators. They would determine whether an unknown coin was valid based on certain criteria, such as a coin’s weight and diameter, and use this to create a known coin type, such as a Penny.

// MARK: - Chain of Resposibility example
// Lets implement the VendingMachine

// - Define coin Model
// 1 - We first create a new class for Coin, which we’ll use as the superclass for all coin types.
class Coin {
    
    // 2 - We then declare standardDiameter and standardWeight as class properties.
    // we’ll override these within each specific coin subclass, and use them later when we create the coin validators.
    class var standardDiameter: Double {
        return 0
    }
    class var standardWeight: Double {
        return 0
    }
    
    // 3 - We declare centValue and dollarValue as computed properties. We’ll override centValue to return the correct value for each specific coin. Since there’s always 100 cents to a dollar, we make dollarValue a final property.
    var centValue: Int { return 0 }
    final var dollarValue: Double {
        return Double(centValue) / 100
    }
    
    // 4 - We create diameter and weight as stored properties. As coins age, they get dinged and worn down. Consequently, their diameters and weights tend to decrease slightly over time. We’ll compare a coin’s diameter and weight against the standards later when we create the coin validators.
    final let diameter: Double
    final let weight: Double
    
    // 5 - We create a designated initializer that accepts a specific coin’s diameter and weight. It’s important that this is a required initializer: We’ll use this to create subclasses by calling it on a Coin.Type instance - i.e. a type of Coin.
    required init(diameter: Double, weight: Double) {
        self.diameter = diameter
        self.weight = weight
    }
    
    // 6 - lastly, we create a convenience initializer. This creates a standard coin using type(of: self) to get the standardDiameter and standardWeight. This way, we won’t have to override this initializer for each specific coin subclass.
    convenience init() {
        let diameter = type(of: self).standardDiameter
        let weight = type(of: self).standardWeight
        self.init(diameter: diameter, weight: weight)
    }
}

// To inspect coins, we’ll print them to the console. We make Coin conform to CustomStringConvertible to give it a nice description that includes the coin’s type, diameter, dollarValue and weight.
extension Coin: CustomStringConvertible {
    var description: String {
        return String(
            format: "%@ {diameter: %0.3f, dollarValue: $%0.2f, weight: %0.3f}",
            "\(type(of: self))",
            diameter,
            dollarValue,
            weight
        )
    }
}

// - Add coins
// We create subclasses of Coin for Penny, FiftyPence, TwentyPence and Pound using the coin specifications provided earlier.
class Penny: Coin {
    override class var standardDiameter: Double {
        return 17.05
    }
    override class var standardWeight: Double {
        return 2.5
    }
    override var centValue: Int { return 1 }
}

class FiftyPence: Coin {
    
    override class var standardDiameter: Double {
        return 34.51
    }
    override class var standardWeight: Double {
        return 9.0
    }
    override  var centValue: Int { return 20 }
}

class Pound: Coin {
    override class var standardDiameter: Double {
        return 18.91
    }
    override class var standardWeight: Double {
        return 7.268
    }
    override  var centValue: Int { return 50 }
}

class TwentyPence: Coin {
    
    override class var standardDiameter: Double {
        return 18.26
    }
    override class var standardWeight: Double {
        return 3.670
    }
    override  var centValue: Int { return 100 }
}

// - HandlerProtocol

protocol CoinHandlerProtocol {
    var next: CoinHandlerProtocol? { get }
    func handleCoinValidation(_ unknownCoin: Coin) -> Coin?
}

// - Concrete Handler
// 1 - We declare CoinHandler, which will be the concrete handler.
class CoinHandler {
    
    // 2 - We declare several properties:
    var next: CoinHandlerProtocol? // next will hold onto the next CoinHandler.
    let coinType: Coin.Type // coinType will be the specific Coin this instance will create.
    
    // diameterRange and weightRange will be the valid range for this specific coin.
    let diameterRange: ClosedRange<Double>
    let weightRange: ClosedRange<Double>
    
    // 3 -  we create the initialiser and set self.coinType to coinType, and you use standardDiameter and standardWeight to create self.diameterRange and self.weightRange.
    init(coinType: Coin.Type, diameterVariation: Double = 0.05, weightVariation: Double = 0.05) {
        self.coinType = coinType
        let standardDiameter = coinType.standardDiameter
        self.diameterRange = (1-diameterVariation) * standardDiameter ... (1+diameterVariation) * standardDiameter
        
        let standardWeight = coinType.standardWeight
        self.weightRange = (1-weightVariation) * standardWeight ... (1+weightVariation) * standardWeight
    }
}

extension CoinHandler: CoinHandlerProtocol {
    
    // 1 - Within handleCoinValidation(_:), we first attempt to create a Coin via createCoin(from:) that is defined after this method. If we can’t create a Coin, we give the next handler a chance to attempt to create one.
    func handleCoinValidation(_ unknownCoin: Coin) -> Coin? {
        guard let coin = createCoin(from: unknownCoin) else {
            return next?.handleCoinValidation(unknownCoin)
        }
        return coin
    }

    // 2 - Within createCoin(from:), we validate that the passed-in unknownCoin actually meets the requirements to create the specific coin given by coinType
    private func createCoin(from unknownCoin: Coin) -> Coin? {
        // the unknownCoin must have a diameter that falls within the diameterRange and weightRange.
        // if it doesn’t, you print an error message and return nil.
        print("Attempt to create \(coinType)")
        guard diameterRange.contains(unknownCoin.diameter) else {
            print("Invalid diameter")
            return nil
        }
        guard weightRange.contains(unknownCoin.weight) else {
            print("Invalid weight")
            return nil
        }
        let coin = coinType.init(diameter: unknownCoin.diameter,
                                 weight: unknownCoin.weight)
        print("Created \(coin)")
        return coin
    }
}

// - Client
// 1 - We create a new class for VendingMachine, which will act as the client.
final class VendingMachine {
    
    // 2 - This has just two properties: coinHandler and coins. VendingMachine doesn’t need to know that its coinHandler is actually a chain of handlers, but instead it simply treats this as a single object. You’ll use coins to hold onto all of the valid, accepted coins.
    let coinHandler: CoinHandler
    var coins: [Coin] = []
    
    // 3 - The initializer is also very simple: we simply accept a passed-in coinHandler instance. VendingMachine doesn’t need to how a CoinHandler is set up, as it simply uses it.
    init(coinHandler: CoinHandler) {
        self.coinHandler = coinHandler
    }
    
     func insertCoin(_ unknownCoin: Coin) {
         // 1 - We first attempt to create a Coin by passing an unknownCoin to coinHandler. If a valid coin isn’t created, we print out a message indicating that the coin was rejected.
         guard let coin = coinHandler.handleCoinValidation(unknownCoin) else {
             print("Coin rejected: \(unknownCoin)")
             return
         }
         
         // 2 - If a valid Coin is created, you print a success message and append it to coins.
         print("Coin Accepted: \(coin)")
         coins.append(coin)
         
         // 3 - We then get the dollarValue for all of the coins and print this.
         let dollarValue = coins.reduce(0, { $0 + $1.dollarValue })
         print("")
         print("Coins Total Value: $\(dollarValue)")
         
         // 4 - lastly, we get the weight for all of the coins and print this, too.
         let weight = coins.reduce(0, { $0 + $1.weight })
         print("Coins Total Weight: \(weight) g")
         print("")
     }
}

example(of: "Vending Machine using Chain of Responsibility pattern") {
    // 1 - Before we can instantiate a VendingMachine, we must first set up the coinHandler objects for it.
    let pennyHandler = CoinHandler(coinType: Penny.self)
    let twentyPenceHandler = CoinHandler(coinType: TwentyPence.self)
    let fiftyPenceHandler = CoinHandler(coinType: FiftyPence.self)
    let poundHandler = CoinHandler(coinType: Pound.self)

    // 2 - We then hook up the next properties for the handlers
    pennyHandler.next = twentyPenceHandler
    twentyPenceHandler.next = fiftyPenceHandler
    fiftyPenceHandler.next = poundHandler

    // 3 - lastly we create vendingMachine by passing pennyHandler as the coinHandler.
    let vendingMachine = VendingMachine(coinHandler: pennyHandler)
    
    let penny = Penny()
    vendingMachine.insertCoin(penny)
    
    // Add the following code next to create an unknown Coin matching the criteria for a Quarter:
    let fiftyP = Coin(diameter: FiftyPence.standardDiameter, weight: FiftyPence.standardWeight)
    vendingMachine.insertCoin(fiftyP)
    
    // Lastly, lets insert an invalid coin:
    let invalidDime = Coin(diameter: FiftyPence.standardDiameter, weight: Pound.standardWeight)
    vendingMachine.insertCoin(invalidDime)
}

// MARK: - What should you be careful about?
// - The chain-of-responsibility pattern works best for handlers that can determine very quickly whether or not to handle an event. Be careful about creating one or more handlers that are slow to pass an event to the next handler.
// - You also need to consider what happens if an event can’t be handled. Will you return nil, throw an error or do something else? You should identify this upfront, so you can plan your system appropriately.
// - You should also consider whether or not an event needs to be processed by more than one handler. As a variation on this pattern, you can forward the same event to all handlers, instead of stopping at the first one that can handle it, and then return an array of response objects.

// MARK: - Here are its key points:
// - The chain-of-responsibility pattern allows an event to be processed by one of many handlers. It involves three types: a client, handler protocol, and concrete handlers.
// - The client accepts events and passes them onto its handler protocol instance; the handler protocol defines required methods and properties each concrete handler much implement; and each concrete handler can accept an event and in turn either handle it or pass it onto the next handler.
// - This pattern thereby defines a group of related handlers, which vary based on the type of event each can handle. If you need to handle new types of events, you simply create a new concrete handler.
