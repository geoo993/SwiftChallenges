import SwiftUI

struct AppStorageView: View {
    @AppStorage("themePref") var themePreference = "dark"
    @State var isDarkTheme = true
    
    var body: some View {
        VStack {
            Text("Theme: \(themePreference)")
                .padding()
            GradientButtonView(title: "Change Theme")
                .onTapGesture {
                    isDarkTheme.toggle()
                    themePreference = isDarkTheme ? "dark" : "light"
                }
        }
    }
}

#Preview {
    AppStorageView()
}
