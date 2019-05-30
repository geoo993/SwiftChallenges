
extension Date: Then { }

public extension Date {
    func toString(format: String) -> String {
        let date = DateFormatter().then {
            $0.dateFormat = "HH:mm:ss"
        }
        return date.string(from: self)
    }
}
