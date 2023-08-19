import SwiftUI

struct NavView: View {
    var body: some View {
        NavigationView {
            ScrollView {
                NavigationLink(destination: Text("Hello, World!")) {
                    RoundedRectangle(cornerRadius: 25.0, style: .continuous)
                        .frame(height: 800, alignment: .center)
                        .padding()
                }
            }
            .navigationTitle("Hello")
            .toolbar(content: {
                Link(
                    destination:
                        URL(string: "https://www.apple.com")!
                    ,label: {
                        Image(systemName: "person.crop.circle")
                            .frame(width: 32, height: 32)
                            .foregroundStyle(.orange, .orange)
                })
            })
        }
    }
}

#Preview {
    NavView()
}
