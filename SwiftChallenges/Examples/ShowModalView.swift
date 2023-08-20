import SwiftUI

struct ShowModalView: View {
    @State var showModal = false
    
    var body: some View {
        Text("Show Modal")
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 25)
                    .fill(Color.red)
            )
            .fullScreenCover(isPresented: $showModal, content: {
                ModalView(presented: $showModal)
            })
            .onTapGesture {
                showModal.toggle()
            }
    }
}

struct ModalView: View {
    @Binding var presented: Bool
    
    var body: some View {
        Text("Close Modal")
            .onTapGesture {
                presented.toggle()
            }
    }
}

#Preview {
    ShowModalView()
}
