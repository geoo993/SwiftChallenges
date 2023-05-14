import Foundation

public final class MyDataRace {
    private var name: String = "!"
    private lazy var lazyName: String = "Antoine van der Lee"

    public init() {}
    
    public func updateName() {
        DispatchQueue.global().async {
            self.name.append("Antoine van der Lee")
        } // Executed on the Main Thread
        print(self.name)
    }
    
    public func printName() {
        DispatchQueue.global().async {
            print (self.lazyName)
        } // Executed on the Main Thread
        print (self.lazyName)
    }
}

public final class MyDataRaceSolution {
    private let lockQueue = DispatchQueue(label: "name.lock.queue")
    private var name: String = "Antoine van der Lee"
    
    public init() {}
    
    public func updateNameSync() {
        DispatchQueue.global().async {
            self.lockQueue.async {
                self.name.append("Antoine van der Lee")
            }
        }
        
        // Executed on the Main Thread
        lockQueue.async {
            // Executed on the lock queue
            print(self.name)
        }
    }
}
