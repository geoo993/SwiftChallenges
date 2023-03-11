import Foundation

public enum Resource: String {
	case users
	case posts
	case comments

	public func data() -> Data? {
        guard
            let path = Bundle.main.path(forResource: self.rawValue, ofType: "json")
        else { return nil }
		return FileManager.default.contents(atPath: path)
	}
}
