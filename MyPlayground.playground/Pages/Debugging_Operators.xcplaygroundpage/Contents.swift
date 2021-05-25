//: [Previous](@previous)
import RxSwift

/*:
 # Debugging Operators
 Operators to help debug Rx code.
 
 ---
 ## `debug`
 Prints out all subscriptions, events, and disposals.
 */

example("debug") {
    var count = 1
    
    let sequenceThatErrors = Observable<String>.create { observer in
        observer.onNext("1")
        observer.onNext("2")
        observer.onNext("3")
        
        if count < 5 {
            observer.onError(TestError.test)
            print("Error encountered")
            count += 1
        }
        
        observer.onNext("4")
        observer.onNext("5")
        observer.onNext("6")
        observer.onCompleted()
        
        return Disposables.create()
    }
    
    sequenceThatErrors
        .retry(3)
        .debug()
        .subscribe(onNext: { print($0) })
        .disposed(by: disposeBag)
    
}

/*:
 ----
 ## `RxSwift.Resources.total`
 Provides a count of all Rx resource allocations, which is useful for detecting leaks during development.
 */
example("RxSwift.Resources.total") {
    print(RxSwift.Resources.total)
    
    print(RxSwift.Resources.total)
    
    let subject = BehaviorSubject(value: "🍎")
    
    let subscription1 = subject.subscribe(onNext: { print($0) })
    
    print(RxSwift.Resources.total)
    
    let subscription2 = subject.subscribe(onNext: { print($0) })
    
    print(RxSwift.Resources.total)
    
    subscription1.dispose()
    
    print(RxSwift.Resources.total)
    
    subscription2.dispose()
    
    print(RxSwift.Resources.total)
}

print(RxSwift.Resources.total)


//: [Next](@next)
