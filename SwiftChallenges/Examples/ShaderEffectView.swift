import SwiftUI
// https://www.hackingwithswift.com/quick-start/swiftui/how-to-add-metal-shaders-to-swiftui-views-using-layer-effects

struct ShaderEffectView: View {
    let startDate = Date()
    @State private var strength = 3.0

    var body: some View {
//        VStack {
//            Image(systemName: "figure.run.circle.fill")
//                .foregroundStyle(.linearGradient(colors: [.orange, .red], startPoint: .top, endPoint: .bottom))
//                .font(.system(size: 300))
//            
//            // stripes
//                .foregroundStyle(
//                    ShaderLibrary.angledFill(
//                        .float(10),
//                        .float(10),
//                        .color(.blue)
//                    )
//                )
//            
//            // emboss
//                .layerEffect(ShaderLibrary.emboss(.float(1)), maxSampleOffset: .zero)
//                .layerEffect(ShaderLibrary.emboss(.float(strength)), maxSampleOffset: .zero)
//            
//            // pixalate
//                .layerEffect(ShaderLibrary.pixellate(.float(5)), maxSampleOffset: .zero)
//
//            Slider(value: $strength, in: 0...20)
//        }
//        .padding()
        
        
        TimelineView(.animation) { context in
            Image(systemName: "touchid")
                .font(.system(size: 250).weight(.heavy))
                .foregroundStyle(.blue)

//             //noise
//                .colorEffect(ShaderLibrary.noise(.float(startDate.timeIntervalSinceNow)))
            
//                .overlay(
//                    RoundedRectangle(cornerRadius: 20)
//                        .colorEffect(ShaderLibrary.noise(.float(startDate.timeIntervalSinceNow)))
//                        .blendMode(.overlay)
//                )
            
//                // simple wave
//                .distortionEffect(
//                    ShaderLibrary.simpleWave(.float(startDate.timeIntervalSinceNow)), maxSampleOffset: CGSize(width: 100, height: 100)
//                )
            
//             // complex wave
                .visualEffect { content, proxy in
                    content
                        .distortionEffect(ShaderLibrary.complexWave(
                            .float(startDate.timeIntervalSinceNow),
                            .float2(proxy.size),
                            .float(0.5),
                            .float(8),
                            .float(10)
                        ), maxSampleOffset: .zero)
                }

        }
    }
}

#Preview {
    ShaderEffectView()
}
