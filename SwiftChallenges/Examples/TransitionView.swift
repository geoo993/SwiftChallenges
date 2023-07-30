import SwiftUI

struct TransitionView: View {
    @State var show = false
    
    var body: some View {
        ZStack {
            Text("View transition")
                .bold()
                .padding()
                .background(Capsule().stroke())
                .foregroundColor(.blue)
            SlideView(show: $show)
        }
        .onTapGesture {
            withAnimation(.spring(duration: 0.3)) {
                show.toggle()
            }
        }
    }
}

private struct SlideView: View {
    @Binding var show: Bool
    
    var body: some View {
        if show {
            RoundedRectangle(cornerRadius: 25.0)
                .fill(Color.blue)
                .padding()
                .transition(.move(edge: .bottom))
                .zIndex(1)
        }
    }
}

#Preview {
    TransitionView()
}
