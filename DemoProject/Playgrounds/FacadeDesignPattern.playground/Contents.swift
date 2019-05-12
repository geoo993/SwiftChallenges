import Foundation
import UIKit
// The facade pattern is used to define a simplified interface to a more complex subsystem.
// The Facade pattern provides a simple interface to a library, framework, or complex system of classes. Instead of exposing the user to a set of classes and their APIs, you only expose one simple unified API.

// Imagine that your code has to deal with multiple objects of a complex library or framework. You need to initialize all these objects, keep track of the right order of dependencies, and so on. As a result, the business logic of your classes gets intertwined with implementation details of other classes. Such code is difficult to read and maintain. The Facade pattern provides a simple interface for working with complex subsystems containing lots of classes. The Facade pattern offers a simplified interface with limited functionality that you can extend by using a complex subsystem directly. This simplified interface provides only the features a client needs while concealing all others.

enum Media {
    case book
    case song
    case movie
    case none
}

struct Album: Codable {
    let title : String
    let artist : String
    let genre : String
    let coverUrl : String
    let year : String
}

enum Genre {
    case fiction
    case nonfiction
    case phylosophy
    case biology
    case biography
    case novel
    case romance
    case crime
    case horror
    case mystery
    case animation
    case action
    case adventure
    case comedy
    case history
    case drama
    case thriller
    case fantasy
    case sport
    case scifi
    case documentary
    case war
    case pop
    case jazz
    case blues
    case rock
    case rap
    case hiphop
    case classical
    case none
 }

enum Rating {
    case five
    case four
    case three
    case two
    case one
    case none
}

protocol Item {
    var title: String { get }
    var description : String { get }
    var coverImage: String { get }
    var rating: Rating { get }
    var genre: Genre { get }
    var year: Int { get }
    var language: String { get }
    var isFeatured: Bool { get set }
    var isFavorite: Bool { get set }
    func printSummary()
}

struct Book: Item {
    var title: String
    var description: String
    var coverImage: String
    var rating: Rating
    var genre: Genre
    var year: Int
    var language: String
    var authors: String
    var publisher: String
    var pages: Int = 0
    var isFeatured: Bool = false
    var isFavorite: Bool = false
    func printSummary() {
        print(
            " title: \(title)\n" +
                " authors: \(authors)\n" +
                " publisher: \(publisher)\n" +
                " description: \(description)\n" +
                " coverImage: \(coverImage)\n" +
                " genre: \(genre)\n" +
                " rating: \(rating)" +
                " year: \(year)\n" +
                " language \(language)\n" +
            ""
        )
    }
}
struct Song: Item {
    var title: String
    var description: String
    var coverImage: String
    var rating: Rating
    var genre: Genre
    var year: Int
    var language: String
    var artists: String
    var producer: String
    var duration: Double = 0
    var isFeatured: Bool = false
    var isFavorite: Bool = false
    func printSummary() {
        print(
            " title: \(title)\n" +
                " artists: \(artists)\n" +
                " producer: \(producer)\n" +
                " description: \(description)\n" +
                " coverImage: \(coverImage)\n" +
                " genre: \(genre)\n" +
                " rating: \(rating)" +
                " year: \(year)\n" +
                " language \(language)\n" +
            ""
        )
    }
}
struct Movie: Item {
    var title: String
    var description: String
    var coverImage: String
    var rating: Rating
    var genre: Genre
    var year: Int
    var language: String
    var casts: String
    var director: String
    var duration: Double = 0
    var isFeatured: Bool = false
    var isFavorite: Bool = false
    func printSummary() {
        print(
            " title: \(title)\n" +
                " casts: \(casts)\n" +
                " director: \(director)\n" +
                " description: \(description)\n" +
                " coverImage: \(coverImage)\n" +
                " genre: \(genre)\n" +
                " rating: \(rating)" +
                " year: \(year)\n" +
                " language \(language)\n" +
            ""
        )
    }
}

struct Product {
    var item: Item
    init(product: Item) {
        self.item = product
    }
    func play() {
        
    }
    func pause() {
        
    }
    func stop() {
        
    }
    mutating func setFeatured(feat: Bool) {
        item.isFeatured = feat
    }
    mutating func setFavourite(fav: Bool) {
        item.isFavorite = fav
    }
    var type: Media {
        switch item {
        case let _ as Book:
            return .book
        case let _ as Song:
            return .song
        case let _ as Movie:
            return .movie
        default: return .none
        }
    }

}
// Factory Facade of Media
class MediaLibrary {
    let name: String
    var products : [Product]
    var playlist : [Product]
    init(library: String, products: [Product]){
        self.name = library
        self.products = products
        self.playlist = []
    }
    func productLines() -> [Product] {
        return products
    }
    func addToLibrary(product: Product) {
        
    }
    func addToPlaylist(product: Product) {
        // check if it exists in products
    }
    func removeFromPlaylist(product: Product) {
        // check if it exists in products
    }
    func setFeatureProduct(product: inout Product) {
        // check if it exists in products
        // set cover Images
        product.setFeatured(feat: true)
    }
    func setFavouriteProduct(product: inout Product) {
        // check if it exists in products
        // set as favourite
        product.setFavourite(fav: true)
    }
    func getProduct(item: Item) -> Product? {
        return products
            .first(where: { $0.item.title == item.title && $0.item.description == item.description })
    }
    func books () -> [Book] {
        return products
            .filter({ $0.type == .book })
            .map({ $0.item as! Book })
    }
    func songs () -> [Song] {
        return products
            .filter({ $0.type == .song })
            .map({ $0.item as! Song })
    }
    func movies () -> [Movie] {
        return products
            .filter({ $0.type == .movie })
            .map({ $0.item as! Movie })
    }
    func chosingRandom(media: Media) -> Item? {
        switch media {
        case .book:
            return books().randomElement()
        case .song:
            return songs().randomElement()
        case .movie:
            return movies().randomElement()
        default: return nil
        }
    }
}

let book1 = Book(title: "The Tale Petter Pabbit",
                 description: "This is the tale of Peter rabbit",
                 coverImage: "peterrabbit",
                 rating: .four,
                 genre: .adventure,
                 year: 1902,
                 language: "eng",
                 authors: "BeatrixPotter",
                 publisher: "Pearson",
                 pages: 56,
                 isFeatured: false, isFavorite: false)
let song = Song(title: "Birds Set Free",
                 description: "Magical song from Sia",
                 coverImage: "birdssetfree",
                 rating: .five,
                 genre: .thriller,
                 year: 2016,
                 language: "eng",
                 artists: "Sia",
                 producer: "Kurstin",
                 duration: 4.15, isFeatured: true, isFavorite: true)
let movie = Movie(title: "Casino",
                  description: "Best mafia film of all time",
                  coverImage: "casino",
                  rating: .five,
                  genre: .crime,
                  year: 1995,
                  language: "eng",
                  casts: "Robert De Niro, Joe Pesci",
                  director: "Martin Scorsese",
                  duration: 360,
                  isFeatured: false, isFavorite: false)

let mediaLibrary = MediaLibrary(library: "My Lib", products:
    [
        Product(product: book1), Product(product: song), Product(product: movie)
    ])
let selectedItem: Song = mediaLibrary.chosingRandom(media: .song) as! Song
selectedItem.printSummary()
var selectedProduct = mediaLibrary.getProduct(item: selectedItem)
selectedProduct?.setFavourite(fav: true)
