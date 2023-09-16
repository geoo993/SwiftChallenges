import SwiftUI

struct GridView: View {
    var body: some View {
        Grid(alignment: .leading, horizontalSpacing: 12, verticalSpacing: 12) {
            GridRow(alignment: .center) {
                Text("Votes")
                    .gridColumnAlignment(.trailing)
                    .gridCellColumns(2)
                Text("Rating")
                    .gridColumnAlignment(.trailing)
            }
            Divider()
                .gridCellUnsizedAxes(.horizontal)
            GridRow(alignment: .center) {
                Text("4")
                    .frame(width: 30, alignment: .trailing)
                ProgressView(value: 0.1)
                    .frame(maxWidth: 250)
                RatingView(rating: 1)
            }
            
            GridRow(alignment: .center) {
                Text("21")
                ProgressView(value: 0.4)
                    .frame(maxWidth: 250)
                RatingView(rating: 2)
            }
            
            GridRow(alignment: .center) {
                Text("54")
                ProgressView(value: 0.7)
                    .frame(maxWidth: 250)
                RatingView(rating: 3)
            }
            
            GridRow(alignment: .center) {
                Text("14")
                ProgressView(value: 0.15)
                    .frame(maxWidth: 250)
                RatingView(rating: 4)
            }
            GridRow(alignment: .center) {
                Text("24")
                ProgressView(value: 0.45)
                    .frame(maxWidth: 250)
                RatingView(rating: 5)
            }
        }
        .padding()
    }
}

#Preview {
    GridView()
}

struct RatingView: View {
    @State var rating: Int
    private let list = [1, 2, 3, 4, 5]

    var body: some View {
        HStack(spacing: 0) {
            ForEach(list, id: \.self) {
                Image(systemName: $0 > rating ? "star" : "star.fill")
            }
        }
    }
}
