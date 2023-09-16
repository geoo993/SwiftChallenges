import SwiftUI

struct SFSymbolImageView: View {
    @State var isTapped = false
    
    var body: some View {
        // Pulse
//        Image(systemName: "ellipsis")
//            .symbolEffect(.pulse)
        
        // Iterative reverse
//        HStack(spacing: 30) {
//            // ellipsis
//            Image(systemName: "wand.and.rays")
//                .symbolEffect(.variableColor.iterative.reversing)
//        }
//        .font(.largeTitle)
        
        // Bounce
//        Image(systemName: "bell")
//            .symbolEffect(.bounce, value: isTapped)
//            .onTapGesture {
//                isTapped.toggle()
//            }
        
        // Scale down
//        Image(systemName: "magnifyingglass")
//            .foregroundStyle(.primary, .blue)
//            .symbolEffect(.bounce, options: .speed(2).repeat(2), value: isTapped)
//            .symbolEffect(.scale.up, isActive: isTapped)
//            .onTapGesture {
//                isTapped.toggle()
//            }
        
        // Repeat
        Image(systemName: isTapped ? "pause.fill" : "play.fill")
            .contentTransition(.symbolEffect(.replace))
            .onTapGesture {
                isTapped.toggle()
            }
    }
}

#Preview {
    SFSymbolImageView()
}
