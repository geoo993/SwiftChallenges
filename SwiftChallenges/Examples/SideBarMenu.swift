import SwiftUI

struct SideBarMenu: View {
    var body: some View {
        NavigationView {
            List {
                NavigationLink {
                    MenuView(title: "Books")
                } label: {
                    Label(
                        title: { Text("Books") },
                        icon: { Image(systemName: "book") }
                    )
                }
                NavigationLink {
                    MenuView(title: "Comedy")
                } label: {
                    Label(
                        title: { Text("Comedy") },
                        icon: { Image(systemName: "person") }
                    )
                }
            }
            .navigationTitle("Kick it")
            MenuView(title: "Comedy")
        }
    }
}

#Preview {
    SideBarMenu()
}

struct MenuView: View {
    let title: String
    
    var body: some View {
        Text(title)
            .navigationTitle(title)
    }
}
