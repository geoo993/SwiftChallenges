import SwiftUI
import SCDomain
import ComposableArchitecture

struct MoviesView: View {
    let store: StoreOf<MoviesDB>

    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            VStack(spacing: Constants.spacing) {
                HeaderView(viewStore: viewStore)
                FiltersView(viewStore: viewStore)
                ContentView(viewStore: viewStore)
            }
            .onAppear{
                viewStore.send(.getMovies)
            }
        }
    }
}

extension MoviesView {
    struct HeaderView: View {
        @State var viewStore: ViewStoreOf<MoviesDB>
    
        var body: some View {
            HStack {
                Text("Films")
                    .font(.largeTitle.bold())
                Text("Trending")
                    .fontWeight(.semibold)
                    .padding(.leading, Constants.padding)
                    .foregroundColor(.gray)
                    .offset(y: 2)
                
                Spacer(minLength: Constants.vertSpacing)
                
                Menu {
                    Button("Toggle Carousel Mode \(viewStore.carouselMode ? "On" : "Off" )") {
                        viewStore.send(.toggleCarouselMode)
                    }
                } label: {
                    Image(systemName: "ellipsis")
                        .rotationEffect(.degrees(90))
                        .foregroundColor(.gray)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, Constants.padding)
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
                        CardView(movie: movie)
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

extension MoviesView {
    struct CardView: View {
        @State var movie: Movie
        
        var body: some View {
            GeometryReader {
                let size = $0.size
                let rect = $0.frame(in: .named(Constants.scrollviewSpace))
                
                HStack(spacing: -25) {
                    VStack(alignment: .leading, spacing: 6) {
                        Text(movie.title)
                            .font(.title3)
                            .fontWeight(.semibold)
                        
                        Text(movie.overview)
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                    .padding(Constants.padding)
                    .frame(width: size.width / 2, height: size.height * 0.8)
                    .background {
                        RoundedRectangle(cornerRadius: 10, style: .continuous)
                            .fill(.white)
                            .shadow(color: .black.opacity(0.08), radius: 8, x: 5, y: 5)
                            .shadow(color: .black.opacity(0.08), radius: 8, x: -5, y: -5)
                    }
                    .zIndex(1)
                    
                    ZStack {
                        ImageView(url: movie.poster, width: size.width / 2, height: size.height)
                            .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                            .shadow(color: .black.opacity(0.1), radius: 5, x: 5, y: 5)
                            .shadow(color: .black.opacity(0.1), radius: 5, x: -5, y: -5)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
                .frame(width: size.width)
                .rotation3DEffect(
                    .degrees(convertOffsetToRotation(rect)),
                    axis: (x: 1, y: 0, z: 0),
                    anchor: .bottom,
                    anchorZ: 1,
                    perspective: 0.8
                )
            }
            .frame(height: Constants.cardHeight)
            
        }
        // converting minY to rotation
        private func convertOffsetToRotation(_ rect: CGRect) -> Double {
            let cardHeight = rect.height + 20
            let minY = rect.minY - 20.0
            let progress = minY < 0.0 ? (minY / cardHeight) : 0.0
            let containerProgress = min(-progress, 1.0)
            return containerProgress * 90.0
        }
    }
    
    struct FiltersView: View {
        @State var viewStore: ViewStoreOf<MoviesDB>
        @State private var genres = Genre.allCases
        @Namespace private var animation
        
        var body: some View {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    ForEach(genres, id: \.self) { genre in
                        Text(genre.rawValue)
                            .font(.caption)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 5)
                            .background {
                                if viewStore.activeGenre == genre {
                                    Capsule()
                                        .fill(Color.blue)
                                        .matchedGeometryEffect(id: Constants.filterTags, in: animation)
                                } else {
                                    Capsule()
                                        .fill(Color.gray.opacity(0.2))
                                }
                            }
                            .foregroundColor(viewStore.activeGenre == genre ? .white : .gray)
                            .onTapGesture {
                                _ = withAnimation(.interactiveSpring(response: 0.5, dampingFraction: 0.7, blendDuration: 0.7)) {
                                    viewStore.send(.didSelectGenre(genre))
                                }
                            }
                    }
                }
                .padding(.horizontal, Constants.padding)
            }
        }
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
