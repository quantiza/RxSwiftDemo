//: [Previous](@previous)

import RxSwift

/*:
# Combination Operators
Operators 把多个 `Observable`s 联合成一个 `Observable`.
 
---
## `startWith`
在 `Observable` 开始发出事件之前，先发出指定元素序列. [More info](http://reactivex.io/documentation/operators/startwith.html)
 
![startwith](startwith.png)
*/

example("startwith") {
    Observable.of("1", "2", "3", "4")
        .startWith("🐶")
        .startWith("🅰️", "🅱️")
        .subscribe(onNext: { print($0) })
        .disposed(by: disposeBag)
}

/*:
 > 例子中可以看出多个`startWith`时，是last-in-first-out的
 ---
 ## `merge`
 把多个`Observable` sequences合成一个 `Observable` sequence. [More info](http://reactivex.io/documentation/operators/merge.html)
 
 ![merge](merge.png)
 */

example("merge") {
    let subject1 = PublishSubject<String>()
    let subject2 = PublishSubject<String>()
    
    Observable.of(subject1, subject2)
        .merge()
        .subscribe(onNext: { print($0) })
        .disposed(by: disposeBag)
    
    subject1.onNext("🅰️")
    subject1.onNext("🅱️")
    subject2.onNext("①")
    subject2.onNext("②")
    subject1.onNext("🆎")
    subject2.onNext("③")
}


/*:
 ---
 ## `zip`
 可以把 8 `Observable` sequences 合成一个新的 `Observable` sequence, 发出的元素来自于之前多个 `Observable` sequences的组合.[More info](http://reactivex.io/documentation/operators/zip.html)
 
 ![zip](zip.png)
 */

example("zip") {
    
    let stringSubject = PublishSubject<String>()
    let intSubject = PublishSubject<Int>()
    
    Observable.zip(stringSubject, intSubject) { stringElement, intElement in
        "\(stringElement) \(intElement)"
        }
        .subscribe(onNext: { print($0) })
        .disposed(by: disposeBag)
    
    stringSubject.onNext("🅰️")
    stringSubject.onNext("🅱️")
    
    intSubject.onNext(1)
    
    intSubject.onNext(2)
    
    stringSubject.onNext("🆎")
    intSubject.onNext(3)
}

/*:
 ---
 ## `combineLatest`
 可以把 8 `Observable` sequences 合成一个新的 `Observable` sequence, 发出的元素是源`Observable` sequences发出所有最新元素的组合.只有源`Observable` sequences都已经发出事件时，订阅者才开始接受事件[More info](http://reactivex.io/documentation/operators/zip.html)
 
 ![combineLatest](combineLatest.png)
 */

example("combineLatest") {
    
    let stringSubject = PublishSubject<String>()
    let intSubject = PublishSubject<Int>()
    
    Observable.combineLatest(stringSubject, intSubject) { stringElement, intElement in
            "\(stringElement) \(intElement)"
        }
        .subscribe(onNext: { print($0) })
        .disposed(by: disposeBag)
    
    stringSubject.onNext("🅰️")
    
    stringSubject.onNext("🅱️")
    intSubject.onNext(1)
    
    intSubject.onNext(2)
    
    stringSubject.onNext("🆎")
}

//: [Next](@next)
