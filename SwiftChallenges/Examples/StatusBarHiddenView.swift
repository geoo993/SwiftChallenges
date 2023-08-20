import SwiftUI

struct StatusBarHiddenView: View {
    @State var hidden = false
    
    var body: some View {
        Text("Hello, World!")
            .statusBar(hidden: hidden)
            .onTapGesture {
                withAnimation {
                    hidden.toggle()
                }
            }
    }
}

#Preview {
    StatusBarHiddenView()
}
