// Generated using Sourcery 0.16.1 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT


    // hello, sourcery!
    extension Person: Equatable {
        public static func ==(lhs: Person, rhs: Person) -> Bool {
            guard lhs.name == rhs.name else { return false }
            guard lhs.age == rhs.age else { return false }
            guard lhs.gender == rhs.gender else { return false }

            return true
        }
    }

