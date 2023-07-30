import SwiftUI

struct AnimationTransformView: View {
    @State var show = false
    
    var body: some View {
        ZStack {
            Color.pink.ignoresSafeArea()
                .opacity(0.5)
            RoundedRectangle(cornerRadius: 45)
                .foregroundStyle(.white)
                .frame(width: 260, height: 200)
                .offset(y: 20)
                .shadow(radius: 40)
            RoundedRectangle(cornerRadius: 45)
                .frame(width: 300, height: 200)
                .foregroundStyle(.yellow)
                .offset(y: show ? -200 : 0)
                .scaleEffect(show ? 1.2 : 1)
                .rotationEffect(Angle(degrees: show ? 30 : 0))
                .rotation3DEffect(
                    Angle(degrees: show ? 30 : 0),
                    axis: (x: 1.0, y: 0.0, z: 0.0),
                    anchor: .center,
                    anchorZ: 0.0,
                    perspective: 1.0
                )
                .shadow(radius: 40)
                .onTapGesture {
                    withAnimation {
                        show.toggle()
                    }
                }
        }
    }
}

#Preview {
    AnimationTransformView()
}
