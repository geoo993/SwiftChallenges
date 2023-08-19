import SwiftUI

struct ColorPickerView: View {
    @State var color = Color.blue
    @State var color2 = Color.purple
    
    var body: some View {
        VStack{
            ColorPicker("Colors", selection: $color)
            ColorPicker("Colors", selection: $color2, supportsOpacity: false)
            RoundedRectangle(cornerRadius: 25.0)
                .fill(
                    LinearGradient(
                        colors: [color, color2],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .padding([.top])
        }
        .padding()
    }
}

#Preview {
    ColorPickerView()
}
