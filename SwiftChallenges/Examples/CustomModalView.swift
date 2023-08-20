import SwiftUI

struct CustomModalView: View {
    @State private var showModal = true

    var body: some View {
        ZStack {
            GradientButtonView(title: "Log in")
                .onTapGesture {
                    showModal = true
                }
            if showModal {
                Rectangle()
                    .foregroundColor(.black.opacity(0.25))
                    .ignoresSafeArea()
                    .onTapGesture {
                        showModal = false
                    }
                LogginView()
                    .onTapGesture {
                        hideKeyboard()
                    }
            }
        }
        .animation(.spring(response: 0.4, dampingFraction: 0.6), value: showModal)
    }
}

#Preview {
    CustomModalView()
}
