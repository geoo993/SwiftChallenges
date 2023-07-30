import SwiftUI

struct ColorsView: View {
    var body: some View {
        VStack {
            Text("Color literal")
                .font(.title).bold()
                .foregroundColor(
                    Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1))
                )
        }
        .frame(width: 300, height: 200)
        .background(Image(uiImage: #imageLiteral(resourceName: "gradienta-LeG68PrXA6Y-unsplash")).resizable().aspectRatio(contentMode: .fill))
        .cornerRadius(20)
    }
}

#Preview {
    ColorsView()
}
