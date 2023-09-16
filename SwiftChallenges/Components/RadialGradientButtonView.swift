import SwiftUI

struct RadialGradientButtonView: View {
    @State var appear = false
    
    var body: some View {
        RoundedRectangle(cornerRadius: 30)
            .frame(width: 64, height: 44)
            .foregroundStyle(
                .linearGradient(colors: [Color(#colorLiteral(red: 0.3408924341, green: 0.3429200053, blue: 0.3997989893, alpha: 1)), Color(#colorLiteral(red: 0.02498620935, green: 0.04610963911, blue: 0.08353561908, alpha: 1))], startPoint: .topLeading, endPoint: .bottomTrailing)
                .shadow(.inner(color: .white.opacity(0.2), radius: 0, x: 1, y: 1))
                .shadow(.inner(color: .white.opacity(0.05), radius: 4, x: 0, y: -4))
                .shadow(.drop(color: .black.opacity(0.5), radius: 30, y: 30))
            )
            .overlay(RoundedRectangle(cornerRadius: 30).stroke(.black, lineWidth: 1))
            .overlay(Image(systemName: "circle").foregroundStyle(.white))
            .background(
                ZStack {
                    AngularGradient(colors: [.red, .blue, .teal, .red], center: .center, angle: .degrees(appear ? 360 : 0))
                        .cornerRadius(30)
                        .blur(radius: 15)
                    AngularGradient(colors: [.white, .blue, .teal, .white], center: .center, angle: .degrees(appear ? 360 : 0))
                        .cornerRadius(30)
                        .blur(radius: 15)
                }
            )
            .onAppear {
                withAnimation(.linear(duration: 2).repeatForever(autoreverses: false)) {
                    appear = true
                }
            }
    }
}

#Preview {
    RadialGradientButtonView()
}
