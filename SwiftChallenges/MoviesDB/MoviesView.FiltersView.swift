import SwiftUI
import SCDomain
import ComposableArchitecture

extension MoviesView {
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
