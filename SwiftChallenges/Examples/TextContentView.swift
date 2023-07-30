import SwiftUI

struct TextContentView: View {
    var body: some View {
        Text("Hello, World!")
            .font(.title)
            .fontWeight(.semibold)
            .italic()
        
        Text("Platform considerations")
            .font(.system(size: 25, weight: .heavy, design: .monospaced))
        
        Text("A consistent layout that adapts to various contexts makes your experience more approachable and helps people enjoy their favorite apps and games on all their devices.")
            .font(.system(size: 18, weight: .regular, design: .rounded))
            .foregroundColor(Color.gray)
            .frame(width: 300, alignment: .leading)
            .multilineTextAlignment(.center)
            .lineLimit(3)
            .lineSpacing(8)
    }
}

#Preview {
    TextContentView()
}
