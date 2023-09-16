import SwiftUI

struct FruitRow: View {
    var fruit: Fruit
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(fruit.name)
                .font(.title2)
                .bold()
            Text(fruit.details)
                .foregroundStyle(.gray)
                .lineLimit(2)
        }
    }
}

struct ListSwipeView: View {
    var fruits = Fruit.allCases
    
    var body: some View {
        List(fruits) {
            FruitRow(fruit: $0)
                .swipeActions(edge: .trailing) {
                    Button{
                        print("row deleted")
                    } label: {
                        Label("Delete", systemImage: "trash")
                    }
                }
                .tint(.red)
        }
    }
}

#Preview {
    ListSwipeView()
}
