import SwiftUI
import Kingfisher

struct ImageView: View {
    let url: URL?
    let width: CGFloat
    let height: CGFloat
    
    var body: some View {
        Unwrap(url) { value in
            KFImage.url(url)
                .placeholder {
                    ProgressView()
                }
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: width, height: height)
        }
    }
}
