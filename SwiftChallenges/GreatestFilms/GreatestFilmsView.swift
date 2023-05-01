import SwiftUI

struct GreatestFilmsView: View {
    @StateObject var viewModel: GreatestFilmsViewModel
    
    var body: some View {
        List(viewModel.movies) { value in
            HStack(spacing: 8) {
                AsyncImage(
                    url: value.poster,
                    content: { image in
                        image.resizable()
                            .frame(width: 90, height: 140)
                    },
                    placeholder: {
                        ProgressView()
                    }
                )
                VStack(alignment: .leading, spacing: 8) {
                    Text(value.title)
                        .bold()
                        .font(.subheadline)
                        .foregroundColor(.primary)
                        .padding(.top)
                    Text(value.overview)
                        .font(.caption2)
                        .foregroundColor(.primary)
                    Spacer()
                }
            }
        }
        .task {
            await viewModel.movies()
        }
    }
}

struct GreatestFilmsView_Previews: PreviewProvider {
    static var previews: some View {
        GreatestFilmsView(viewModel: .init())
    }
}
