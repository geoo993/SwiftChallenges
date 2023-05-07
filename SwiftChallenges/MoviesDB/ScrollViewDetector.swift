import ComposableArchitecture
import SwiftUI

struct ScrollViewDetector: UIViewRepresentable {
    @State var viewStore: ViewStoreOf<MoviesDB>

    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self, viewStore: $viewStore)
    }
    
    func makeUIView(context: Context) -> UIView {
        UIView()
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        DispatchQueue.main.async {
            if let scrollView = uiView.superview?.superview?.superview as? UIScrollView {
                scrollView.decelerationRate = viewStore.carouselMode ? .fast : .normal
                scrollView.delegate = context.coordinator
            }
        }
    }
    
    class Coordinator: NSObject, UIScrollViewDelegate {
        @Binding var viewStore: ViewStoreOf<MoviesDB>
        private var parent: ScrollViewDetector
        private var velocityY: CGFloat = 0
        
        init(parent: ScrollViewDetector, viewStore: Binding<ViewStoreOf<MoviesDB>>) {
            self.parent = parent
            self._viewStore = viewStore
        }
        
        func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
            let targetEnd: CGFloat = scrollView.contentOffset.y + velocityY
            let index = max(
                min(
                    (targetEnd / (Constants.cardHeight + Constants.cardSpacing)).rounded(),
                    CGFloat(viewStore.totalMovies - 1)
                ),
                0.0
            )
            viewStore.send(.willDisplayNextRow(atIndex: Int(index)))
        }
        
        func scrollViewWillEndDragging(
            _ scrollView: UIScrollView,
            withVelocity velocity: CGPoint,
            targetContentOffset: UnsafeMutablePointer<CGPoint>
        ) {
            velocityY = velocity.y
            guard viewStore.carouselMode else { return }
            let targetEnd: CGFloat = scrollView.contentOffset.y + (velocity.y)
            let index = (targetEnd / (Constants.cardHeight + Constants.cardSpacing)).rounded()
            let modifiedEnd = Constants.cardHeight * index
            let spacing = Constants.cardSpacing * index
            targetContentOffset.pointee.y = modifiedEnd + spacing
        }
        
        func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
            guard viewStore.carouselMode else { return }
            let targetEnd: CGFloat = scrollView.contentOffset.y + (velocityY)
            let index = max(
                min(
                    (targetEnd / (Constants.cardHeight + Constants.cardSpacing)).rounded(),
                    CGFloat(viewStore.totalMovies - 1)
                ),
                0.0
            )
            let modifiedEnd = Constants.cardHeight * index
            let spacing = Constants.cardSpacing * index
            scrollView.setContentOffset(.init(x: 0, y: modifiedEnd + spacing), animated: true)
        }
    }
}
