import SwiftUI

struct GradientIconView: View {
    var icon: String = "envelope.fill"
    var gradient: [Color] = [Color(#colorLiteral(red: 1, green: 0.09282856435, blue: 0.197771579, alpha: 1)), Color(#colorLiteral(red: 0.5639843345, green: 0.8067114949, blue: 1, alpha: 1))]

    var body: some View {
        ZStack {
            Image(systemName: icon)
                .frame(width: 36, height: 36, alignment: .center)
                .background(
                    LinearGradient(gradient: Gradient(colors: gradient), startPoint: .topLeading, endPoint: .bottomTrailing)
                )
                .clipShape(RoundedRectangle(cornerRadius: 12.0))
                .foregroundStyle(.white)
        }
    }
}

#Preview {
    GradientIconView()
}
