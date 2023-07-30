import SwiftUI
import SCDomain

extension MoviesView {
    struct CardView: View {
        var animation: Namespace.ID
        @Binding var showDetailView: Bool
        @Binding var selectedMovie: Movie?
        @Binding var animateCurrentMovie: Bool
        let movie: Movie
        
        var body: some View {
            GeometryReader {
                let size = $0.size
                let rect = $0.frame(in: .named(Constants.scrollviewSpace))
                
                HStack(spacing: -25) {
                    VStack(alignment: .leading, spacing: Constants.smallSpacing) {
                        Text(movie.title)
                            .font(.title3)
                            .fontWeight(.semibold)
                        
                        Text(movie.overview)
                            .font(.caption)
                            .foregroundColor(.gray)
                        Spacer()
                    }
                    .padding(Constants.padding)
                    .frame(width: size.width / 2, height: size.height * 0.8)
                    .background {
                        RoundedRectangle(cornerRadius: Constants.cornerRadius, style: .continuous)
                            .fill(.white)
                            .shadow(color: .black.opacity(0.08), radius: 8, x: 5, y: 5)
                            .shadow(color: .black.opacity(0.08), radius: 8, x: -5, y: -5)
                    }
                    .zIndex(1)
                    .offset(x: animateCurrentMovie && selectedMovie?.id == movie.id ? -20 : 0)
                    
                    ZStack {
                        if !(showDetailView && selectedMovie?.id == movie.id) {
                            ImageView(url: movie.poster, width: size.width / 2, height: size.height)
                                .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                                .matchedGeometryEffect(id: movie.id, in: animation)
                                .shadow(color: .black.opacity(0.1), radius: 5, x: 5, y: 5)
                                .shadow(color: .black.opacity(0.1), radius: 5, x: -5, y: -5)
                        }
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
}
