import SwiftUI

struct Unwrap<Value, Content: View>: View {
    private let value: Value?
    private let content: (Value) -> Content

    init(
        _ value: Value?,
        @ViewBuilder content: @escaping (Value) -> Content
    ) {
        self.value = value
        self.content = content
    }

    var body: some View {
        value.map(content)
    }
}
