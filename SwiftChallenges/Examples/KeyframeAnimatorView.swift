import SwiftUI

struct KeyframeAnimatorView: View {
    @State var isTapped = false
    
    struct AnimationValues {
        var position = CGPoint(x: 0, y: 0)
        var scale = 1.0
    }
    
    var body: some View {
        Circle()
            .frame(width: 200)
            .keyframeAnimator(initialValue: AnimationValues(), trigger: isTapped) { content, value in
                content.offset(x: value.position.x, y: value.position.y)
                    .scaleEffect(value.scale)
            } keyframes: { value in
                KeyframeTrack(\.scale) {
                    CubicKeyframe(1.5, duration: 0.5)
                    CubicKeyframe(1, duration: 0.5)
                }
                KeyframeTrack(\.position) {
                    SpringKeyframe(CGPoint(x: 100, y: -100), duration: 0.5, spring: .bouncy)
                    CubicKeyframe(CGPoint(x: 400, y: 1000), duration: 0.5)
                    CubicKeyframe(CGPoint(x: 0, y: 0), duration: 0.5)
                }
            }
            .onTapGesture {
                isTapped.toggle()
            }
    }
}

#Preview {
    KeyframeAnimatorView()
}
