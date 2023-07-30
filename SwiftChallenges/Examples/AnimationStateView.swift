import SwiftUI

struct AnimationStateView: View {
    @State var show = false
    
    var body: some View {
        VStack {
            Text("View more")
                .bold()
                .foregroundColor(.white)
        }
        .frame(
            width: show ? 320 : 300,
            height: show ? 500 : 50
        )
        .background(Color.pink)
        .cornerRadius(30)
        .shadow(color: Color.pink.opacity(0.3), radius: 20)
        .onTapGesture {
            withAnimation(.spring(duration: 0.3)) {
                show.toggle()
            }
        }
    }
}

#Preview {
    AnimationStateView()
}
