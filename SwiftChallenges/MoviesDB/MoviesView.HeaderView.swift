import SwiftUI
import ComposableArchitecture

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
