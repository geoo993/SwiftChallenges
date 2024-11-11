// https://www.swiftyplace.com/blog/file-manager-in-swift-reading-writing-and-deleting-files-and-directories
// https://medium.com/@CoreyWDavis/reading-writing-and-deleting-files-in-swift-197e886416b0
import Foundation

// - File Manager:
// Apple makes writing, reading, and editing files inside the iOS applications very easy, where each application has a sandbox directory (called Document directory) where you can store your files.
// FileManager is an iOS framework API that allows apps to store data in the app file directory on the device.
// This can be useful for storing large files, such as images, videos, and audio files.

enum File: String {
    case docs = "Documents/Directory"
}

protocol FileManagerStorage {
    func read(fromFile file: File) throws -> Data
    func save(_ data: Data, inFile file: File) throws
    func delete(file: File) throws
}

struct FileManagerCache: FileManagerStorage {
    enum Error: Swift.Error {
        case fileAlreadyExists
        case invalidDirectory
        case writtingFailed
        case fileNotExists
        case readingFailed
    }
    
    private let storage: FileManager

    init(storage: FileManager = FileManager.default) {
        self.storage = storage
    }
    
    func read(fromFile file: File) throws -> Data {
        guard let url = makeURL(forFileNamed: file.rawValue) else {
           throw Error.invalidDirectory
        }
       guard storage.fileExists(atPath: url.absoluteString) else {
           throw Error.fileNotExists
       }
       do {
           return try Data(contentsOf: url)
       } catch {
           debugPrint(error)
           throw Error.readingFailed
       }
    }
    
    func save(_ data: Data, inFile file: File) throws {
        guard let url = makeURL(forFileNamed: file.rawValue) else {
           throw Error.invalidDirectory
        }
        if storage.fileExists(atPath: url.absoluteString) {
           throw Error.fileAlreadyExists
        }
        do {
            
           try data.write(to: url)
        } catch {
           debugPrint(error)
           throw Error.writtingFailed
        }
    }
    
    func delete(file: File) throws {
        guard let url = makeURL(forFileNamed: file.rawValue) else {
           throw Error.invalidDirectory
        }
        try storage.removeItem(at: url)
    }

    private func makeURL(forFileNamed fileName: String) -> URL? {
        guard let url = storage.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return nil
        }
        return url.appendingPathComponent(fileName)
    }
}

print("File manager tutorial")
