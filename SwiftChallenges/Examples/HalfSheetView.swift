import SwiftUI

struct HalfSheetView: View {
    @State var showMenu = false

    var body: some View {
        Button("Show menu!") {
            showMenu.toggle()
        }
        .sheet(isPresented: $showMenu, content: {
            Text("Hello")
                .presentationDetents([.medium, .large, .fraction(200)])
        })
    }
}

#Preview {
    HalfSheetView()
}
