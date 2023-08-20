import SwiftUI

struct CourseValue: Identifiable {
    let id = UUID()
    let name: String
}

struct CourseCardView: View {
    var course: CourseValue
    var image: String
    var hours: String
    var colors: Array<Color>
    var logo: String
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            VStack(spacing: 6) {
                Image(image)
                    .resizable()
                    .frame(width: 128, height: 96, alignment: .center)
                
                Text(course.name)
                    .font(.headline)
                    .bold()
                    .multilineTextAlignment(.leading)
                    .foregroundColor(.white)
                    .lineLimit(2)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Text(hours)
                    .font(.footnote)
                    .foregroundColor(Color.white.opacity(0.7))
                    .frame(maxWidth: .infinity, alignment: .leading)
                
            }
            .frame(maxWidth: 200)
            .padding(.horizontal, 16)
            .padding(.bottom, 0)
        }
        .frame(height: 200)
        .background(
            LinearGradient(gradient: Gradient(colors: [Color.black.opacity(0), Color.black.opacity(0.2)]), startPoint: .center, endPoint: .bottom)
        )
        .background(
                LinearGradient(gradient: Gradient(colors: colors), startPoint: .top, endPoint: .bottom)
        )
        .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
        .shadow(color: colors[0].opacity(0.3), radius: 20, x: 0, y: 10)
        .overlay(
            Image(logo)
                .resizable()
                .frame(maxWidth: 24, maxHeight: 24, alignment: .center)
                .padding()
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
        )

    }
}

#Preview {
    CourseCardView(course: .init(name: "SwiftUI for iOS 14"), image: "illustration3", hours: "20 sections - 3 hours", colors: [Color(#colorLiteral(red: 1, green: 0.4509803922, blue: 0.4509803922, alpha: 1)), Color(#colorLiteral(red: 0.2862745098, green: 0.1176470588, blue: 0.7215686275, alpha: 1))], logo: "swift-logo")
}
