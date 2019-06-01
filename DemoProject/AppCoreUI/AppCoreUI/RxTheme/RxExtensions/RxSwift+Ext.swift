
import Foundation
import RxSwift
import RxCocoa

public protocol RxExtensions {}

extension Observable: RxExtensions {}

public extension RxExtensions where Self: ObservableType {
    /// Ignores elements of the first observable and concatenates with the second.
    /// Rename this operator to indicate it ignore elements of the first observable
    func concatMap<T, O: ObservableConvertibleType>(_ second: O) -> RxSwift.Observable<T> where O.Element == T {
        return flatMap { _ -> Observable<T> in Observable.empty() }
            .concat(second)
    }

    func completeAfter(_ predicate: @escaping (Self.Element) throws -> Bool) -> Observable<Self.Element> {
        return Observable<Self.Element>.create { observer in
            self.subscribe { event in
                switch event {
                case let .next(element):
                    do {
                        observer.onNext(element)
                        if try predicate(element) {
                            observer.onCompleted()
                        }
                    } catch let err {
                        observer.onError(err)
                    }
                case let .error(err):
                    observer.onError(err)
                case .completed:
                    observer.onCompleted()
                }
            }
        }
    }
}

public extension RxExtensions where Self: ObservableType {
    static func signalObserver() -> (signal: Observable<Element>, observer: AnyObserver<Element>) {
        let p = PublishSubject<Element>()
        return (p.asObservable(), AnyObserver(eventHandler: p.asObserver().on))
    }
}

public extension RxExtensions where Self: ObservableType {
    func pairs(wrap: Bool = false) -> Observable<(Element, Element)> {
        let skippedObservable: Observable<Element> = {
            guard wrap else { return self.skip(1) }
            return self.skip(1).concat(self.take(1))
        }()
        return Observable<(Element, Element)>.zip(self, skippedObservable) { ($0, $1) }
    }
}

struct InfiniteSequence<E>: Sequence {
    typealias Element = E
    typealias Iterator = AnyIterator<E>

    private let _repeatedValue: E

    init(repeatedValue: E) {
        _repeatedValue = repeatedValue
    }

    func makeIterator() -> Iterator {
        let repeatedValue = _repeatedValue
        return AnyIterator {
            repeatedValue
        }
    }
}

public extension RxExtensions where Self: ObservableType {
    /// Concatenates the argument completable with this observable.
    func andThenMap(_ completable: Completable) -> Observable<Element> {
        return concat(completable.asObservable().flatMap { _ in Observable<Element>.empty() })
    }
}

public extension RxExtensions where Self: ObservableType {
    /// A synonym from concat when `andThen` reads more clearly.
    func andThen(_ second: Observable<Element>) -> Observable<Element> {
        return concat(second)
    }
    /// A synonym from concat(.just(element)) when `andThen` reads more clearly.
    func andThen(_ element: Element) -> Observable<Element> {
        return concat(Observable.just(element))
    }
    /// Force an observable (must be on main thread) to be shared by swallowing event errors.
    func toSignal() -> SharedSequence<SignalSharingStrategy, Element> {
        return self.asSignal  { error -> Signal<Element> in
            return Signal.empty()
        }
    }
    /// Force an observable (must be on main thread) to be shared replay(1) by swallowing event errors.
    func toDriver() -> SharedSequence<DriverSharingStrategy, Element> {
        return self.asDriver  { error -> Driver<Element> in
            return Driver.empty()
        }
    }
}

public extension PrimitiveSequenceType where Trait == CompletableTrait, Element == Never {
    /// A synonym for Completable.andThen, used when `until` reads more clearly.
    func until(_ second: Completable) -> Completable {
        return andThen(second)
    }
    /// Takes a sequence of Completables, and Completes when the first does.
    static func first(_ completable: Completable...) -> Completable {
        let observables = completable.map { $0.asObservable() }
        return Observable.amb(observables).asCompletable()
    }
    /// concatenates a single valued observable once the completable has completed.
    func andThenJust<T>(return value: T) -> Observable<T> {
        return andThen(.just(value))
    }
    func andThen<R>(_ second: Signal<R>) -> Signal<R> {
        return andThen(second.asObservable()).toSignal()
    }

}

public extension PrimitiveSequenceType where Trait == SingleTrait {
    func toSignal() -> SharedSequence<SignalSharingStrategy, Element> {
        return primitiveSequence.asSignal  { error -> Signal<Element> in
            return Signal.empty()
        }
    }
}

public extension SharedSequenceConvertibleType where SharingStrategy == DriverSharingStrategy {
    func asSignal() -> SharedSequence<SignalSharingStrategy, Element> {
        return self.asSignal { error -> Signal<Element> in
            #if DEBUG
            fatalError("Somehow signal received error from a source that shouldn't fail.")
            #else
            return Signal.empty()
            #endif
        }
    }
    /// map using `selector` then filter out repeated elements.
    func mapDistinct<R: Equatable>(selector: @escaping (Element) -> R) -> Driver<R> {
        return map(selector).distinctUntilChanged()
    }
    /// filter nil, unwrap optional and then take `count` elements.
    func take(_ count: Int) -> Observable<Element> {
        return asObservable().take(count)
    }
    func toSingle() -> Single<Element> {
        return take(1).asSingle()
    }
    /// filter nil and unwrap optional.
    func unwrap<T>() -> Driver<T> where Element == T? {
        return filter { $0 != nil }.map { $0! }
    }
    /// filter nil, unwrap optional and then take `count` elements.
    func unwrap<T>(_ count: Int) -> Observable<T> where Element == T? {
        return filter { $0 != nil }.map { $0! }.take(count)
    }
    func when(_ keyPath: KeyPath<Element, Bool>) -> Driver<Element> {
        return filter { $0[keyPath: keyPath] }
    }
    func whenMapDistinct(_ keyPath: KeyPath<Element, Bool>) -> Driver<Element> {
        return filter { $0[keyPath: keyPath] }
            .map { $0[keyPath: keyPath] }
            .distinctUntilChanged()
            .withLatestFrom(self)
    }
    func whenDistinct(_ keyPath: KeyPath<Element, Bool>) -> Driver<Element> {
        return filter { $0[keyPath: keyPath] }
            .distinctUntilChanged { $0[keyPath: keyPath] == $1[keyPath: keyPath] }
    }
    func whenFirst(_ keyPath: KeyPath<Element, Bool>) -> Observable<Element> {
        return filter { $0[keyPath: keyPath] }.take(1).asObservable()
    }
}

public extension SharedSequenceConvertibleType where SharingStrategy == SignalSharingStrategy {
    /// map using `selector` then filter out repeated elements.
    func mapDistinct<R: Equatable>(selector: @escaping (Element) -> R) -> Signal<R> {
        return map(selector).distinctUntilChanged()
    }
    /// filter nil, unwrap optional and then take `count` elements.
    func take(_ count: Int) -> Observable<Element> {
        return asObservable().take(count)
    }
    /// filter nil and unwrap optional
    func unwrap<T>() -> Signal<T> where Element == T? {
        return filter { $0 != nil }.map { $0! }
    }
    /// filter nil, unwrap optional and take(count)
    func unwrap<T>(_ count: Int) -> Observable<T> where Element == T? {
        return filter { $0 != nil }.map { $0! }.take(count)
    }
    func when(_ keyPath: KeyPath<Element, Bool>) -> Signal<Element> {
        return filter { $0[keyPath: keyPath] }
    }
    func whenDistinct(_ keyPath: KeyPath<Element, Bool>) -> Signal<Element> {
        return filter { $0[keyPath: keyPath] }
            .distinctUntilChanged { $0[keyPath: keyPath] == $1[keyPath: keyPath] }
    }
    func whenFirst(_ keyPath: KeyPath<Element, Bool>) -> Observable<Element> {
        return filter { $0[keyPath: keyPath] }.take(1).asObservable()
    }
}
public extension ObservableType {
    /// flatMap using and unretained weak object e.g. `self` and return `.emtpy()` if `self == nil`.
    func flatMap<A: AnyObject, O: ObservableType>(weak obj: A, selector: @escaping (A, Self.Element) throws -> O)
        -> Observable<O.Element> {
        return flatMap { [weak obj] value -> Observable<O.Element> in
            try obj.map { try selector($0, value).asObservable() } ?? .empty()
        }
    }
    /// flatMapFirst using and unretained weak object e.g. `self` and return `.emtpy()` if `self == nil`.
    func flatMapFirst<A: AnyObject, O: ObservableType>(weak obj: A, selector: @escaping (A, Self.Element) throws -> O)
        -> Observable<O.Element> {
        return flatMapFirst { [weak obj] value -> Observable<O.Element> in
            try obj.map { try selector($0, value).asObservable() } ?? .empty()
        }
    }
    /// flatMapLastest using and unretained weak object e.g. `self` and return `.emtpy()` if `self == nil`.
    func flatMapLatest<A: AnyObject, O: ObservableType>(weak obj: A, selector: @escaping (A, Self.Element) throws -> O)
        -> Observable<O.Element> {
        return flatMapLatest { [weak obj] value -> Observable<O.Element> in
            try obj.map { try selector($0, value).asObservable() } ?? .empty()
        }
    }

    func withLatestFrom<SecondO, ThirdO, ResultType>(_ second: SecondO, _ third: ThirdO, resultSelector: @escaping (Self.Element, SecondO.Element, ThirdO.Element) throws -> ResultType) -> RxSwift.Observable<ResultType> where SecondO : ObservableConvertibleType, ThirdO : ObservableConvertibleType {
        return withLatestFrom(second) { ($0, $1) }
              .withLatestFrom(third) { try resultSelector($0.0, $0.1, $1) }
    }
}
public extension PrimitiveSequenceType where Trait == SingleTrait {
    /// flatMap using and unretained weak object e.g. `self` and return `.emtpy()` if `self == nil`.
    func flatMap<A: AnyObject, R>(weak obj: A, _ selector: @escaping (A, Self.Element) throws
        -> PrimitiveSequence<SingleTrait, R>) -> PrimitiveSequence<SingleTrait, R> {
        return primitiveSequence.flatMap { [weak obj] value -> Single<R> in
            guard let this = obj else { return Single.never() }
            return try selector(this, value)
        }
    }
}
public extension SharedSequenceConvertibleType where SharingStrategy == DriverSharingStrategy {
    /// flatMap using and unretained weak object e.g. `self` and return `.emtpy()` if `self == nil`.
    func flatMap<A: AnyObject, R>(weak obj: A, _ selector: @escaping (A, Self.Element) -> Driver<R>) -> Driver<R> {
        return self.flatMap({ [weak obj] value -> SharedSequence<DriverSharingStrategy, R> in
            guard let this = obj else { return .empty() }
            return selector(this, value)
        })
    }
    /// flatMap using and unretained weak object e.g. `self` and return `.emtpy()` if `self == nil`.
    func flatMapFirst<A: AnyObject, R>(weak obj: A, _ selector: @escaping (A, Self.Element) -> Driver<R>) -> Driver<R> {
        return self.flatMapFirst({ [weak obj] value -> SharedSequence<DriverSharingStrategy, R> in
            guard let this = obj else { return .empty() }
            return selector(this, value)
        })
    }
    /// flatMap using and unretained weak object e.g. `self` and return `.emtpy()` if `self == nil`.
    func flatMapLatest<A: AnyObject, R>(weak obj: A, _ selector: @escaping (A, Self.Element) -> Driver<R>) -> Driver<R> {
        return self.flatMapLatest({ [weak obj] value -> SharedSequence<DriverSharingStrategy, R> in
            guard let this = obj else { return .empty() }
            return selector(this, value)
        })
    }
    /// flatMap a `Driver<Element>` to signals of type `Signal<Result>`.
    func flatMapSignal<A: AnyObject, R>(weak obj: A, _ selector: @escaping (A, Self.Element) -> Signal<R>) -> Signal<R> {
        return self.flatMap({ [weak obj] value -> Signal<R> in
            guard let this = obj else { return .empty() }
            return selector(this, value)
        })
    }
}
public extension SharedSequenceConvertibleType where SharingStrategy == SignalSharingStrategy {
    /// flatMap using and unretained weak object e.g. `self` and return `.emtpy()` if `self == nil`.
    func flatMap<A: AnyObject, R>(weak obj: A, _ selector: @escaping (A, Self.Element) -> Signal<R>) -> Signal<R> {
        return self.flatMap({ [weak obj] value -> SharedSequence<SignalSharingStrategy, R> in
            guard let this = obj else { return .empty() }
            return selector(this, value)
        })
    }
    /// flatMap using and unretained weak object e.g. `self` and return `.emtpy()` if `self == nil`.
    func flatMapFirst<A: AnyObject, R>(weak obj: A, _ selector: @escaping (A, Self.Element) -> Signal<R>) -> Signal<R> {
        return self.flatMapFirst({ [weak obj] value -> SharedSequence<SignalSharingStrategy, R> in
            guard let this = obj else { return .empty() }
            return selector(this, value)
        })
    }
    /// flatMap using and unretained weak object e.g. `self` and return `.emtpy()` if `self == nil`.
    func flatMapLatest<A: AnyObject, R>(weak obj: A, _ selector: @escaping (A, Self.Element) -> Signal<R>) -> Signal<R> {
        return self.flatMapLatest({ [weak obj] value -> SharedSequence<SignalSharingStrategy, R> in
            guard let this = obj else { return .empty() }
            return selector(this, value)
        })
    }
}


