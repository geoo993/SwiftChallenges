import SwiftUI

struct MarkdownView: View {
    let markdown = "Visit [My Website](https://www.apple.com) to learn how to `code` and _design_."
    @State private var attributedString: AttributedString = ""
    
    var body: some View {
        VStack {
            Text(attributedString)
                .padding()
                .onAppear {
                    do {
                        attributedString = try AttributedString(markdown: markdown)
                    } catch {
                        print("Error creating markdown \(error.localizedDescription)")
                    }
                }
                .environment(\.openURL, OpenURLAction(handler: handleURL))
        }
    }
    
    func handleURL(_ url: URL) -> OpenURLAction.Result {
        print("Handle \(url) somehow")
        return .systemAction
    }
}

#Preview {
    MarkdownView()
}
