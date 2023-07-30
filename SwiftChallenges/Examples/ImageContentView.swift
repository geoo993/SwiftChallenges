import SwiftUI

struct ImageContentView: View {
    var body: some View {
        VStack {
            Image("Illustration")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 200, height: 200, alignment: .center)
            Image("Illustration")
                .resizable(resizingMode: .tile)
                .aspectRatio(contentMode: .fit)
        }
    }
}

#Preview {
    ImageContentView()
}
