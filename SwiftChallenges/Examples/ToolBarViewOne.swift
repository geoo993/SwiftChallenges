import SwiftUI

struct ToolBarViewOne: View {
    var body: some View {
        NavigationView {
            Text("Hello, World!")
                .toolbar{
                    ToolbarItemGroup(placement: .bottomBar) {
                        Image(systemName: "person")
                        Spacer()
                        Image(systemName: "ellipsis")
                        Spacer()
                        Image(systemName: "trash")
                        Spacer()
                        Image(systemName: "arrow.up")
                            .frame(width: 32, height: 32)
                            .background(Color.blue)
                            .mask(Circle())
                    }
                }
        }
    }
}

#Preview {
    ToolBarViewOne()
}
