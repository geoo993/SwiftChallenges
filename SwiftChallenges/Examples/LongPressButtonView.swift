import SwiftUI

struct LongPressButtonView: View {
    @GestureState var press = false
    @State var show = false
    
    var body: some View {
        Image(systemName: "camera.fill")
            .foregroundStyle(.white)
            .frame(width: 60, height: 60)
            .background(show ? Color.black : Color.pink)
            .mask(Circle())
            .scaleEffect(press ? 2 : 1)
            .animation(.spring(response: 0.4, dampingFraction: 0.6), value: press)
            .gesture(
                LongPressGesture(minimumDuration: 0.5)
                    .updating($press) { currentState, gestureState, transition in
                        gestureState = currentState
                    }
                    .onEnded({ value in
                        show.toggle()
                    })
            )
    }
}

#Preview {
    LongPressButtonView()
}
