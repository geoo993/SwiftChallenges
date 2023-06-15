import SwiftUI
import PlaygroundSupport

struct ProgressView: View {
    var body: some View {
        Circle()
            .stroke(lineWidth: 40)
            .foregroundColor(.blue)
    }
}

PlaygroundPage.current.setLiveView(ProgressView().padding(150))
