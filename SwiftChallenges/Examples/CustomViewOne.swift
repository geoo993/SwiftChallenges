import SwiftUI

struct CustomViewOne: View {
    var body: some View {
        VStack(alignment: .center, spacing: 8.0) {
            Circle()
                .frame(width: 44.0, height: 44.0)
            Text("SwiftUI for iOS 14")
                .font(.title)
                .fontWeight(.bold)
            Text("20 videos").bold()
        }
        .padding(.all)
        .background(Color.blue)
        .cornerRadius(20.0)
    }
}

#Preview {
    CustomViewOne()
}
