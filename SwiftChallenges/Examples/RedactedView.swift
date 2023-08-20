import SwiftUI

struct RedactedView: View {
    @State var isLoading = true
    @State var color = Color.blue
    @State var color2 = Color.purple

    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [color, color2]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            ).ignoresSafeArea()
            VStack {
                ColorPicker("Colors", selection: $color)
                ColorPicker("Colors", selection: $color2)
                RedactedCardView()
                    .redacted(reason: isLoading ? .placeholder : .init())
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            isLoading = false
                        }
                    }
            }
            .padding()
        }
    }
}

struct RedactedCardView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Image(systemName: "person")
                .font(.title)
                .frame(width: 50, height: 50)
                .background(
                    RoundedRectangle(cornerRadius: 25.0)
                        .fill(.brown)
                )
                .foregroundColor(.white)
            Text("iOS Developer")
                .font(.title2).bold()
            Text("by George Quentin")
                .font(.footnote).bold()
                .foregroundStyle(.secondary)
            Text("I am an engineer and entrepreneur at heart, very enthusiastic about using technology to create solutions that can profoundly impact industries and people’s lives. I am always looking forward to working with companies to deliver high quality products to their users."
            )
            .frame(maxWidth: .infinity, alignment: .leading)
            .foregroundStyle(.secondary)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(.white)
        .mask(RoundedRectangle(cornerRadius: 25.0, style: .continuous))
        .shadow(color: Color.black.opacity(0.4), radius: 20, x: 0, y: 40)
        .padding(.top)
    }
}

#Preview {
    RedactedView()
}
