import Foundation

public extension DateFormatter {
    static func iso8601Full() -> DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY-MM-dd'T'HH:mm:ss.SSSZ"
        formatter.calendar = Calendar(identifier: .iso8601)
        return formatter
    }
    
    static func short() -> DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yy"
        return formatter
    }
}
