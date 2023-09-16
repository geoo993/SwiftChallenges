import SwiftUI

struct SecurefieldView: View {
    @State private var password = "my password"
    
    var body: some View {
        VStack(alignment: .leading, spacing: 30) {
            VStack(alignment: .leading) {
                Text("Email").bold()
                Text("@gmail.com")
            }
            
            VStack(alignment: .leading) {
                Text("Password").bold()
                SecureField("Password", text: $password)
                    .textContentType(.password)
            }
        }
        .padding()
    }
}

#Preview {
    SecurefieldView()
}
