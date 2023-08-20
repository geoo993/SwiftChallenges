import SwiftUI

struct LinkOnTextView: View {
    
    var body: some View {
        VStack {
            Text("Go to github page")
                .foregroundStyle(.indigo)
                .onTapGesture {
                    UIApplication.shared.open(URL(string: "https://github.com/geoo993")!)
                }
            
            HStack(spacing: 4) {
                Text("You agree to my")
                Text("LinkedIn")
                    .foregroundStyle(.blue)
                    .onTapGesture {
                        UIApplication.shared.open(URL(string: "https://www.linkedin.com/in/geoo993/")!)
                    }
                Text("and")
                Text("Twitter")
                    .foregroundStyle(.blue)
                    .onTapGesture {
                        UIApplication.shared.open(URL(string: "https://twitter.com/Geoo993")!)
                    }
            }
        }
    }
}

#Preview {
    LinkOnTextView()
}
