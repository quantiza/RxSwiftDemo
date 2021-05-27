//: [Previous](@previous)
import RxSwift

/*:
 # Mathematical and Aggregate Operators
 对`Observable`发出的所有元素的序列进行操作
 
---
 ## `toArray`
 把一个 `Observable` sequence 转换成一个 array, emits that array as a new single-element `Observable` sequence, and then terminates. [More info](http://reactivex.io/documentation/operators/to.html)
 ![](to.c.png)
 */
example("not toArray") {
    Observable.range(start: 1, count: 5)
        .subscribe { print($0) }
        .disposed(by: disposeBag)
}
// 发出5个Next事件

example("toArray") {
    Observable.range(start: 1, count: 5)
        .toArray()
        .subscribe { print($0) }
        .disposed(by: disposeBag)
}
// 发出一个success([1, 2, 3, 4, 5])

/*:
 ----
 ## `reduce`
 从一个初始值开始，为每一个`Observable` sequence提供一个累计器闭包，返回最终结果. 与scan不同，scan返回所有中间结果. [More info](http://reactivex.io/documentation/operators/reduce.html)
 ![](reduce.png)
 */
example("reduce") {
    Observable.of(10, 100, 1000)
        .reduce(1, accumulator: +)  // + 是一个function
        .subscribe(onNext: { print($0) })
        .disposed(by: disposeBag)
}
// result: 1111

/*:
 ----
 ## `concat`
 把多个 `Observable` sequences 的元素合成一个`Observable`, 一个接一个不产生交叉. [More info](http://reactivex.io/documentation/operators/concat.html)
 ![](concat.png)
 */
example("concat") {
    let subject1 = BehaviorSubject(value: "🍎")
    let subject2 = BehaviorSubject(value: "🐶")
    
    let subjectsSubject = BehaviorSubject(value: subject1)
    
    subjectsSubject.asObservable()
        .concat()
        .subscribe { print($0) }
        .disposed(by: disposeBag)
    
    subject1.onNext("🍐")
    subject1.onNext("🍊")
    
    subjectsSubject.onNext(subject2)
    
    subject2.onNext("I would be ignored")
    subject2.onNext("🐱")
    
    subject1.onCompleted()
    
    subject2.onNext("🐭")
}

//: [Next](@next)
