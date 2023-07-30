import SwiftUI

struct AnimatableButtonView: View {
    @State var tap = false
    
    var body: some View {
        VStack {
            Text("View more")
                .font(.title2)
                .bold()
                .foregroundStyle(.white)
        }
        .frame(width: 250, height: 250)
        .background(LinearGradient(gradient: Gradient(colors: [Color.pink, Color.blue]), startPoint: .topLeading, endPoint: .bottomTrailing))
            .mask(RoundedRectangle(cornerRadius: 30, style: .continuous))
            .shadow(
                color: Color.pink.opacity(tap ? 0.2 : 0.4),
                radius: tap ? 10 : 15,
                x: 0.0,
                y: tap ? 5.0 : 10
            )
            .scaleEffect(tap ? 0.8 : 1)
            .animation(.spring(response: 0.4, dampingFraction: 0.6), value: tap)
            .onTapGesture {
                tap = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    tap = false
                }
            }
    }
}

#Preview {
    AnimatableButtonView()
}
