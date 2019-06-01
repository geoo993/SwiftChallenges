import UIKit

// The observer pattern is used to allow an object to publish changes to its state.
// Other objects subscribe to be immediately notified of any changes.
//  As the following protocols shows, there is an observer and an Observable in this pattern.
//  The subject (observer) is the target to be observed. It holds the subject instance and will notify all obsevables to about the changes throught an event held by the subject.
// The subscribers get notified of the changes.

protocol ObserverProtocol {
    associatedtype T
    func create()
    func on(next element: T)
    func on(error: Error)
    func onCompleted ()
    func update() -> [Event<T>]
}

enum Event<T> {
    case create
    case next(T)
    case error
    case completed
}
struct Subject<T> {
    typealias A = T
    let id: String
    let value: Event<A> //T
    init(value: Event<A>) {
        self.value = value
        self.id = Date().description
    }
}

//The Observer is the class that implements the Observer protocol. When we get events captured by the observer, it calls the notify() method to notify the clients who are subscribe to it.
class Observer<A>: ObserverProtocol {
    typealias T = A
    private var subjects: [Subject<T>] = []
    private var isCompleted = true
    func create() {
        self.subjects.append(Subject(value: Event.create))
        isCompleted = false
    }
    func on(next element: T) {
        if isCompleted == false {
            self.subjects.append(
                Subject(value: Event.next(element) )
            )
        }
    }
    func on(error: Error) {
        self.subjects.append(Subject(value: Event.completed))
        isCompleted = true
    }
    func onCompleted () {
        self.subjects.append(Subject(value: Event.completed))
        isCompleted = true
    }
    func update() -> [Event<T>] {
        return self.subjects.map({ $0.value })
    }
}

//Observable is a class that listens to the changes of the observer variable. As soon as this variable’s value changes, the customer gets updated via the update() method.
protocol ObservableProtocol {
    associatedtype T
    func subscribe(onNext element: @escaping (T) -> ())
}
class Observable<A>: ObservableProtocol {
    typealias T = A
    var observer: Observer<T>
    init(with observer: Observer<T>) {
        self.observer = observer
    }
    func subscribe(onNext element: @escaping (T) -> ()) {
        for notification in self.observer.update() {
            switch notification {
            case .create:
                print("did subcribed")
            case let .next(value):
                element(value)
            case .error:
                print("did error")
            case .completed:
                print("did complete")
            }
        }
    }
}

let observer = Observer<String>()
observer.create()
observer.on(next: "R2-D2")
observer.on(next: "C-3PO")
observer.on(next: "K-2SO")
observer.onCompleted()

let observable = Observable(with: observer)
observable.subscribe(onNext: { value in
    print(value)
})

