import SwiftUI

struct CanvaTimelineView: View {
    var body: some View {
        // Canvas is designed to be more power efficient and performant
        // if you want to add a timeline view animation, wrap it around a Canvas
        ZStack {
            TimelineView(.animation) { timeline in
                Canvas { context, size in
                    let w = size.width
                    let h = size.height
                    let now = timeline.date.timeIntervalSinceReferenceDate
                    let angle = Angle.degrees(now.remainder(dividingBy: 4) * 90)
                    let d1 = (sin(angle.radians)) * 20
                    let d2 = (cos(angle.radians)) * 30
                    
                    context.fill(Path(CGRect(origin: .zero, size: size)), with: .color(Color(.sRGB, red: 230/255, green: 240/255, blue: 1, opacity: 1)))
                    
                    let path = Path { path in
                        path.move(to: CGPoint(x: w * 0.15, y: h * 0.97))
                        path.addCurve(
                            to: CGPoint(x: w * 0.1, y: h * 0.3 - d2) ,
                            control1: CGPoint(x: w * 0.1 - d2, y: h * 0.87),
                            control2: CGPoint(x: 0, y: h * 0.75 + d1)
                        )
                        path.addCurve(
                            to: CGPoint(x: w * 0.48, y: h * 0.05) ,
                            control1: CGPoint(x: w * 0.1, y: h * 0.2 - d2),
                            control2: CGPoint(x: w * 0.2, y: h * 0.1)
                        )
                        path.addCurve(
                            to: CGPoint(x: w * 0.92 - d2, y: h * 0.7) ,
                            control1: CGPoint(x: w * 0.65, y: h * 0),
                            control2: CGPoint(x: w * 0.9 + d1, y: h * 0.17)
                        )
                        path.addCurve(
                            to: CGPoint(x: w * 0.15, y: h * 0.97) ,
                            control1: CGPoint(x: w - d2, y: h * 0.94),
                            control2: CGPoint(x: w, y: h * 0.9)
                        )
                    }
                    context.fill(
                        path,
                        with: .linearGradient(
                            Gradient(colors: [.green, .blue]),
                            startPoint: .zero ,
                            endPoint: CGPoint(x: size.width, y: size.height)
                        )
                    )
                }
            }
            
            Rectangle()
                .foregroundColor(.black)
                .opacity(0.5)
            Text("Timeline View in SwiftUI")
                .font(.title.bold())
                .foregroundColor(.white)
                .padding()
        }
        .ignoresSafeArea(.all)
    }
}

#Preview {
    CanvaTimelineView()
}
