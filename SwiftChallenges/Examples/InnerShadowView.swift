import SwiftUI

struct InnerShadowView: View {
    var body: some View {
        ZStack {
            Rectangle()
                .fill(
                    .radialGradient(
                        colors: [Color(#colorLiteral(red: 0.1963141561, green: 0.2082518637, blue: 0.4679170251, alpha: 1)), .black],
                        center: .center,
                        startRadius: 1,
                        endRadius: 400
                    )
                )
                .ignoresSafeArea()
            
            Circle()
                .foregroundStyle(
                    .linearGradient(
                        colors: [.black.opacity(0.5), .black.opacity(0.0)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                    .shadow(
                        .inner(color: .white.opacity(0.5), radius: 0, x: 1, y: 1)
                    )
                    .shadow(.drop(radius: 5, x: -10, y: -10))
                )
                .padding(40)
            VStack {
                Image(systemName: "aqi.medium")
                Text("Inner")
            }
            .font(.system(size: 70))
            .foregroundStyle(.blue.gradient
                .shadow(
                    .inner(color: .white.opacity(0.3), radius: 3, x: 1, y: 1)
                )
                    .shadow(.drop(radius: 5, x: 5, y: 5))
            )
        }
    }
}

#Preview {
    InnerShadowView()
}
