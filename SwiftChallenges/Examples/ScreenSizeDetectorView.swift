import SwiftUI

struct ScreenSizeDetectorView: View {
    @State var screenSize: CGSize = .zero
    
    var body: some View {
        ZStack {
            VStack {}
                .frame(
                    width: screenSize.width,
                    height: screenSize.height
                )
                .background(.purple)
            Color.clear
                .overlay(
                    GeometryReader {
                        Color.clear.preference(
                            key: SizePreferenceKey.self,
                            value:  $0.size
                        )
                    }
                )
                .onPreferenceChange(SizePreferenceKey.self, perform: { value in
                    screenSize = value
                })
//            VStack {}
//                .padding()
//            // Wont take into account the rotation of device
//                .frame(
//                    width: UIScreen.main.bounds.width,
//                    height: UIScreen.main.bounds.height
//                )
//                .background(.red)
//
//            // will detect rotation of device
//            GeometryReader { proxy in
//                VStack {}
//                    .padding()
//                    .frame(
//                        width: proxy.size.width,
//                        height: proxy.size.height
//                    )
//                    .background(.purple)
//            }
        }
    }
    
    struct SizePreferenceKey: PreferenceKey {
        static var defaultValue: CGSize = .zero
        static func reduce(value: inout CGSize, nextValue: () -> CGSize) {
            value = nextValue()
        }
    }
}

#Preview {
    ScreenSizeDetectorView()
}

