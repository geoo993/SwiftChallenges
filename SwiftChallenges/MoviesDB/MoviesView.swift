import SwiftUI
import SCDomain
import ComposableArchitecture

struct MoviesView: View {
    let store: StoreOf<MoviesDB>
    @Namespace private var animation
    @State private var showDetailView = false
    @State private var selectedMovie: Movie?
    @State private var animateCurrentMovie = false

    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            VStack(spacing: Constants.spacing) {
                HeaderView(viewStore: viewStore)
                FiltersView(viewStore: viewStore)
                ContentView(viewStore: viewStore)
            }
            .overlay {
                if let selectedMovie, showDetailView {
                    MovieView(
                        showMovie: $showDetailView,
                        animation: animation,
                        movie: selectedMovie
                    ).transition(.asymmetric(insertion: .identity, removal: .offset(y: 5)))
                }
            }
            .onChange(of: showDetailView) { _, value in
                if !value {
                    withAnimation(.easeInOut(duration: 0.15).delay(0.4)) {
                        animateCurrentMovie = false
                    }
                }
            }
            .onAppear{
                viewStore.send(.getMovies)
            }
        }
    }
}

extension MoviesView {
    @ViewBuilder
    func ContentView(viewStore: ViewStoreOf<MoviesDB>) -> some View {
        GeometryReader {
            let size = $0.size
            ScrollView(.vertical, showsIndicators: true) {
                VStack(spacing: Constants.cardSpacing) {
                    ForEach(viewStore.filteredMovies, id: \.id) { movie in
                        CardView(
                            animation: animation,
                            showDetailView: $showDetailView,
                            selectedMovie: $selectedMovie,
                            animateCurrentMovie: $animateCurrentMovie,
                            movie: movie
                        )
                        .onTapGesture {
                            withAnimation(.easeInOut(duration: 0.2)) {
                                animateCurrentMovie = true
                                selectedMovie = movie
                            }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                                withAnimation(.interactiveSpring(response: 0.4, dampingFraction: 0.6, blendDuration: 0.7)) {
                                    showDetailView = true
                                }
                            }
                        }
                    }
                    if viewStore.pagination.isLoading {
                        ProgressView()
                            .frame(maxWidth: .infinity)
                    } else {
                        EmptyView()
                    }
                }
                .padding(.horizontal, Constants.padding)
                .padding(.vertical, Constants.vertSpacing)
                .padding(.bottom, bottomPadding(size))
                .background {
                    ScrollViewDetector(viewStore: viewStore)
                }
            }
            .coordinateSpace(name: Constants.scrollviewSpace)
            .padding(.top, Constants.padding)
        }
    }
        
    private func bottomPadding(_ size: CGSize = .zero) -> CGFloat {
        let scrollViewHeight = size.height
        return scrollViewHeight - Constants.cardHeight - (Constants.vertSpacing * 2) - Constants.padding
    }
}

struct MoviesView_Previews: PreviewProvider {
    static var previews: some View {
        MoviesView(store: .init(
            initialState: .init(movies: .fixture()),
            reducer: MoviesDB())
        )
    }
}
