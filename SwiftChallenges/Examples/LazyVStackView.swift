import SwiftUI

struct LazyVStackView: View {
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                ForEach(0..<10000) { item in
                    RoundedRectangle(cornerRadius: 25.0, style: .continuous)
                        .fill(.pink)
                        .frame(height: 100)
                        .shadow(radius: 100) // impacts performance
                }
            }
            .padding()
        }
    }
}

#Preview {
    LazyVStackView()
}
