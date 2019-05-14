import UIKit

class User {
    enum Mode: String {
        case standing = "Standing"
        case running = "Running"
        case jumping = "Jumping"
        case crouching = "Crouching"
    }
    
    enum Event {
        case doStand
        case doRun
        case doJump
        case doCrouch
    }
    
    class State {
        var mode: Mode
        var userName: String
        init(name: String) {
            self.mode = .standing
            self.userName = name
        }
        public var isGrounded: Bool {
            return mode == .standing
        }
        public var isRunning: Bool {
            return mode == .running
        }
        public var isJumping: Bool {
            return mode == .jumping
        }
        public var isCrouching: Bool {
            return mode == .crouching
        }
    }
    
    private var state: State
    init(name: String) {
        self.state = State(name: name)
    }
    
    func process(event: Event) {
        switch (event) {
        case Event.doStand:
            state.mode = .standing;
        case Event.doRun:
            state.mode = .running;
        case Event.doJump:
            state.mode = .jumping;
        case Event.doCrouch:
            state.mode = .crouching;
        }
    }
    
    func getState() -> String {
        return "\(state.userName) is " + state.mode.rawValue
    }
}

let alex = User(name: "Alex")
alex.process(event: .doJump)
print(alex.getState())
alex.process(event: .doRun)
print(alex.getState())
