import Foundation

public extension DateFormatter {
    /// A date formatter used for date objects - `yyyy-MM-dd`.
    /// - Returns: A `DateFormatter` instance.
    static func date() -> DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }
}
