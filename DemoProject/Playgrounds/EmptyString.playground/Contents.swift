
/* https://useyourloaf.com/blog/empty-strings-in-swift/
 How do you tell if a string is empty in Swift? That depends on what you mean by “empty”. You might mean a string with zero length, or maybe also an optional string that is nil. What about a “blank” string that only contains whitespace. Let’s see how to test for each of those conditions with Swift.
 

*/


var myName = "George"
myName.isEmpty

"".isEmpty

// Use isEmpty rather than comparing count to zero which requires iterating over the entire string:
var myEmpty = ""
myEmpty.count == 0


" "        // space
"\t\r\n"   // tab, return, newline
"\u{00a0}" // Unicode non-breaking space
"\u{2002}" // Unicode en space
"\u{2003}" // Unicode em space


// we can make use of character properties to directly test for whitespace.
func isBlank(_ string: String) -> Bool {
    for character in string {
        if !character.isWhitespace {
            return false
        }
    }
    return true
}

isBlank("  ")


// That works but a simpler way to test all elements in a sequence is to use allSatisfy.
extension String {
    var isBlank: Bool {
        return allSatisfy({ $0.isWhitespace })
    }
}

// This is looking promising:

"Hello".isBlank        // false
"   Hello   ".isBlank  // false
"".isBlank             // true
" ".isBlank            // true
"\t\r\n".isBlank       // true
"\u{00a0}".isBlank     // true
"\u{2002}".isBlank     // true
"\u{2003}".isBlank     // true


// We can extend the solution to allow for optional strings.
extension Optional where Wrapped == String {
    var isBlank: Bool {
        return self?.isBlank ?? true
    }
}

var title: String? = nil
title.isBlank            // true
title = ""
title.isBlank            // true
title = "  \t  "
title.isBlank            // true
title = "Hello"
title.isBlank            // false

// Testing for a “blank” string iterates over the string so don’t use it when isEmpty is all you need.
