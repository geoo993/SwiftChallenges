import Foundation

// Swift is a type-safe, statically typed language, meaning that each value has a type and the compiler performs type checking at compile time.
// As the name suggests, type erasure simply means hiding or erasing the type of a value.
// It allows us to throw away some type information. This is particularly useful when types are long and complex

protocol Artist {
    func sing() -> String
}

class AnyArtist: Artist {
    private let wrapped: Artist

    init(wrapped: Artist) {
        self.wrapped = wrapped
    }

    func sing() -> String {
        wrapped.sing()
    }
}

struct Adele: Artist {
    let name: String = "Adele"
    
    func sing() -> String {
        "Theres a fire coming in my heart"
    }
    
    // map to type erasure
    func eraseToAnyArtist() -> AnyArtist {
        AnyArtist(wrapped: self)
    }
}

struct Sia: Artist {
    let name: String = "Sia"
    
    func sing() -> String {
        "The greatest"
    }

    // map to type erasure
    func eraseToAnyArtist() -> AnyArtist {
        AnyArtist(wrapped: self)
    }
}

struct CelineDion: Artist {
    let name: String = "Celine Dion"
    
    func sing() -> String {
        "Pour que tu m'aime encore"
    }

    // map to type erasure
    func eraseToAnyArtist() -> AnyArtist {
        AnyArtist(wrapped: self)
    }
}


let adele = Adele()
let sia = Sia()
let celineDion = CelineDion()

let artists: [any Artist] = [adele, sia, celineDion]

for artist in artists {
    print(artist.sing())
}

let anArtist = AnyArtist(wrapped: sia)
print(anArtist.sing())

let erasedAdele = adele.eraseToAnyArtist()
print(erasedAdele.sing())
