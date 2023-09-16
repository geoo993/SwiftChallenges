import SwiftUI

struct ListSeperatorView: View {
    @State var fruits = Fruit.allCases
    
    var body: some View {
        List(fruits) {
            Text($0.rawValue)
                .listRowSeparatorTint(.orange)
        }
    }
}

#Preview {
    ListSeperatorView()
}
