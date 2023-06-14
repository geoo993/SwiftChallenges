import Foundation
import RegexBuilder

func example(of description: String, action: () -> Void) {
  print("\n--- Example of:", description, "---")
  action()
}

// Searching within text doesn’t always mean searching for an exact word or sequence of characters.
// Sometimes you want to search for a pattern. Perhaps you’re looking for words that are all uppercase, words that have numeric characters, or even a word that you may have misspelled in an article you’re writing and want to find to correct quickly.

// For that, regular expressions are an ideal solution.


// MARK: - Understand what regular expressions, also known as regex

// Most of the time, when you search for text, you know the word you want to look for. You use the search capability in your text editor and enter the word, then the editor highlights matches. If the word has a different spelling than your search criteria, the editor won’t highlight it.

// Regex doesn’t work that way. It’s a way to describe sequences of characters that most text editors nowadays can interpret and find text that matches. The results found don’t need to be identical. You can search for words that have four characters and this can give you results like "some" and "word".

// To try things out, we will use the MarvelMovies file to search characters.

// MARK: - Basics or regex
// First lets add an extend for NSRegularExpression to make creating and matching expressions easier.
extension NSRegularExpression {
    convenience init(pat: String) {
        do {
            try self.init(pattern: pat)
        } catch {
            preconditionFailure("Illegal regular expression: \(pat).")
        }
    }

    // We can have a second extension that wraps if how our pattern matches with a given string
    func matches(_ string: String) -> Bool {
        let range = NSRange(location: 0, length: string.utf16.count)
        return firstMatch(in: string, options: [], range: range) != nil
    }
}

// Lets start with the basic regex
example(of: "Simple NSRegularExpression") {
    // 1- First you define the string you want to check:
    let testString = "cahat 203, million"
    
    // 2- Next you create an NSRange instance that represents the full length of the string:
    let range = NSRange(location: 0, length: testString.utf16.count) // using utf16 count to avoid problems with emoji and similar.
    
    // 3- Next you create an NSRegularExpression instance using some regex syntax:
    let regex = NSRegularExpression(pat: "[a-z]at")
    
    // 4- Finally, we call firstMatch(in:) on the regex you created, passing the string to search, any special options, and what range of the string to look inside.
    let match = regex.firstMatch(in: testString, options: [], range: range)!
    
    // 5- We get the text in ranges of our testString
    for index in 0..<match.numberOfRanges {
        if let textInRange = Range(match.range(at: index), in: testString) {
            print(String(testString[textInRange]))
        }
    }
    print(regex.matches(testString))
}

// First lets understand the basics of regular expresions
// 1- We can use "[a-z]" to mean “any letter from “a” through “z”, and in regex terms this is a character class. This lets you specify a group of letters that should be matched, either by specifically listing each of them or by using a character range.
// 2- Regex ranges don’t have to be the full alphabet if you prefer. You can use "[a-t]" to exclude the letters “u” through “z”. On the other hand, if you want to be specific about the letters in the class just list them individually like this: "[csm]at"
// 3- Regexes are case-sensitive by default, which means “Cat” and “Mat” won’t be matched by “[a-z]at”. If you wanted to ignore letter case then you can either use “[a-zA-Z]at” or create your NSRegularExpression object with the flag .caseInsensitive.
// 4- You can also specify digit ranges with character classes. This is most commonly "[0-9]" to allow any number, or [A-Za-z0-9] to allow any alphanumerical letter.
// 5- If you want to match sequences of character classes you need a regex concept called quantification: the ability to say how many times something ought to appear. One of the most common is the asterisk quantifier, "*", which means “zero or more matches.” Quantifiers always appear after the thing they are modifying, so you might write something like this: "ca[a-z]*d", for “ca”, then zero or more characters from “a” through “z”, then “d” – it matches “cad”, “card”, “camped”, and more.
// 6- As well as "*", there are two other similar quantifiers: "+" and "?".
//      - If you use "+" it means “one or more”, which is ever so slightly different from the “zero or more” of *.
//      - if you use "?" it means “zero or one.”
// 7- These quantifiers are really fundamental in regexes, lets consider these three regexes:
//      - c[a-z]*d
//      - c[a-z]+d
//      - c[a-z]?d
//  when given the test string “cd” and "camped".
//      - The first regex c[a-z]*d means “c then zero or more lowercase letters, then d,” so it will match both “cd” and “camped”.
//      - The second regex c[a-z]+d means “c then one or more lowercase letters, then d,” so it won’t match “cd” but will match “camped”.
//      - Finally, the third regex c[a-z]?d means “c then zero or one lowercase letters, then d,” so it will match “cd” but not “camped”.
// 8- Quantifiers aren’t just restricted to character classes. For example, if you wanted to match the word “color” in both US English (“color”) and International English (“colour”), you could use the regex colou?r. That is, “match the exact string ‘colo’, the match zero or one ‘u’s, then an ‘r’.”
example(of: "Quantifiers") {
    let regex1 = NSRegularExpression(pat: "c[a-z]*d")
    print("c[a-z]*d Matches cd:", regex1.matches("cd"))
    print("c[a-z]*d Matches camped:", regex1.matches("camped"))
    
    let regex2 = NSRegularExpression(pat: "c[a-z]+d")
    print("c[a-z]+d Matches cd:", regex2.matches("cd"))
    print("c[a-z]+d Matches camped:", regex2.matches("camped"))
    
    let regex3 = NSRegularExpression(pat: "c[a-z]?d")
    print("c[a-z]?d Matches cd:", regex3.matches("cd"))
    print("c[a-z]?d Matches camped:", regex3.matches("camped"))
    
    let colourReg = NSRegularExpression(pat: "colou?r")
    print("colou?r Matches color:", colourReg.matches("color"))
    print("colou?r Matches colour:", colourReg.matches("colour"))
}



// 9- You can also be more specific about your quantities: “I want to match exactly three characters.” This is done using braces, { and }. For example [a-z]{3} means “match exactly three lowercase letters.”
//      - Consider a phone number formatted like this: 111-1111. We want to match only that format, and not “11-11”, “1111-111”, or “11111111111”, which means a regex like [0-9-]+ would be insufficient. Instead, we need to a regex like this: [0-9]{3}-[0-9]{4}: precisely three digits, then a dash, then precisely four digits.
//      - You can also use braces to specify ranges, either bounded or unbounded. For example, [a-z]{1,3} means “match one, two, or three lowercase letters”, and [a-z]{3,} means “match at least three, but potentially any number more.”

example(of: "Quantifiers for precise lookup") {
    let regex1 = NSRegularExpression(pat: "[0-9-]+") // match digit then - and then any value
    print("[0-9-]+ Matches 11-11:", regex1.matches("11-11"))
    print("[0-9-]+ Matches 1111-111:", regex1.matches("1111-111"))
    print("[0-9-]+ Matches 1111111111:", regex1.matches("1111111111"))
    
    // precise lookup
    let regex2 = NSRegularExpression(pat: "[0-9]{3}-[0-9]{4}") // match digit of three then - and then any digit of 4
    print("[0-9]{3}-[0-9]{4} Matches 11-11:", regex2.matches("11-11"))
    print("[0-9]{3}-[0-9]{4} Matches 1111-111:", regex2.matches("1111-111"))
    print("[0-9]{3}-[0-9]{4} Matches 1111111111:", regex2.matches("1111111111"))
    print("[0-9]{3}-[0-9]{4} Matches 111-1111:", regex2.matches("111-1111"))
    
    let regex3 = NSRegularExpression(pat: "[a-z]{1,3}") // match one, two, or three lowercase letters
    print("[a-z]{1,3} Matches sam truth:", regex3.matches("sam truth"))
    print("[a-z]{1,3} Matches T:", regex3.matches("T"))
    
    let regex4 = NSRegularExpression(pat: "[a-z]{3,}") // match at least three, but potentially any number more.
    print("[a-z]{3,} Matches same:", regex4.matches("same"))
    print("[a-z]{3,} Matches go:", regex4.matches("go"))
}

// 10- Meta-characters are special characters that regexes give extra meaning, and at least three of them are used extensively.
//      - the most used, most overused, and most abused of these is the "." character – a period – which will match any single character except a line break. So, the regex "c.t" will match “cat” but not “cart”. If you use "." with the "*" quantifier it means “match one or more of anything that isn’t a line break,” which is probably the most common regex you’ll come across.
// - The problem witn ".*" is that it will match almost everything. being specific is sort of the point of regular expressions: you can search for precise variations of text in order to apply some processing – too many people rely on .* as a crutch, without realizing it can introduce subtle mistakes into their expressions.

example(of: "Meta character expressions") {
    // consider matching phone numbers like 555-5555: which is [0-9]{3}-[0-9]{4} in regex.
    let regex1 = NSRegularExpression(pat: "[0-9]{3}-[0-9]{4}") // match 3 digits then - and then matches 4 digits
    print("[0-9]{3}-[0-9]{4} Matches 555-5555:", regex1.matches("555-5555"))
    
    // You might think “maybe some people will write “555 5555” or “5555555”, and try to make your regex looser by using .* instead, like this: [0-9]{3}.*[0-9]{4}.
    let regex2 = NSRegularExpression(pat: "[0-9]{3}.*[0-9]{4}")
    print("[0-9]{3}.*[0-9]{4} Matches 555-5555:", regex2.matches("555-5555"))
    
    // But now you have a problem, this will match “123-4567”, “123-4567890”, and even “123-456-789012345”.
    print("[0-9]{3}.*[0-9]{4} Matches 123-4567:", regex2.matches("123-4567"))
    print("[0-9]{3}.*[0-9]{4} Matches 123-4567890:", regex2.matches("123-4567890"))
    print("[0-9]{3}.*[0-9]{4} Matches 123-456-789012345:", regex2.matches("123-456-789012345"))
    
    // Instead, you can use character classes with quantifiers, for example [0-9]{3}[ -]*[0-9]{4} means “find three digits, then zero or more spaces and dashes, then four digits.” or negated character classes.
    let regex3 = NSRegularExpression(pat: "[0-9]{3}[ -]*[0-9]{4}")
    print("[0-9]{3}[ -]*[0-9]{4} Matches 555-5555:", regex3.matches("555-5555"))
    print("[0-9]{3}[ -]*[0-9]{4} Matches 123-4567890:", regex3.matches("123-4567890"))
    print("[0-9]{3}[ -]*[0-9]{4} Matches 123-456-789012345:", regex3.matches("123-456-789012345"))
    
    // You can also use negated character classes to match anything that isn’t a digit, so [0-9]{3}[^0-9]+[0-9]{4} will match a space, a dash, a slash, and more – but it won’t match numbers.
    let regex4 = NSRegularExpression(pat: "[0-9]{3}[^0-9]+[0-9]{4}")
    print("[0-9]{3}[^0-9]+[0-9]{4} Matches 555-5555:", regex4.matches("555-5555"))
    print("[0-9]{3}[^0-9]+[0-9]{4} Matches 123-4567890:", regex4.matches("123-4567890"))
    print("[0-9]{3}[^0-9]+[0-9]{4} Matches 123-456-789012345:", regex4.matches("123-456-789012345"))
}

// MARK: - Swiftifying Regular Expressions

// Swift 5.7 introduces a new Regex type that's a first-degree citizen in Swift. It isn't a bridge from Objective-C's NSRegularExpression.
// Swift Regex allows you to define a regular expression in three different ways:

// 1- As a literal:
let digitsRegex1 = /\d+/

// 2- From a String:
let regexString2 = #"\d+"#
let digitsRegex2 = try? Regex(regexString2)

// 3- Using RegexBuilder:
let digitsRegex3 = OneOrMore {
    CharacterClass.digit
}

// - The first two use the standard regular expression syntax.
// - What's different about the second approach is that it allows you to create Regex objects dynamically by reading the expressions from a file, server or user input. Because the Regex object is created at runtime, you can't rely on Xcode to check it, which is a handy advantage to the first approach.
// - The third is the most novel. Apple introduced a new way to define regular expressions using a result builder. You can see it's easier to understand what it's searching for in the text. An arguable drawback is that this approach is more verbose.

// Now lets look at how they work in practice
example(of: "Regex literal") {
    // You can create a Swift regex from raw text, the same way you would with NSRegularExpression:
    // Match and capture one or more digits
    let pattern = /\d+/
    //        let pattern = #"(\d+)"#
    let regex = Regex(pattern)
    if let result = "Sam is 20 years old".firstMatch(of: regex) {
        print(result.0)
    }
    
    // This creates a regular expression of type Regex but it has some of the same disadvantages of NSRegularExpression:
    // 1- We need to escape the raw text to protect the regex backslash.
    // 2- There’s no compile time syntax checking of the pattern. We only find errors at run time when the try operation throws.
    
    // An example of using this regex to extract a name and a number from an input string:
    let regex2 = /(\w+)\s+(\d+)/
    let input = "Tom 123 xyz"
    if let result = input.firstMatch(of: regex2) {
        print(result.0)  // Tom 123
        print(result.1)  // Tom
        print(result.2)  // 123
        
    }
    
    // we can get an output tuple of matching substrings
    if let result = input.firstMatch(of: regex2) {
        let (matched, name, count) = result.output
        print(matched, name, count)
    }
    
    // We can also name the captured variables:
    let regex3 = /(?<name>\w+)\s+(?<count>\d+)/
    // This can be easier to write using the extended regex literal format which allows you to include spacing.
    let regex4 = #/
      (?<name> \w+) \s+
      (?<count> \d+)
    /#
    if let match = input.firstMatch(of: regex4) {
        print(match.name)   // Tom
        print(match.count)  // 123
    }
}


example(of: "Regex literal match") {
    // There are a few different ways to apply a regex to an input string:
    // We’ve already seen an example of firstMatch.
    let input = "123 456 def"
    if let match = input.firstMatch(of: /(\d+)/) {
        print(match.0)  // 123
        print(match.1)  // 123
    }
    
    // Compare this to wholeMatch where our regex pattern must match the whole input string:
    let input2 = "abc 456 def"
    if let match = input2.wholeMatch(of: /\w+\s+(\d+)\s+\w+/) {
        print(match.0)  // abd 456 def
        print(match.1)  // 456
    }
    
    // Prefix match guarantees that the input string starts with the pattern. So the following will fail to match:
    let input3 = "abc456def"
    // let match = input3.prefixMatch(of: /(\d+)/)  // nil
    
    // When you just want to test for the prefix and don’t care about capturing the values:
    let worddigit = input3.starts(with: /\w+\d+/)  // true
    print(worddigit)
}

//
example(of: "Regex Builder") {
    // The regex builder DSL provides a more verbose but hopefully more structured and readable way to build a regex
    // Rewriting the earlier example using a regex builder (remember to import RegexBuilder):
    let regex = Regex {
        Capture {
            OneOrMore(.word)
        }
        OneOrMore(.whitespace)
        Capture {
            OneOrMore(.digit)
        }
    }
    
    let input = "Tom 123 xyz"
    if let match = input.firstMatch(of: regex) {
        let name = match.1    // Tom
        let count = match.2   // 123
    }
    
    // The traditional regex syntax places captured values in brackets. With regex builder you use Capture blocks.
    // We also have the more verbose, but also more readable components for quantities such as One, OneOrMore, ZeroOrMore, ChoiceOf, and Optionally. Some examples:
    let colorRegex = Regex {
      Capture {
        ChoiceOf {
            "red"
            "green"
            "blue"
        }
      }
      ":"
      One(.whitespace)
      Capture(OneOrMore(.digit))
      ZeroOrMore(.whitespace)
      Optionally(OneOrMore(.hexDigit))
    }
    let colors = [
        "red: 255 FF",
        "green: 0",
        "blue: 128 80"
    ]
    for color in colors {
        if let match = color.wholeMatch(of: colorRegex) {
            print(match.1, match.2)
        }
    }
}

example(of: "Transforming captures of Regex Builder") {
    // You can improve the type safety of captured values by adding a transform block to the capture.
    // This allow you to transform the generic capture output to a known type
    let regex = Regex {
      Capture {
        OneOrMore(.digit)
      } transform: {
        Int($0)  // Int?
      }
    }
    let input = "Tom 123 xyz"
    if let match = input.firstMatch(of: regex) {
        print(match.1)
    }
    
    // To avoid the optional types use a TryCapture block:
    let regex2 = Regex {
      TryCapture {
        OneOrMore(.digit)
      } transform: {
        Int($0)  // Int
      }
    }
    if let match = input.firstMatch(of: regex2) {
        print(match.1)
    }
    
    // If the transform operation fails, the regex backtracks to try an alternate path.
    // Another example using a custom type where the initializer can fail:
    enum RGBColor: String {
      case red
      case blue
      case green
    }

    let colorRegex = Regex {
        TryCapture {
            ChoiceOf {
                "red"
                "green"
                "blue"
            }
        } transform: {
            RGBColor(rawValue: String($0))
        }
    }
    let colors = [
        "red",
        "green",
        "blue"
    ]
    for color in colors {
        if let match = color.wholeMatch(of: colorRegex) {
            print(match.1)
        }
    }
}

// MARK: - Reading the Text File

enum ProductionYearInfo {
    case produced(year: Int)
    case onGoing(startYear: Int)
    case finished(startYear: Int, endYear: Int)
    case unknown
    
    func toString() -> String {
        switch self {
        case .produced(let year):
            return "\(year)"
        case .onGoing(let startYear):
            return "\(startYear) - On Going"
        case let .finished(startYear, endYear):
            return "\(startYear) - \(endYear)"
        case .unknown:
            return "Not Produced"
        }
    }
}

enum PremieredOnInfo {
    case definedDate(Date)
    case estimatedYear(Int)
    case unknown
    
    func toString() -> String {
        switch self {
        case .definedDate(let date):
            return "\(date.toString())"
        case .estimatedYear(let year):
            return "In \(year)"
        case .unknown:
            return "Not Announced"
        }
    }
}

extension Date {
    static func fromString(_ dateString: String) -> Date {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, yyyy"
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        let date = formatter.date(from: dateString) ?? Date()
        return date
    }
    
    func toString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, yyyy"
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        let string = formatter.string(from: self)
        return string
    }
}


struct MarvelProductionItem {
    let id = UUID()
    let imdbID: String
    let title: String
    let productionYear: ProductionYearInfo
    let premieredOn: PremieredOnInfo
    let posterURL: URL?
    let imdbRating: Float?
    
    init(
        imdbID: String,
        title: String,
        productionYear: ProductionYearInfo,
        premieredOn: PremieredOnInfo,
        posterURL: URL?,
        imdbRating: Float?
    ) {
        self.imdbID = imdbID
        self.title = title
        self.productionYear = productionYear
        self.premieredOn = premieredOn
        self.posterURL = posterURL
        self.imdbRating = imdbRating
    }
}

func loadData() -> [MarvelProductionItem] {
    // 1 - Defines marvelProductions as an array of objects that you'll add items to later.
    var marvelProductions: [MarvelProductionItem] = []
    
    // 2 - Reads the contents of the MarvelMovies file from the app's bundle and loads it into the property content.
    var content = ""
    if let filePath = Bundle.main.path(
        forResource: "MarvelMovies",
        ofType: nil) {
        let fileURL = URL(fileURLWithPath: filePath)
        do {
            content = try String(contentsOf: fileURL)
        } catch {
            return []
        }
    }
    
    // - Defining the Separator
    // The first regular expression you'll define is the separator. For that, you need to define the pattern that represents what a separator can be.
    // All of the below are valid separator strings for this data:
    // 1- SpaceSpace
    // 2) SpaceTab
    // 3) Tab
    // 4) TabSpace
    // However, this is not a valid separator in the MarvelMovies file: Space
    // A valid separator can be a single tab character, two or more space characters, or a mix of tabs and spaces but never a single space, because this would conflict with the actual content.
    
    // - Define Regex
    // In regular expression syntax, \s matches any single whitespace character, so a space or a tab, whereas \t only matches a tab.
    // This new code has three parts:
    let fieldSeparator = ChoiceOf { // 1 - ChoiceOf means only one of the expressions within it needs to match.
      /[\s\t]{2,}/ // 2 - The square brackets define a set of characters to look for and will only match one of those characters, either a space or a tab character, in the set. The curly braces define a repetition to the expression before it, to run two or more times. This means the square brackets expression repeats two or more times.
      /\t/ // 3 - An expression of a tab character found once.
    }

    // This "fieldSeparator" defines a regex that can match two or more consecutive spaces with no tabs, a mix of spaces and tabs with no specific order or a single tab.
    
    // - Defining the Fields of MarvelProductionItem
    // You can define the fields in MarvelProductionItem as follows:
    // "id": A string that starts with tt followed by several digits.
    // "title": A string of a different collection of characters.
    // "productionYear": A string that starts with ( and ends with ).
    // "premieredOn": A string that represents a date.
    // "posterURL": A string beginning with http and ends with jpg.
    // "imdbRating": A number with one decimal place or no decimal places at all.

    // You can define those fields using regular expressions as follows.
    let idField = /tt\d+/ // 1 - An expression that matches a string starting with tt followed by any number of digits.
    
    let titleField = OneOrMore { // 2 - Any sequence of characters.
        NegativeLookahead { fieldSeparator }
        CharacterClass.any
    }
    
    let yearField = /\(.+\)/ // 3 - A sequence of characters that starts with ( and ends with ).
    
    let premieredOnField = OneOrMore { // 4 - Instead of looking for a date, you'll search for any sequence of characters, then convert it to a date.
        NegativeLookahead { fieldSeparator }
        CharacterClass.any
    }
    
    let urlField = /http.+jpg/ // 5 - Similar to yearField, but starting with http and ending with jpg.
    
    let imdbRatingField = OneOrMore { // 6 - you'll search for any sequence of characters then convert it to a Float.
        NegativeLookahead { CharacterClass.newlineSequence }
        CharacterClass.any
    }

    // Now that you have each row of the MarvelMovies file broken down into smaller pieces, it's time to put the pieces together and match a whole row with an expression.
    // The following code does the following:
//    let recordMatcher = Regex { // 1 - Defines a new Regex object that consists of the idField regex followed by a fieldSeparator regex.
//        Capture { idField }
//          fieldSeparator
//          Capture { titleField }
//          fieldSeparator
//          Capture { yearField }
//          fieldSeparator
//          Capture { premieredOnField }
//          fieldSeparator
//          Capture { urlField }
//          fieldSeparator
//          Capture { imdbRatingField }
//          /\n/
//    }
//    
//    let matches = content.matches(of: recordMatcher) // 2 - Gets the collection of matches found in the string you loaded from the file earlier.
//    print("Found \(matches.count) matches")
//    for match in matches { // 3 - Loops over the found matches.
//        print(match.output + "|") // 4 - Prints the output of each match followed by the pipe character, |.
//    }
    
    // - Capture matches
//    let recordMatcher = Regex { // 1 - Defines a new Regex object that consists of the idField regex followed by a fieldSeparator regex.
//        Capture { idField }
//        fieldSeparator
//        Capture { titleField }
//        fieldSeparator
//        Capture { yearField }
//        fieldSeparator
//        Capture { premieredOnField }
//        fieldSeparator
//        Capture { urlField }
//        fieldSeparator
//        Capture { imdbRatingField }
//        /\n/
//    }
//
    // - Naming Captures
    // Depending on order isn't always a good idea for API design. If the raw data introduces a new column in an update that isn't at the end, this change will cause a propagation that goes beyond just updating the Regex. You'll need to revise what the captured objects are and make sure you're picking the right item.
    // A better way is to give a reference name to each value that matches its column name. That'll make your code more resilient and more readable.
    // You create a Reference object for each value field in the document using their data types.
    let idFieldRef = Reference(Substring.self)
    let titleFieldRef = Reference(Substring.self)
    let yearFieldRef = Reference(Substring.self)
    let premieredOnFieldRef = Reference(Substring.self)
    let urlFieldRef = Reference(URL.self)
    let imdbRatingFieldRef = Reference(Float.self)
    
    let getMatcher = Regex {
        Capture(as: idFieldRef) { idField }
        fieldSeparator
        Capture(as: titleFieldRef) { titleField }
        fieldSeparator
        Capture(as: yearFieldRef) { yearField }
        fieldSeparator
        Capture(as: premieredOnFieldRef) { premieredOnField }
        fieldSeparator
//        Capture(as: urlFieldRef) { urlField }
        TryCapture(as: urlFieldRef) { // 1 - TryCapture(as::transform:). If successful, the later attempts to capture the value will pass it to transform function to convert it to the desired type
            urlField
        } transform: {
            URL(string: String($0))
        }
        fieldSeparator
//      Capture(as: imdbRatingFieldRef) { imdbRatingField }
        TryCapture(as: imdbRatingFieldRef) { // 2 - same here
            imdbRatingField
        } transform: {
            Float(String($0))
        }
        /\n/
    }
    
    
    let matches = content.matches(of: getMatcher) // - Gets the collection of matches found in the string you loaded from the file earlier.
//    for match in matches { // - Loops over the found matches.
//        print("Full Row: " + match.output.0)
//        print("ID: " + match.output.1)
//        print("Title: " + match.output.2)
//        print("Year: " + match.output.3)
//        print("Premiered On: " + match.output.4)
//        print("Image URL: " + match.output.5)
//        print("Rating: " + match.output.6)
//        print("Full Row: " + match.output.0)
//        print("ID: " + match[idFieldRef])
//        print("Title: " + match[titleFieldRef])
//        print("Year: " + match[yearFieldRef])
//        print("Premiered On: " + match[premieredOnFieldRef])
//        print("Image URL: " + match[urlFieldRef].absoluteString)
//        print("Rating: \(match[imdbRatingFieldRef])")
//        print("---------------------------")
//    }

    // - Transforming Data
    // One great feature of Swift Regex is the ability to transform captured data into different types.
    // Currently, you capture all the data as Substring. There are two fields that are easy to convert:
    // 1) The image URL, which doesn't need to stay as a string — it's more convenient to convert it to a URL
    // 2) The rating, which works better as a number so you'll convert it to a Float
    
    for match in matches { // - Loops over the found matches.
        let production = MarvelProductionItem(
            imdbID: String(match[idFieldRef]),
            title: String(match[titleFieldRef]),
            productionYear: ProductionYearInfo.fromString(String(match[yearFieldRef])),
            premieredOn: PremieredOnInfo.fromString(String(match[premieredOnFieldRef])),
            posterURL: match[urlFieldRef], // 4
            imdbRating: match[imdbRatingFieldRef]
        )
        marvelProductions.append(production)
    }
    
    // - Returns the array at the end of the function.
    return marvelProductions
}

example(of: "Regex from file") {
    let movies = loadData()
    for movie in movies {
        print("ID: \( movie.id)")
        print("Title: \( movie.title)")
        print("Year: \( movie.productionYear.toString())")
        print("Premiered On: \( movie.premieredOn.toString())")
        print("Image URL: \( movie.posterURL?.absoluteString ?? "")")
        print("Rating: \(movie.imdbRating ?? 0) ")
        print("---------------------------")
    }
}

// MARK: - Creating a Custom Type

// Notice that Production Year displays Not Produced and Premiered On shows Not Announced, even for old movies and shows.
// This is because you haven't implemented the parsing of their data yet so .unknown is returned for their values.
// The production year won't always be a single year:
// - If it's a movie, the year will be just one value, for example: (2010).
// - If it's a TV show, it can start in one year and finish in another: (2010-2012).
// - It could be an ongoing TV show: (2010- ).
// - Marvel Studios may not have announced a date yet, making it truly unknown: (I).

// This is the same for PremieredOnInfo:
// - An exact date may have been set, such as: Oct 10, 2010.
// - An exact date may not yet be set for a future movie or show, in which case only the year is defined: 2023.
// - Dates may not yet be announced: -.

// This means the data for these fields can have different forms or patterns.
// Since we captured them as text we can do this. We can start by breaking down what we'll do with the year field. The value in the three cases will be within parentheses:
// 1- If it's a single year, the expression is: \(\d+\).
// 2- If it's a range between two years, it's two numbers separated by a dash: \(\d+-\d+\).
// 3- If it's an open range starting from a year, it's a digit, a dash then a space: \(\d+-\s\).

extension ProductionYearInfo {
    static func fromString(_ value: String) -> Self {
        if let match = value.wholeMatch(of: /\((?<startYear>\d+)\)/) { // 1 - We compare the value against an expression that expects one or more digits between parentheses. This is why you escaped one set of parentheses.
            return .produced(year: Int(match.startYear) ?? 0) // 2 - If the expression is a full match, you capture just the digits without the parentheses and return .produced
        } else if let match = value.wholeMatch(
            of: /\((?<startYear>\d+)-(?<endYear>\d+\))/) { // 3 - If it doesn't match the first expression, you test it against another that consists of two numbers with a dash between them.
            return .finished(
                startYear: Int(match.startYear) ?? 0,
                endYear: Int(match.endYear) ?? 0
            ) // 4 - If that matches, you return .finished and use the two captured values as integers.
        } else if let match = value.wholeMatch(of: /\((?<startYear>\d+)–\s\)/) { // 5 - If the second expression didn't match, you check for the third possibility, a number followed by a dash, then a space to represent a show that's still running.
            return .onGoing(startYear: Int(match.startYear) ?? 0) // 6 - If this matches, you return .onGoing using the captured value.
        }
        return .unknown
    }
}

extension PremieredOnInfo {
    static func fromString(_ value: String) -> Self {
        //1 - You create two expressions to represent the two possible value cases you expect, either a four-digit year, or a full date consisting of a three-character full or shortened month name or a four-character month name, followed by one or two characters for the date, followed by a comma, a whitespace and a four-digit year.
        let yearOnlyRegexString = #"\d{4}"#
        let datesRegexString = #"\S{3,4}\s.{1,2},\s\d{4}"#
        
        guard let yearOnlyRegex = try? Regex(yearOnlyRegexString),
              let datesRegex = try? Regex(datesRegexString) else { // 2 - Create the two Regex objects that you'll use to compare against.
            return .unknown
        }
        
        if let match = value.wholeMatch(of: yearOnlyRegex) { // 3 - Try to match the whole string against the yearOnlyRegexString`. If it matches, you return .estimatedYear and use the provided value as the year.
            let result = match.first?.value as? Substring ?? "0"
            return .estimatedYear(Int(result) ?? 0)
        } else if let match = value.wholeMatch(of: datesRegex) { // 4 - Otherwise, you try to match the whole string against the other Regex object, datesRegexString.
            let result = match.first?.value as? Substring ?? ""
            let dateStr = String(result)
            let date = Date.fromString(dateStr)
            return .definedDate(date)
        }
        return .unknown
    }
}

