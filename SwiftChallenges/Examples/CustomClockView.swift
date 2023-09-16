import SwiftUI

struct CustomClockView: View {
    private var icons = ["calendar", "message", "trash", "figure.walk"]
    private var numbers = [12, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11]
    @State var isRadial = true

    var body: some View {
        let layout = isRadial ? AnyLayout(RadialLayout()) : AnyLayout(CustomLayout())
        ZStack {
            layout {
                ForEach(icons, id: \.self) { item in
                    Circle()
                        .frame(width: 44)
                        .foregroundStyle(Color.black)
                        .overlay(Image(systemName: item).foregroundStyle(.white))
                }
            }
            .frame(width: 120)
            
            layout {
                ForEach(numbers, id: \.self) { item in
                    Text("\(item)")
                        .font(.system(.title, design: .rounded))
                        .bold()
                        .foregroundStyle(.black)
                        .offset(x: isRadial ? 0 : 50)
                }
            }
            .frame(width: 240)
            
            layout {
                ForEach(numbers, id: \.self) { item in
                    Text("\(item * 5)")
                        .font(.system(.caption, design: .rounded))
                    .foregroundStyle(.black)
                    .offset(x: isRadial ? 0 : 100)
                }
            }
            .frame(width: 360)
            
            Circle()
                .strokeBorder(style: StrokeStyle(
                    lineWidth: 10,
                    dash: [1, 10]
                ))
                .frame(width: 220)
        }
        .onTapGesture {
            withAnimation(.spring()) {
                isRadial.toggle()
            }
        }
    }
}

#Preview {
    CustomClockView()
}

struct CustomLayout: Layout {
    func sizeThatFits(
        proposal: ProposedViewSize,
        subviews: Subviews, cache: inout ()
    ) -> CGSize {
        proposal.replacingUnspecifiedDimensions()
    }
    
    func placeSubviews(
        in bounds: CGRect,
        proposal: ProposedViewSize,
        subviews: Subviews,
        cache: inout ()
    ) {
        for (index, value) in subviews.enumerated() {
            var point = CGPoint(x: 20 * index, y: 20 * index)
                .applying(CGAffineTransform(rotationAngle: CGFloat(6 * index)))
            point.x += bounds.midX
            point.y += bounds.midY
            value.place(at: point, anchor: .center, proposal: .unspecified)
        }
    }
}

struct RadialLayout: Layout {
    func sizeThatFits(
        proposal: ProposedViewSize,
        subviews: Subviews, cache: inout ()
    ) -> CGSize {
        proposal.replacingUnspecifiedDimensions()
    }
    
    func placeSubviews(
        in bounds: CGRect,
        proposal: ProposedViewSize,
        subviews: Subviews,
        cache: inout ()
    ) {
        let radius = bounds.width / 3.0
        let angle = Angle.degrees(360.0 / Double(subviews.count)).radians
        for (index, value) in subviews.enumerated() {
            var point = CGPoint(x: 0, y: -radius)
                .applying(CGAffineTransform(rotationAngle: angle * Double(index)))
            point.x += bounds.midX
            point.y += bounds.midY
            value.place(at: point, anchor: .center, proposal: .unspecified)
        }
    }
}
