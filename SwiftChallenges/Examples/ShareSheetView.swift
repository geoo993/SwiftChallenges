import SwiftUI

struct ShareSheetView: View {
    var body: some View {
        Button(action: shareButton, label: {
            Image(systemName: "square.and.arrow.up")
                .foregroundStyle(.black)
        })
    }
    
    func shareButton() {
        let url = URL(string: "https://github.com/geoo993")!
        let activityController = UIActivityViewController(activityItems: [url], applicationActivities: nil)
        
        guard let firstScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
            return
        }
        guard let window = firstScene.windows.first else {
            return
        }
        window.rootViewController?.present(activityController, animated: true, completion: nil)
    }
}

#Preview {
    ShareSheetView()
}
