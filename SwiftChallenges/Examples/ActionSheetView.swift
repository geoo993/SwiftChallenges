import SwiftUI

struct ActionSheetView: View {
    @State private var showActionSheet = false
    
    var body: some View {
        GradientButtonView(title: "Change profile")
            .confirmationDialog(
                "Choose Image",
                isPresented: $showActionSheet,
                actions: {
                    Button("Gallery") {
                        print("picked from gallery")
                    }
                    Button("From Library") {
                        print("picked from library")
                    }
                    Button("Cancel", role: .cancel) {
                        print("User cancelled")
                    }
                }, message: {
                    Text("Select an option")
                }
            )
            .onTapGesture {
                showActionSheet = true
            }
    }
}

#Preview {
    ActionSheetView()
}
