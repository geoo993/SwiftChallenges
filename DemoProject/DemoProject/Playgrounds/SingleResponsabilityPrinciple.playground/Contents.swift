
// Journal has one responsibility which is to handle entries
struct Journal {
    private let title: String
    var entries: [String]
    init(title: String) {
        self.title = title
        self.entries = []
    }
    
    mutating func addEntry(entry: String) {
        entries.append(entry)
        print(entries)
    }
    
    /*
    // adding another concern (a concern called persistance) to journal entries which violates the SRP,
    // to fix this what we should do is do something called sepeartion of concerns.
    func save(fileName: String) {
        for entry in entries {
            print("Saving entry: \(entry) in \(fileName)")
        }
    }
    */
}

// How we fix our sepeartion of concerns
struct PersistanceManager {
    // this is a more robust or more reliable way of actually implementing persistance with journal
    // because what is as your PersistanceManager grows you have all the persistance code in a
    // single place.
    func save(journal: Journal, fileName: String) {
        for entry in journal.entries {
            print("Saving entry: \(entry) in \(fileName)")
        }
    }
}

var journal = Journal(title: "Dear Diary")
journal.addEntry(entry: "I ate a bug")
journal.addEntry(entry: "I cried today")

let pm = PersistanceManager()
pm.save(journal: journal, fileName: "dairy.txt")
