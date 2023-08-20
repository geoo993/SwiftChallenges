import SwiftUI

struct StatusBarHeightIndicatorView: View {
    var body: some View {
        GeometryReader { geometry in
            VStack {
                Text("Top size: \(geometry.safeAreaInsets.top)")
                    .frame(maxWidth: .infinity)
                    .overlay(
                        Rectangle()
                            .frame(width: nil, height: 1, alignment: .top)
                            .foregroundColor(Color.black),
                        alignment: .top
                    )
                
                Spacer()
                Text("Bottom size: \(geometry.safeAreaInsets.bottom)")
                    .frame(maxWidth: .infinity)
                    .overlay(
                        Rectangle()
                            .frame(width: nil, height: 1, alignment: .top)
                            .foregroundColor(Color.black),
                        alignment: .bottom
                    )
            }
        }
    }
}

#Preview {
    StatusBarHeightIndicatorView()
}
