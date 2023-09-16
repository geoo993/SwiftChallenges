import SwiftUI

struct BlendModeView: View {
    @State private var position: CGSize = .zero

    var title: some View {
        Text("The team got beaten like amateur 3 - 1, it was awful")
            .font(.system(size: 48, weight: .heavy).width(.expanded))
            .bold()
            .padding(20)
            .frame(maxWidth: 400)
    }
    
    var body: some View {
        ZStack {
            Image("Wallpaper1")
                .offset(x: position.width, y: position.height)
                .gesture(
                    DragGesture()
                        .onChanged {
                            position = $0.translation
                        }
                        .onEnded {_ in 
                            position = .zero
                        }
                )
            title
                .foregroundStyle(.white)
                .blendMode(.difference)
                .overlay(title.blendMode(.hue))
                .overlay(title.foregroundStyle(.white).blendMode(.overlay))
                .overlay(title.foregroundStyle(.black).blendMode(.overlay))
        }
    }
}

#Preview {
    BlendModeView()
}
