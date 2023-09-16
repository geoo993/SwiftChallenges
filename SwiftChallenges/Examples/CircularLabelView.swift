import SwiftUI

struct CircularLabelView: View {
    private var text = "Latidude 35.02663 E • Longitude 23.41264 W • Elevation 64M • Incline 12 •".uppercased()

    var body: some View {
        ZStack {
            ForEach(Array(text.enumerated()), id: \.offset) { index, letter in
                VStack {
                    Text(String(letter))
                    Spacer()
                }
                .rotationEffect(.degrees(4.9 * Double(index)))
            }
        }
        .frame(width: 300, height: 300)
        .font(.system(size: 13, design: .monospaced)).bold()
    }
}

#Preview {
    CircularLabelView()
}
