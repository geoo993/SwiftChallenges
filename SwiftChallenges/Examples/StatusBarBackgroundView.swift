import SwiftUI

struct StatusBarBackgroundView: View {
    @State private var scrollViewContentOffset: CGFloat = 0
    
    var body: some View {
        ZStack(alignment: .top) {
            Color(.orange).ignoresSafeArea()
            VisualEffectBlur(blurStyle: .systemMaterial)
                .ignoresSafeArea()
            TrackableScrollView.Content(
                .vertical,
                showIndicators: true,
                contentOffset: $scrollViewContentOffset
            ) {
                Text("Hello, World!")
            }
            
            Rectangle()
                .foregroundColor(.white)
                .opacity(scrollViewContentOffset > 16 ? 1 : 0)
                .animation(.easeIn, value: scrollViewContentOffset)
                .ignoresSafeArea()
                .frame(height: 0)
        }
    }
}

#Preview {
    StatusBarBackgroundView()
}
