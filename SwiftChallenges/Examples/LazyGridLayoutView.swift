import SwiftUI

struct LazyGridLayoutView: View {
    var body: some View {
        //            LazyHGrid(
        //                rows: [GridItem(.adaptive(minimum: 100))],
        //                spacing: 10
        //            ) {
        //                ForEach(0..<12) { item in
        //                    RoundedRectangle(cornerRadius: 10.0)
        //                        .fill(.pink)
        //                        .frame(width: 100)
        //                }
        //            }
        //            .padding()
        ScrollView(.vertical) {
            LazyVGrid(
                columns: Array(repeating: .init(.flexible(), spacing: 16), count: 3),
//                columns: [GridItem(.adaptive(minimum: 100))],
                alignment: .leading,
                spacing: 16
            ) {
                ForEach(0..<12) { item in
                    RoundedRectangle(cornerRadius: 10.0)
                        .fill(.pink)
                        .frame(height: 100)
                }
            }
            .padding()
        }
    }
}

#Preview {
    Group {
        LazyGridLayoutView()
    }
}
