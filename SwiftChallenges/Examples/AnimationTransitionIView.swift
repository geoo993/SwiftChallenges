import SwiftUI

struct AnimationTransitionIView: View {
    @State var show = false
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
                .opacity(show ? 0.5 : 0.2)
                .animation(.linear(duration: 0.8), value: show)
            RoundedRectangle(cornerRadius: 45)
                .foregroundStyle(.pink)
                .frame(height: 300)
                .opacity(show ? 1.0 : 0.5)
                .padding(show ? 16 : 32)
                .offset(y: show ? 0 : 30)
                .animation(.spring(response: 0.4, dampingFraction: 0.6), value: show)
            RoundedRectangle(cornerRadius: 45)
                .frame(height: 300)
                .offset(y: show ? 600 : 0)
                .foregroundStyle(.blue)
                .shadow(radius: 40)
                .padding(16)
                .animation(.timingCurve(0.2, 0.8, 0.2, 1, duration: 0.8), value: show)
        }
        .onTapGesture {
            show.toggle()
        }
    }
}

#Preview {
    AnimationTransitionIView()
}
