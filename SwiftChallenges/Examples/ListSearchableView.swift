import SwiftUI

struct ListSearchableView: View {
    @State var fruits = Fruit.allCases
    @State var updatedFruits = Fruit.allCases
    @State private var text = ""
    
    var body: some View {
        NavigationStack {
            List(text == "" ? fruits : updatedFruits) { fruit in
                NavigationLink(value: fruit) {
                    Label(fruit.name, systemImage: "fork.knife")
                        .foregroundStyle(.primary)
                }
            }
            .navigationTitle("Searchable")
            .navigationDestination(for: Fruit.self) { fruit in
                Text(fruit.name)
            }
        }
        .searchable(text: $text)
        .onChange(of: text) { _, value in
            updatedFruits = fruits.filter { $0.name.contains(value) }
        }
    }
}

#Preview {
    ListSearchableView()
}
