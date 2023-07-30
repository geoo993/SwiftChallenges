
// How to work with safe area guide
// https://developer.apple.com/design/human-interface-guidelines/layout

import SwiftUI

struct SafeAreaContent: View {
    
    // applying backgroung + your content
    var body: some View {
        ZStack {
            Color.blue.ignoresSafeArea()
            Image(systemName: "xmark")
                .frame(width: 32, height: 32)
                .background(Circle().stroke())
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
                .padding()
            VStack {
                Text("Content Layout")
            }
            .frame(width: 300, height: 200, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
            .background(Color.white)
            .clipShape(
                RoundedRectangle(cornerRadius: /*@START_MENU_TOKEN@*/25.0/*@END_MENU_TOKEN@*/)
            )
        }
    }
}

#Preview {
    SafeAreaContent()
}
