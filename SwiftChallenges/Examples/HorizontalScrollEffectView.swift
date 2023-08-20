import SwiftUI

struct HorizontalScrollEffectView: View {
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 16) {
                ForEach(0 ..< 20) { item in
                    GeometryReader { geometry in
                        RoundedRectangle(cornerRadius: 30.0, style: .continuous)
                            .fill(LinearGradient(
                                gradient: Gradient(colors: [Color(#colorLiteral(red: 1, green: 0.9679720998, blue: 0, alpha: 1)), Color(#colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1))]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ))
                            .rotation3DEffect(
                                .degrees(geometry.frame(in: .global).minX - 16) / -20,
                                axis: (x: 0.0, y: 1.0, z: 0.0),
                                anchor: .center,
                                anchorZ: 0.0,
                                perspective: 1.0
                            )
                    }
                    .frame(width: 300, height: 300, alignment: .center)
                }
            }
            .padding()
        }
    }
}

#Preview {
    HorizontalScrollEffectView()
}
