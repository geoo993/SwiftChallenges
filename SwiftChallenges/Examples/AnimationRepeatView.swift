import SwiftUI

struct AnimationRepeatView: View {
    @State var appear = false
    
    var body: some View {
        Circle()
            .trim(from: 0.2, to: 1.0)
            .stroke(Color.blue, style: StrokeStyle(lineWidth: 5, lineCap: .round, lineJoin: .round))
            .frame(width: 44, height: 44)
            .rotationEffect(Angle(degrees: appear ? 360 : 0))
            .animation(.linear(duration: 2).repeatForever(autoreverses: false).speed(2)
            ,value: appear)
            .onAppear {
                appear = true
            }
    }
}

#Preview {
    AnimationRepeatView()
}
