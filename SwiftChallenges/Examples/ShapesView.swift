import SwiftUI

struct ShapesView: View {
    var body: some View {
        ZStack {
            Rectangle()
                .fill(Color.blue).ignoresSafeArea()
            VStack {
                Circle()
                    .stroke(Color.blue, lineWidth: 2)
                    .frame(width: 44, height: 44)
                Ellipse()
                    .stroke(Color.blue, lineWidth: 2)
                    .frame(width: 44, height: 50)
                Text("Hello, World!").bold()
                RoundedRectangle(cornerRadius: 25.0, style: /*@START_MENU_TOKEN@*/.continuous/*@END_MENU_TOKEN@*/)
                    .foregroundColor(.green)
                    .frame(height: 44)
                    .overlay(Text("Sign up"))
                Capsule(style: .circular)
                    .foregroundColor(.orange)
                    .frame(height: 44)
                    .overlay(Text("Sign up"))
            }
            .padding()
            .background(Color.white)
            .clipShape(
                RoundedRectangle(cornerRadius: 25.0, style: /*@START_MENU_TOKEN@*/.continuous/*@END_MENU_TOKEN@*/)
            )
            .padding()
        }
    }
}

#Preview {
    ShapesView()
}
