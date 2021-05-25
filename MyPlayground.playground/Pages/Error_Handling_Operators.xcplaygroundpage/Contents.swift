//: [Previous](@previous)

import RxSwift

/*:
# Error Handling Operators
异常处理操作.
 
 ---
## `catchErrorJustReturn`
从onError事件恢复，接下来继续发送一个事件就结束. [More info](http://reactivex.io/documentation/operators/catch.html)
 
![](catch.png)
*/
example("catchErrorJustReturn") {
    let sequenceThatFails = PublishSubject<String>()
    
    sequenceThatFails
        .catchErrorJustReturn("😊")
        .subscribe { print($0) }
        .disposed(by: disposeBag)
    
    sequenceThatFails.onNext("1")
    sequenceThatFails.onNext("2")
    sequenceThatFails.onNext("3")
    sequenceThatFails.onError(TestError.test)
}


/*:
 ---
## `catchError`
从onError事件恢复，继续发送recoverySequence里的事件. [More info](http://reactivex.io/documentation/operators/catch.html)
 */
example("catchError") {
    let sequenceThatFails = PublishSubject<String>()
    let recoverySequence = PublishSubject<String>()
    
    sequenceThatFails
        .catchError {
            print($0)
            return recoverySequence
        }
        .subscribe { print($0) }
        .disposed(by: disposeBag)
    
    sequenceThatFails.onNext("1")
    sequenceThatFails.onNext("2")
    sequenceThatFails.onNext("3")
    sequenceThatFails.onError(TestError.test)
    
    // 遇到Error事件后开始订阅recoverySequence
    recoverySequence.onNext("😊")
    recoverySequence.onNext("🔴")
    
    // 原来的sequenceThatFails订阅被取消
    sequenceThatFails.onNext("4")
}

/*:
 ----
 ## `retry`
遇到Error事件后会无限次的重复订阅. [More info](http://reactivex.io/documentation/operators/retry.html)
 
 ![](retry.C.png)
 */
example("retry") {
    var count = 1
    
    let sequenceThatErrors = Observable<String>.create { observer in
        observer.onNext("1")
        observer.onNext("2")
        observer.onNext("3")
        
        if count == 1 {
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
        .retry()
        .subscribe(onNext: { print($0) })
        .disposed(by: disposeBag)
}

/*:
 ----
 ## `retry(_:)`
 遇到Error事件后会重复订阅指定次数. [More info](http://reactivex.io/documentation/operators/retry.html)
 */
example("retry maxAttemptCount") {
    let disposeBag = DisposeBag()
    var count = 1
    
    let sequenceThatErrors = Observable<String>.create { observer in
        observer.onNext("1")
        observer.onNext("2")
        observer.onNext("3")
        
        if count < 2 {
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
        .subscribe(onNext: { print($0) })
        .disposed(by: disposeBag)
}

//: [Next](@next)
