import SwiftUI

struct MatchedGeometryEffectAdvancedView: View {
    @State var show = false
    @Namespace var namespace
    
    var body: some View {
        ZStack(alignment: .bottom) {
            if !show {
                VStack {
                    HStack(spacing: 16) {
                        RoundedRectangle(cornerRadius: 15)
                            .matchedGeometryEffect(id: "cover", in: namespace)
                            .frame(width: 50)
                        Text("Fever")
                            .matchedGeometryEffect(id: "text", in: namespace)
                        Spacer()
                        Image(systemName: "play.fill")
                            .matchedGeometryEffect(id: "play", in: namespace)
                            .font(.title)
                        Image(systemName: "forward.fill")
                            .matchedGeometryEffect(id: "forward", in: namespace)
                            .font(.title)
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: 44)
                .padding(8)
                .background(
                    RoundedRectangle(cornerRadius: 0)
                        .fill(.orange)
                        .matchedGeometryEffect(id: "background", in: namespace)
                )
                .frame(maxHeight: .infinity, alignment: .bottom)
                
            } else {
                PlayView(namespace: namespace)
            }
        }
        .foregroundStyle(.white)
        .onTapGesture {
            withAnimation(.spring(response: 0.7, dampingFraction: 0.8)) {
                show.toggle()
            }
        }
    }
}

private struct PlayView: View {
    var namespace: Namespace.ID
    
    var body: some View {
        VStack(spacing: 20) {
            RoundedRectangle(cornerRadius: 30)
                .matchedGeometryEffect(id: "cover", in: namespace)
                .frame(height: 300)
                .padding()
            Text("Fever")
                .matchedGeometryEffect(id: "text", in: namespace)
            HStack {
                Image(systemName: "play.fill")
                    .matchedGeometryEffect(id: "play", in: namespace)
                    .font(.title)
                Image(systemName: "forward.fill")
                    .matchedGeometryEffect(id: "forward", in: namespace)
                    .font(.title)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 30)
                .fill(.orange)
                .matchedGeometryEffect(id: "background", in: namespace)
        )
        .ignoresSafeArea()
    }
}
#Preview {
    MatchedGeometryEffectAdvancedView()
}
