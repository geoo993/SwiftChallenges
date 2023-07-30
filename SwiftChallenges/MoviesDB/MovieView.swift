import SwiftUI
import SCDomain

struct MovieView: View {
    @Binding var showMovie: Bool 
    var animation: Namespace.ID
    let movie: Movie
    
    @State private var animateContent = false
    @State private var offsetAnimation = false
    
    var body: some View {
        VStack(spacing: 15) {
            Button(action: {
                withAnimation(.easeIn(duration: 0.2)) {
                    offsetAnimation = false
                }
                
                withAnimation(.easeIn(duration: 0.35).delay(0.1)) {
                    animateContent = false
                    showMovie = false
                }
            }, label: {
                Image(systemName: "chevron.left")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundStyle(.black)
                    .contentShape(Rectangle())
            })
            .padding([.leading, .vertical], Constants.padding)
            .frame(maxWidth: .infinity, alignment: .leading)
            .opacity(animateContent ? 1.0 : 0.0)
            
            GeometryReader {
                let size = $0.size
                HStack(spacing: Constants.vertSpacing) {
                    ImageView(
                        url: movie.poster,
                        width: (size.width - (Constants.padding * 2.0)) / 2.0,
                        height: size.height
                    )
                    .clipShape(CustomCorners(corners: [.topRight, .bottomRight], radius: Constants.cornerRadius))
                    .matchedGeometryEffect(id: movie.id, in: animation)
                    
                    VStack(alignment: .leading, spacing: Constants.smallSpacing) {
                        Text(movie.title)
                            .font(.title3)
                            .fontWeight(.semibold)
                        
                        Text(movie.genres.map(\.rawValue).joined(separator: ", "))
                            .font(.caption)
                            .foregroundColor(.gray)
                        Spacer()
                    }
                    .padding(Constants.padding)
                    .offset(y: offsetAnimation ? 0 : 100.0)
                    .opacity(offsetAnimation ? 1.0 : 0.0)
                }
            }
            .frame(height: Constants.cardHeight)
            .zIndex(1.0)
            
            Rectangle()
                .fill(.gray.opacity(0.04))
                .ignoresSafeArea()
                .overlay(alignment: .top) {
                    Details()
                }
                .padding(.top, -180)
                .zIndex(0)
                .opacity(animateContent ? 1.0 : 0.0)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .background(
            Rectangle()
                .fill(.white)
                .ignoresSafeArea()
                .opacity(animateContent ? 1.0 : 0.0)
        )
        .onAppear {
            withAnimation(.easeInOut(duration: 0.35)) {
                animateContent = true
            }
            
            withAnimation(.easeInOut(duration: 0.35).delay(0.1)) {
                offsetAnimation = true
            }
        }
    }
    
    @ViewBuilder
    func Details() -> some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(alignment: .leading, spacing: Constants.spacing) {
                Divider().padding(.top, 25)
                Text("About the movie")
                    .font(.title2)
                    .fontWeight(.semibold)
                Text(movie.overview)
                    .foregroundStyle(.gray)
            }
            .padding(Constants.padding)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.top, 180)
        .offset(y: offsetAnimation ? 0.0 : 50)
        .opacity(offsetAnimation ? 1.0 : 0.0)
    }
}

#Preview {
    MovieView(
        showMovie: Binding<Bool>.constant(false),
        animation: Namespace().wrappedValue,
        movie: .fixture()
    )
}
