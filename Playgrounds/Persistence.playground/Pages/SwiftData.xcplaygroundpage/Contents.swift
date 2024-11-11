// https://bugfender.com/blog/swift-data/
// https://www.hackingwithswift.com/quick-start/swiftdata
import Foundation
import SwiftData
import SwiftUI
import PlaygroundSupport


// - CoreData or SwiftData
// It is a powerful framework for managing complex data models and relationships in iOS apps.
// It provides a way to store and retrieve data using a database-like model.


// Before SwiftData can persist the objects in our database, we’ll need to create each object as the model class shown below:
// We then make them SwiftData-compliant by making them @Model objects, which is done by simply adding @Model, as you can see below:

//@Model
struct Post {
    var author: User
    var likes: [Like]
    var title: String
    
    init(author: User, likes: [Like], title: String) {
        self.author = author
        self.likes = likes
        self.title = title
    }
}

//@Model
struct User {
    var username: String
    var follows: [User]
    
    init(username: String, follows: [User]) {
        self.username = username
        self.follows = follows
    }
}

//@Model
struct Like {
    var user: User
    var date: Date
    
    init(user: User, date: Date) {
        self.user = user
        self.date = date
    }
}

struct SwiftDataApp: View {
    var body: some View {
        ContentView()
//            .modelContainer (for: [Post.self, User.self, Like.self])
    }
}

struct ContentView: View {
//    @Environment(\.modelContext) private var modelContext
    var body: some View {
        VStack {
            Text("Hello World")
            Button {
//                modelContext.insert(User(username: "Alex", follows: []))
            } label: {
                Text("Save")
            }
        }
    }
}

PlaygroundPage.current.setLiveView(SwiftDataApp())
print("Swift Data Tutorial")
