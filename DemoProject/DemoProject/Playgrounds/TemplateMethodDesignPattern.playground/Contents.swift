import UIKit

/// The Template Method design pattern defines a skeleton for an algorithm such as properties or operations within a class, and delegates the responsibility for some steps to subclasses (deferring the responsibility for refining these properties and operations to subclasses). This pattern simply lets subclasses redefine (overriding) certain steps of an algorithm without changing the algorithm’s structure. It basically involves splitting an algorithm into a sequence of steps, describing these steps in separate methods, and let subclasses use them consecutively without needing to change the Template Method.

// These templates enables you to write code that avoids duplication and expresses its intent in a clear, abstracted manner. In this pattern, the base class defines the template of an algorithm and let the subclass implement these abstract methods in the same way they are defined in the base class without changing the overall structure.
// You should use the Template Method design pattern
// when subclasses need to extend a basic algorithm without modifying its structure;
// when you have several classes responsible for quite similar actions (meaning that whenever you modify one class, you need to change the other classes).

enum GameType {
    case whackAMole
    case pairs
    case wordSearch
    case wordCookie
    case wordSwipe
}

extension GameType {
    
    var title: String {
        switch self {
        case .whackAMole: return "Whack A Mole"
        case .pairs: return "Pairs"
        case .wordSearch: return "Word Search"
        case .wordCookie: return "Word Cookie"
        case .wordSwipe: return "Word Swipe"
        }
    }
    var description: String {
        switch self {
        case .whackAMole: return "Whack the mole that has the given letter"
        case .pairs: return "Find the 6 pairs"
        case .wordSearch: return "Find the word by swiping letters horrizontally, vertically or diagonaly"
        case .wordCookie: return "Find the word by connecting each letter"
        case .wordSwipe: return "Find the word by swiping the tiles"
        }
    }
    
    static var array: [GameType] {
        return [whackAMole, pairs, wordSearch, wordCookie, wordSwipe]
    }
    
    public static var random: GameType {
        return array.randomElement()!
    }
}

enum GameStatus {
    case idle
    case preview
    case running
    case ended(score: Double)
}

enum TileMode {
    case preview
    case opened
    case closed
    case highlighted
}

private protocol Tile {
    var mode: TileMode { get set }
    var word: String { get set }
    var positionInGrid: Int { get }
    func preview()
    func open()
    func close()
    func highlight()
}

class TileBase: Tile {
    var mode: TileMode
    var word: String
    var positionInGrid: Int
    init(word: String, index: Int) {
        self.mode = .preview
        self.word = word
        self.positionInGrid = index
    }
    func preview() {
        mode = .preview
    }
    func open() {
        mode = .opened
    }
    func close() {
        mode = .closed
    }
    func highlight() {
        mode = .highlighted
    }
}

private protocol Game {
    var type: GameType { get }
    var status: GameStatus { get set }
    var words: [String] { get }
    var score: Double { get set }
    var tiles: [TileBase] { get set }
    func setup()
    func start()
    func update(completion: @escaping (Bool) -> Void)
    func reset()
    func openTile(at index: Int) -> TileBase?
    func closeTile(at index: Int) -> TileBase?
    func highlightTile(at index: Int) -> TileBase?
}

// Template Method 
class GameBase: Game {
    var type: GameType
    var status: GameStatus
    var words: [String]
    var score: Double
    var tiles: [TileBase]
    init(words: [String], type: GameType) {
        self.type = type
        self.status = .idle
        self.words = words
        self.score = 0
        self.tiles = []
        setup()
    }
    func setup() {
        tiles.forEach({ $0.preview() })
        status = .preview
    }
    func start() {
        tiles.forEach({ $0.close() })
        self.score = 0
        status = .running
    }
    func update(completion: @escaping (Bool) -> Void) {
        
        completion(true)
    }
    func reset() {
        tiles.forEach({ $0.close() })
        self.score = 0
        status = .idle
    }
    func openTile(at index: Int) -> TileBase? {
        if let tile = tiles.first(where: { $0.positionInGrid == index }) {
            tile.open()
            return tile
        }
        return nil
    }
    
    func closeTile(at index: Int) -> TileBase? {
        if let tile = tiles.first(where: { $0.positionInGrid == index }) {
            // do something with tile
            tile.close()
            return tile
        }
        return nil
    }
    func highlightTile(at index: Int) -> TileBase? {
        if let tile = tiles.first(where: { $0.positionInGrid == index }) {
            // do something with tile
            tile.highlight()
            return tile
        }
        return nil
    }
}

class Pairs: GameBase {
    enum Event {
        case didPreview
        case didStart
        case didSelectTile(Int)
        case didEnd
    }
    let numberOfPairs: Int
    var pairsFound: [String] = []
    private var recentChoice: TileBase?
    init(words: [String], numberOfPairs: Int) {
        self.numberOfPairs = numberOfPairs
        super.init(words: words, type: .pairs)
    }
    override func setup() {
        super.setup()
        // add all the tile pairs here
    }
    func process(event: Event) {
        switch event {
        case .didPreview:
            print("preview pairs game")
            setup()
        case .didStart:
            print("start pairs game")
            start()
            recentChoice = nil
            pairsFound.removeAll()
        case let .didSelectTile(index):
            if tiles.contains(where: { $0.positionInGrid == index }), index < tiles.count {
                
            } else {
                print("there is no tile with \(index) index")
            }
        case .didEnd:
            print("end pairs game")
            break
        }
    }
   
}

class WordCookie: GameBase {
    enum Event {
        case didPreview
        case didStart
        case didSwipeTile(Int)
        case didEnd
    }
    let maxLetters: Int
    private var recentChoice: TileBase?
    init(words: [String], maxLetters: Int) {
        self.maxLetters = maxLetters
        super.init(words: words, type: .wordCookie)
    }
    override func setup() {
        super.setup()
        // add all the word cookie tiles here
    }
    func process(event: Event) {
        switch event {
        case .didPreview:
            print("preview word cookie game")
            setup()
        case .didStart:
            print("start word cookie game")
            start()
            recentChoice = nil
        case let .didSwipeTile(index):
            if tiles.contains(where: { $0.positionInGrid == index }), index < maxLetters {
                
            } else {
                print("there is no tile with \(index) index")
            }
        case .didEnd:
            print("end word cookie game")
            break
        }
    }
}

let pairs = Pairs(words: ["loved", "words", "more", "than", "women",  "inspired", "write", "them"], numberOfPairs: 6)
pairs.process(event: .didPreview)
pairs.process(event: .didStart)
pairs.process(event: .didSelectTile(3))

let wordCookie = WordCookie(words: ["A", "E", "P", "M", "T", "O", "Q", "N", "I", "D"], maxLetters: 5)
wordCookie.process(event: .didPreview)
wordCookie.process(event: .didStart)
wordCookie.process(event: .didSwipeTile(8))
