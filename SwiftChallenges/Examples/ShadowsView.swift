import SwiftUI

struct ShadowsView: View {
    var body: some View {
        VStack {
            Text("Hello, World!")
                .font(.largeTitle).bold()
                .foregroundColor(.white)
                .shadow(radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
        }
        .frame(width: 300, height: 500)
        .background(Color.pink)
        .cornerRadius(30)
        .shadow(color: Color.pink.opacity(0.3), radius: 20, x: 0.0, y: 10.0)
        .shadow(color: Color.pink.opacity(0.2), radius: 5, x: /*@START_MENU_TOKEN@*/0.0/*@END_MENU_TOKEN@*/, y: 2.0)
    }
}

#Preview {
    ShadowsView()
}
