import SwiftUI

struct MatchedGeometryEffectView: View {
    @State var show = false
    @Namespace var namespace
    
    var body: some View {
        ZStack {
            if !show {
                ScrollView() {
                    HStack {
                        VStack {
                            Text("Title")
                                .foregroundStyle(.white)
                                .matchedGeometryEffect(id: "title", in: namespace)
                        }
                        .frame(width: 100, height: 100)
                        .background(
                            Rectangle()
                                .fill(.orange)
                                .matchedGeometryEffect(id: "shape", in: namespace)
                        )
                        
                        Rectangle()
                            .fill(.orange)
                            .frame(width: 100, height: 100)
                        
                        Spacer()
                    }
                    .padding(8)
                }
            } else {
                VStack {
                    Text("Title")
                        .foregroundStyle(.white)
                        .matchedGeometryEffect(id: "title", in: namespace)
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                        .padding()
                }
                .frame(maxWidth: .infinity, maxHeight: 400)
                .background(
                    Rectangle()
                        .fill(.orange)
                        .matchedGeometryEffect(id: "shape", in: namespace)
                )
            }
        }
        .onTapGesture {
            withAnimation(.spring(response: 0.4, dampingFraction: 0.6)) {
                show.toggle()
            }
        }
    }
}

#Preview {
    MatchedGeometryEffectView()
}
