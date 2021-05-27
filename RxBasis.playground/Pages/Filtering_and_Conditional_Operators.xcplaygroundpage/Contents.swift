//: [Previous](@previous)

import RxSwift

/*:
# Filtering and Conditional Operators
从一个源`Observable` sequence选择性发出事件.
 
---
## `filter`
发出符合特定条件的事件. [More info](http://reactivex.io/documentation/operators/filter.html)
![](filter.png)
*/
example("filter") {
    Observable.of("🐱", "🐰", "🐶",
                  "🐸", "🐱", "🐰",
                  "🐹", "🐸", "🐱")
        .filter { $0 == "🐸" }
        .subscribe(onNext: { print($0) })
        .disposed(by: disposeBag)
}
/*:
 ----
## `distinctUntilChanged`
 不让`Observable` sequence 连续发出重复的元素. [More info](http://reactivex.io/documentation/operators/distinct.html)
![](distinct.png)
*/
example("distinctUntilChanged") {
    Observable.of("1", "2", "1", "1", "1", "2", "1")
        .distinctUntilChanged()
        .subscribe(onNext: { print($0) })
        .disposed(by: disposeBag)
}

/*:
 ----
 ## `take`
 
 只发出`Observable` sequence前面指定数量的元素. [More info](http://reactivex.io/documentation/operators/take.html)
 ![](take.png)
 */
example("take") {
    Observable.of("1", "2", "3", "4", "5", "6")
        .take(3)
        .subscribe(onNext: { print($0) })
        .disposed(by: disposeBag)
}

/*:
 ----
 ## `takeLast`
 只发出`Observable` sequence后面指定数量的元素. [More info](http://reactivex.io/documentation/operators/takelast.html)
 ![](takelast.png)
 */
example("takeLast") {
    Observable.of("1", "2", "3", "4", "5", "6")
        .takeLast(3)
        .subscribe(onNext: { print($0) })
        .disposed(by: disposeBag)
}

/*:
 ----
 ## `takeWhile`
 发出从开始连续满足条件的所有元素. [More info](http://reactivex.io/documentation/operators/takewhile.html)
 ![](takewhile.png)
 */
example("takeWhile") {
    Observable.of(1, 2, 4, 3, 5, 6)
        .takeWhile { $0 < 4 }
        .subscribe(onNext: { print($0) })
        .disposed(by: disposeBag)
}

/*:
 ----
 ## `takeUntil`
 sourceSequence可以一直发出元素，直到referenceSequence发出元素时sourceSequence发出complete事件. [More info](http://reactivex.io/documentation/operators/takeuntil.html)
 ![](takeuntil.png)
 */
example("takeUntil") {
    
    let sourceSequence = PublishSubject<String>()
    let referenceSequence = PublishSubject<String>()
    
    sourceSequence
        .takeUntil(referenceSequence)
        .subscribe { print($0) }
        .disposed(by: disposeBag)
    
    sourceSequence.onNext("🐱")
    sourceSequence.onNext("🐰")
    
    referenceSequence.onNext("🔴")
    
    sourceSequence.onNext("🐸")

}
// result: next(🐱), next(🐰), completed
/*:
 ----
 ## `skip`
 从指定位置开始跳过前面的元素. [More info](http://reactivex.io/documentation/operators/skip.html)
 ![](skip.png)
 */
example("skip") {
    Observable.of(1, 2, 3, 4, 5, 6)
        .skip(2)
        .subscribe(onNext: { print($0) })
        .disposed(by: disposeBag)
}
// result: 3, 4, 5, 6
/*:
 ----
 ## `skipWhile`
 跳过从开始连续满足特定条件的元素. [More info](http://reactivex.io/documentation/operators/skipwhile.html)
 ![](skipWhile.c.png)
 */
example("skipWhile") {
    Observable.of(1, 2, 4, 3, 5, 6)
        .skipWhile { $0 < 4 }
        .subscribe(onNext: { print($0) })
        .disposed(by: disposeBag)
}
// result: 4, 3, 5, 6

/*:
 ----
 ## `skipUntil`
 直到referenceSequence发出事件前，sourceSequence发出的事件都被跳过. [More info](http://reactivex.io/documentation/operators/skipuntil.html)
 ![](skipuntil.png)
 */
example("skipUntil") {
    let disposeBag = DisposeBag()
    
    let sourceSequence = PublishSubject<String>()
    let referenceSequence = PublishSubject<String>()
    
    sourceSequence
        .skipUntil(referenceSequence)
        .subscribe(onNext: { print($0) })
        .disposed(by: disposeBag)
    
    sourceSequence.onNext("🐱")
    sourceSequence.onNext("🐰")
    
    referenceSequence.onNext("🔴")
    
    sourceSequence.onNext("🐸")
}
// result: 🐸
/*:
 ----
 ## `elementAt`
 只发出指定位置的元素. [More info](http://reactivex.io/documentation/operators/elementat.html)
 ![](elementat.png)
 */
example("elementAt") {
    Observable.of("🐱", "🐰", "🐶", "🐸", "🐷", "🐵")
        .elementAt(3)
        .subscribe(onNext: { print($0) })
        .disposed(by: disposeBag)
}
/*:
 ----
 ## `single`
 发出第一个元素(或者第一个满足条件的元素). 如果满足条件的元素不止一个或者没有都会抛出异常。

 */
example("single") {
    let disposeBag = DisposeBag()
    
    Observable.of("🐱", "🐰", "🐶", "🐸", "🐷", "🐵")
        .single()
        .subscribe(onNext: { print($0) })
        .disposed(by: disposeBag)
}

example("single with conditions") {
    let disposeBag = DisposeBag()
    
    Observable.of("🐱", "🐰", "🐶", "🐸", "🐷", "🐵")
        .single { $0 == "🐸" }
        .subscribe { print($0) }
        .disposed(by: disposeBag)
    
    Observable.of("🐱", "🐰", "🐶", "🐱", "🐰", "🐶")
        .single { $0 == "🐰" }
        .subscribe { print($0) }  // error(Sequence contains more than one element.)
        .disposed(by: disposeBag)
    
    Observable.of("🐱", "🐰", "🐶", "🐸", "🐷", "🐵")
        .single { $0 == "🔵" }
        .subscribe { print($0) }  // error(Sequence doesn't contain any elements.)
        .disposed(by: disposeBag)
}
//: [Next](@next)
