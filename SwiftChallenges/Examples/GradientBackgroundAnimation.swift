import SwiftUI

struct GradientBackgroundAnimation: View {
    @State var start = UnitPoint(x: 0, y: 0)
    @State var end = UnitPoint(x: 1, y: 1)
    @State var startAngle: Double = 0
    @State var endAngle: Double = 360
    
    let timer = Timer.publish(every: 1, on: .main, in: .default).autoconnect()
    let colors = [Color(#colorLiteral(red: 0.9843137255, green: 0.9176470588, blue: 0.6470588235, alpha: 1)), Color(#colorLiteral(red: 1, green: 0.3333333333, blue: 0.6117647059, alpha: 1)), Color(#colorLiteral(red: 0.4156862745, green: 0.7098039216, blue: 0.9294117647, alpha: 1)), Color(#colorLiteral(red: 0.337254902, green: 0.1137254902, blue: 0.7490196078, alpha: 1)), Color(#colorLiteral(red: 0.337254902, green: 0.9215686275, blue: 0.8509803922, alpha: 1))]

    var body: some View {
        angularBackground
            .blur(radius: 10)
            .mask(Circle())
            .frame(width: 250, height: 250, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
    }
    
    var angularBackground: some View {
        AngularGradient(
            gradient: Gradient(colors: colors),
            center: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/,
            startAngle: .degrees(startAngle),
            endAngle: .degrees(endAngle)
        )
        .onReceive(timer) { _ in
            withAnimation(.easeInOut(duration: 10).repeatForever(autoreverses: true)) {
                self.startAngle += 10
                self.endAngle += 5
            }
        }
        .ignoresSafeArea()
    }
    
    var background: some View {
        LinearGradient(colors: colors, startPoint: start, endPoint: end)
            .onReceive(timer) { _ in
                withAnimation(.easeInOut(duration: 10).repeatForever(autoreverses: true)) {
                    self.start = UnitPoint(x: 4, y: 0)
                    self.end = UnitPoint(x: 0, y: 2)
                    self.start = UnitPoint(x: -4, y: 20)
                    self.start = UnitPoint(x: 4, y: 0)
                }
            }
            .ignoresSafeArea()
    }
}

#Preview {
    GradientBackgroundAnimation()
}
