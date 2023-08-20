import SwiftUI

struct GradientButtonView: View {
    var title: String = "Text me"
    var gradient: [Color] = [Color(#colorLiteral(red: 1, green: 0.09282856435, blue: 0.197771579, alpha: 1)), Color(#colorLiteral(red: 0.5639843345, green: 0.8067114949, blue: 1, alpha: 1))]

    var body: some View {
        VStack {
            VStack {
                Text(title)
                    .font(.headline)
            }
            .frame(width: 330, height: 50, alignment: .center)
            .background(
                LinearGradient(gradient: Gradient(colors: gradient), startPoint: .topLeading, endPoint: .bottomTrailing)
            )
            .clipShape(RoundedRectangle(cornerRadius: 16.0))
            .foregroundStyle(.white)
        }
    }
}

#Preview {
    GradientButtonView()
}
