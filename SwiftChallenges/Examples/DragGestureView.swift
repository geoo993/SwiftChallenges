import SwiftUI

struct DragGestureView: View {
    @State var viewStage = CGSize.zero
    
    var body: some View {
        RoundedRectangle(cornerRadius: 25.0, style: .continuous)
            .fill(Color.pink)
            .frame(width: 200, height: 240)
            .offset(viewStage)
            .animation(.spring(response: 0.4, dampingFraction: 0.6), value: viewStage)
            .gesture(
                DragGesture()
                    .onChanged({ value in
                        viewStage = value.translation
                    })
                    .onEnded { _ in
                        viewStage = .zero
                    }
            )
    }
}

#Preview {
    DragGestureView()
}
