import SwiftUI

extension View {
    @ViewBuilder func `if`<Content: View>(
        _ condition: Bool,
        transform: (Self) -> Content
    ) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }
    
    @ViewBuilder func `if`<Content: View>(
        _ condition: Binding<Bool>,
        transform: (Self) -> Content
    ) -> some View {
        if condition.wrappedValue {
            transform(self)
        } else {
            self
        }
    }
}
