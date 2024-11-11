// https://medium.com/@kashif00527/user-defaults-in-ios-swift-a-comprehensive-guide-6d6d00675074
// https://medium.com/@talhasaygili/userdefaults-in-swift-764277365d61
import Foundation

// - UserDefaults:
// Its a simple way to store small amounts of data such as user preferences and settings.
// It stores the data as key-value pairs in a property list file on the device.

public protocol UserDefaultStorage {
    func object(forKey key: Key) -> Any?
    func bool(forKey key: Key) -> Bool?
    func string(forKey key: Key) -> String?
    func set(_ value: Any?, forKey key: Key)
    func remove(forKey key: Key)
}

public enum Key: String {
    case name = "storage.destination.name"
    case score = "storage.destination.score"
}

struct UserPreference: UserDefaultStorage {
    private let storage = UserDefaults.standard

    func object(forKey key: Key) -> Any? {
        storage.object(forKey: key.rawValue)
    }
    
    func bool(forKey key: Key) -> Bool? {
        storage.bool(forKey: key.rawValue)
    }

    func string(forKey key: Key) -> String? {
        storage.string(forKey: key.rawValue)
    }
    
    func set(_ value: Any?, forKey key: Key) {
        storage.set(value, forKey: key.rawValue)
        storage.synchronize() // use defaults.synchronize() method only if you cannot wait for the automatic synchronization.
    }
    
    func remove(forKey key: Key) {
        storage.removeObject(forKey: key.rawValue)
    }
}
print("USER DEFAULT Tutorieal")
