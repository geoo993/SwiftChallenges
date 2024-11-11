import SwiftUI

public extension MoviesScreen {
    struct ContentView: View {
        private let movies: [Movie]
        private let event: (Event) -> Void
        
        public init(movies: [Movie], event: @escaping (Event) -> Void) {
            self.movies = movies
            self.event = event
        }
        
        public var body: some View {
            VStack(spacing: 8) {
                headerView
                ScrollView(.vertical, showsIndicators: true) {
                    ForEach(movies, id: \.id) { movie in
                        Button {
                            event(.didTap(movie))
                        } label: {
                            cardView(movie: movie)
                        }
                    }
                }
                .padding(.horizontal, 16)
                .padding(.top, 8)
                .padding(.bottom, 24)
                
            }
            .onAppear{
                event(.didAppear)
            }
        }
        
        @ViewBuilder
        private var headerView: some View {
            VStack {
                Text("Films")
                    .font(.largeTitle.bold())
                Text("Trending")
                    .fontWeight(.semibold)
                    .padding(.top, 8)
                    .foregroundColor(.gray)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        
        @ViewBuilder
        private func cardView(movie: Movie) -> some View {
            VStack(alignment: .leading, spacing: 8) {
                Text(movie.title)
                    .font(.title3)
                    .fontWeight(.semibold)
                HStack(spacing: 8) {
                    ForEach(movie.genres, id: \.id) { value in
                        Text(value.rawValue)
                            .font(.footnote)
                    }
                    Spacer()
                }
                Text(movie.overview)
                    .font(.caption)
                    .foregroundColor(.gray)
            }
        }
    }
}
