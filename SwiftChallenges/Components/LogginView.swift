import SwiftUI

struct LogginView: View {
    @State var email = ""
    @State var password = ""
    
    @ViewBuilder
    var body: some View {
        ZStack() {
            VStack(spacing: 16.0) {
                Text("Sign in")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .frame(maxWidth: 335, alignment: .leading)
                
                Text("Invest in 500+ stocks, funds and ETF.")
                    .font(.subheadline)
                    .frame(maxWidth: 335, alignment: .leading)
                    .opacity(0.7)
                
                HStack {
                    GradientIconView()
                    TextField("Email address", text: $email)
                        .foregroundColor(Color(#colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)))
                }
                .padding(8)
                .frame(width: 335, height: 52, alignment: .leading)
                .background(Color.white)
                .cornerRadius(20)
                
                HStack {
                    GradientIconView(icon: "key.fill")
                    SecureField("Password", text: $password)
                        .textContentType(.password)
                        .foregroundColor(Color(#colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)))
                }
                .padding(8)
                .frame(width: 335, height: 52, alignment: .leading)
                .background(Color.white)
                .cornerRadius(20)
                
                GradientButtonView(title: "Sign in")
                
                Rectangle()
                    .frame(maxWidth: 335, maxHeight: 1)
                    .foregroundColor(.black).opacity(0.1)
                
                HStack(spacing: 0) {
                    Text("Don’t have an account? ")
                        .opacity(0.7)
                    Text("Sign up")
                        .fontWeight(.semibold)
                }
                .font(.footnote)
                .frame(maxWidth: 335, alignment: .leading)
                
                HStack(spacing: 0) {
                    Text("Forgot password? ")
                        .opacity(0.7)
                    Text("Reset Password")
                        .fontWeight(.semibold)
                }
                .font(.footnote)
                .frame(maxWidth: 335, alignment: .leading)
                
                HStack(spacing: 0) {
                    Text("Don't have a password yet? ")
                        .opacity(0.7)
                    Text("Set Password")
                        .fontWeight(.semibold)
                }
                .font(.footnote)
                .frame(maxWidth: 335, alignment: .leading)
            }
            .padding(20)
            
        }
        .frame(width: UIScreen.main.bounds.size.width)
        .background(Color.white)
        .cornerRadius(30)
    }
}

#Preview {
    LogginView()
}
