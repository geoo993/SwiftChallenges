import SwiftUI

struct CustomFontsView: View {
    var body: some View {
        VStack {
            Text("Layout")
                .font(.custom("Nunito-Bold", size: 34))
            Text("A consistent layout that adapts to various contexts makes your experience more approachable and helps people enjoy their favorite apps and games on all their devices."
            )
            .font(.custom("Nunito-SemiBold", size: 22))
            .multilineTextAlignment(.center)
        }.padding()
    }
}

#Preview {
    CustomFontsView()
}
