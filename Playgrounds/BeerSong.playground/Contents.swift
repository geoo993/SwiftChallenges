import Foundation

func beerSong(_ beers : Int) -> String {
    var lyrics = ""
    
    for bottles in (1...beers).reversed() {
        let plural = bottles > 1 ? "s" : ""
        let takeOneDown = (bottles == 0) ? "\(bottles - 1)" : "No more"
        let newLine : String =
        "\(bottles) bottle\(plural) of beer on the wall, \(bottles) bottle\(plural) of beer.\n" +
        "Take one down, pass it around, \(takeOneDown) bottles of beer on the wall.\n\n"
        
        lyrics += newLine
    }
    
    lyrics +=
    "No more bottles of beer on the wall, no more bottles of beer.\n" +
    "We've taken them down and passed them around; now we're drunk and passed out!\n\n"
    
    return lyrics
}

print(beerSong( 99))
