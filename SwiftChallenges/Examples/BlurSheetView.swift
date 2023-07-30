import SwiftUI
import Foundation

struct BlurSheetView: View {
    var body: some View {
        ZStack {
            Rectangle()
                .fill(Color.pink)
                .padding()
            VisualEffectBlur(blurStyle: .systemMaterial)
                .ignoresSafeArea()
            VStack {
                VStack {
                    Text("Hello, World!")
                        .bold()
                }
                .frame(width: 300, height: 100)
                .background(.white)
                .clipShape(RoundedRectangle(cornerRadius: 25, style: .continuous))
                Spacer()
            }
        }
    }
}

#Preview {
    BlurSheetView()
}
