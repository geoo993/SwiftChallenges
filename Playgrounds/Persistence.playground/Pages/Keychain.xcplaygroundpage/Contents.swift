// https://www.andyibanez.com/posts/using-ios-keychain-swift/
// https://github.com/kishikawakatsumi/KeychainAccess

import Foundation

// Keychain and iCloud:
// Apple Keychain is a very popular and functional Swift tool that every iOS and MacOS user is using.
// It can be used to save passwords, secure notes, certificates, etc. In general, Keychain is an encrypted database with quite a complicated and robust API.
// Use Keychain when you need to save sensitive user data, such as passwords or login credentials.

// iCloud:
// iCloud is Apple's cloud storage service that can be used to store and sync data across multiple devices. It can be used in iOS apps to store and retrieve data, such as user preferences, documents, and settings.

public protocol KeychainStorage {
    func item(forKey key: String) -> String?
    func save(item: String?, forKey key: String)
    func delete(forKey key: String) throws
}

public struct KeychainCache: KeychainStorage {
    private let storage: Keychain

    public init(storage: Keychain = .init()) {
        self.storage = storage
    }

    public func item(forKey key: String) -> String? {
        storage[key]
    }

    public func save(item: String?, forKey key: String) {
        storage[key] = item
    }

    public func delete(forKey key: String) throws {
        try storage.remove(key)
    }
}

print("Key chain tutorial")
