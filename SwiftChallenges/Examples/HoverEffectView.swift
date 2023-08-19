import SwiftUI

struct HoverEffectView: View {
    @State var isHover = false
    
    var body: some View {
        VStack {
            Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                Text("Hover, Effect!")
            })
            .padding()
            .contentShape(RoundedRectangle(cornerRadius: 25.0))
            .hoverEffect(.lift)
            
            Text("Hover, Effect!")
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 10.0)
                    .trim(from: isHover ? 0 : 1, to: 1)
                    .stroke(lineWidth: 1.0)
            )
            .contentShape(RoundedRectangle(cornerRadius: 25.0))
            .scaleEffect(isHover ? 1.2 : 1.0)
            .onHover(perform: { hovering in
                withAnimation(.spring(response: 0.4, dampingFraction: 0.6)) {
                    self.isHover = hovering
                }
            })
        }
    }
}

#Preview {
    HoverEffectView()
}
