import SwiftUI

struct MaskView: View {
    var body: some View {
        ZStack {
            Color.pink.ignoresSafeArea()
            VStack {
                ForEach(0..<5) { item in
                    Text("Hello, World!")
                        .font(.title3).bold()
                        .padding(.vertical)
                        .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: .leading)
                    Divider()
                }
            }
            .frame(height: 300, alignment: .top)
            .padding()
            .background(Color.white)
            .mask(LinearGradient(
                gradient: Gradient(colors: [
                    Color.red, Color.red, Color.red, Color.blue.opacity(0.0)]),
                startPoint: .top,
                endPoint: .bottom
            ))
            .cornerRadius(20)
            .padding()
        }
    }
}

#Preview {
    MaskView()
}
