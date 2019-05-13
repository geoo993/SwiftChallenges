// As the name suggests, the iterator helps you form an array or list type structure.
import Foundation

// The class MyBestFilms implements the Sequence protocol that creates a custom iterator. Every time the next() function is called, it returns the next element and store the current index.
// This is absolutely great! You can create your own custom sequence.
struct MyBestFilms: Sequence {
    let films: [String]
    
    func makeIterator() -> MyBestFilmsIterator {
        return MyBestFilmsIterator(films)
    }
}

// The class inheriting to the IteratorProtocol does not expose the data structure used in implementing it
// (array, dictionary or linked list) rather it gives an interface which iterates over the collection of
// elements without exposing its underlying representation.
struct MyBestFilmsIterator: IteratorProtocol {
    
    var films: [String]
    var cursor: Int = 0
    
    init(_ films: [String]) {
        self.films = films
    }
    
    mutating func next() -> String? {
        defer { cursor += 1 }
        return films.count > cursor ? films[cursor] : nil
    }
}

let myFilms = MyBestFilms(films: ["Godfather Trilogy", "Silence of the Lambs", "Call Me By Your Name"])
for film in myFilms {
    print(film)
}
