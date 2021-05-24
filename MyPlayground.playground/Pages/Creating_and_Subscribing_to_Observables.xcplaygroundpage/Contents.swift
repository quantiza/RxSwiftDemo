//: [Previous](@previous)

import RxSwift

/*:
 # Creating and Subscribing to `Observable`s
 ---
 ## never
 创建一个sequence，永远不会结束也不会发出事件
 */
example("never") {
    let neverSequence = Observable<String>.never()
    let neverSequenceSubscription = neverSequence
        .subscribe { _ in
            print("This will never be printed")
        }
    
    neverSequenceSubscription.disposed(by: disposeBag)
}

/*:
 ---
 ## empty
 创建一个空的`Observable` sequence，只发出Completed事件
 */
example("empty") {
    Observable<Int>.empty()
        .subscribe { event in
            print(event)
        }
        .disposed(by: disposeBag)
}

/*:
 ---
 ## just
 创建只有一个元素的`Observable` sequence，发出一个next事件和一个Completed事件
 */
example("just") {
    Observable<Int>.just(1)
        .subscribe { event in
            print(event)
        }
        .disposed(by: disposeBag)
}

/*:
 ----
 ## of
 创建一个拥有固定元素的 `Observable` sequence, `onNext:`只处理next事件
 */
example("of") {
    Observable.of(1, 2, 3, 4, 5)
        .subscribe(onNext: { element in
            print(element)
        })
        .disposed(by: disposeBag)
}

/*:
 ----
 ## from
 从一个`Array`, `Dictionary` 或 `Set` `Sequence` 创建 `Observable` sequence.
 */
example("from") {
    Observable.from([1, 2, 3, 4, 5])
        .subscribe(onNext: { print($0) })
        .disposed(by: disposeBag)
}

/*:
 ----
  ## create
  创建一个自定义 `Observable` sequence. [More info](http://reactivex.io/documentation/operators/create.html)
 */

example("create") {
    Observable.create { observer in
        observer.on(.next("first"))
        observer.on(.next("second"))
        observer.on(.completed)
        return Disposables.create()
    }
    .subscribe { event in print(event) }
    .disposed(by: disposeBag)
}
//: [Next](@next)
