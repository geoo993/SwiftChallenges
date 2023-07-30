import SwiftUI

struct ClipShapeView: View {
    var body: some View {
        ZStack {
            Color.pink.ignoresSafeArea()
            VStack {
                VStack {
                    Text("Hello, World!")
                        .bold()
                }
                .frame(width: 300, height: 300)
                .background(.white)
                .clipShape(RoundedRectangle(cornerRadius: 25, style: .continuous))
                Spacer()
            }
        }
    }
}

#Preview {
    ClipShapeView()
}
