import SwiftUI

struct AttributedStringContainerView: View {
    var attributedString: AttributedString {
        var name = AttributedString("Sam")
        var container = AttributeContainer()
        container.underlineStyle = .single
        container.underlineColor = .orange
        container.foregroundColor = .orange
        name.mergeAttributes(container)
        return "Hello" + name
    }

    var body: some View {
        Text(attributedString)
    }
}

#Preview {
    AttributedStringContainerView()
}
