//: [Previous](@previous)

import RxSwift

example("Observable with no subscribers") {
    _ = Observable<String>.create { observerOfString -> Disposable in
        print("This will never be printed")
        observerOfString.on(.next("😬"))
        observerOfString.on(.completed)
        return Disposables.create()
    }
}

example("Observable with subscriber") {
    _ = Observable<String>.create { observerOfString -> Disposable in
        print("Observable created")
        observerOfString.on(.next("😉"))
        observerOfString.on(.completed)
        return Disposables.create()
    }
    .subscribe({ event in
        print(event)
    })
}

/*:
 #
 > `subscribe(_:)` 返回一个 `Disposable`实例，这个实例用于订阅的释放。前几个例子我们不考虑`Disposable`实例，但是资源释放需要被适当地处理，例如通常把它放进`DisposeBag`实例里。
You can learn more about this in the [Disposing section](https://github.com/ReactiveX/RxSwift/blob/master/Documentation/GettingStarted.md#disposing) of the [Getting Started guide](https://github.com/ReactiveX/RxSwift/blob/master/Documentation/GettingStarted.md).
 */

//: [Next](@next)
