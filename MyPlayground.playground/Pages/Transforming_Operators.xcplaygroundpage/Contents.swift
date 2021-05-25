//: [Previous](@previous)

import RxSwift

/*:
# Transforming Operators
转换一个`Observable` sequence发出的Next事件
 
---
 ## `map`
 把一个 `Observable` sequence的各个元素统一变换后生成一个新的  `Observable` sequence. [More info](http://reactivex.io/documentation/operators/map.html)
![map](map.png)
*/

// 1,2,3 -> 1,4,9
example("map") {
    Observable.of(1, 2, 3)
        .map { $0 * $0 }
        .subscribe(onNext: { print($0) })
        .disposed(by: disposeBag)
}

/*:
 ----
 ## `flatMap` and `flatMapLatest`
 Transforms the elements emitted by an `Observable` sequence into `Observable` sequences, and merges the emissions from both `Observable` sequences into a single `Observable` sequence. This is also useful when, for example, when you have an `Observable` sequence that itself emits `Observable` sequences, and you want to be able to react to new emissions from either `Observable` sequence. The difference between `flatMap` and `flatMapLatest` is, `flatMapLatest` will only emit elements from the most recent inner `Observable` sequence. [More info](http://reactivex.io/documentation/operators/flatmap.html)
 ![](flatmap.png)
 */

example("flatMap and flatMapLatest") {
    struct Player {
        let score: BehaviorSubject<Int>
        init(score: Int) {
            self.score = BehaviorSubject(value: score)
        }
    }
    
    let 👦🏻 = Player(score: 80)
    let 👧🏼 = Player(score: 90)
    
    let player = BehaviorSubject(value: 👦🏻)
    
    player.flatMap { $0.score.asObservable() }  // Change flatMap to flatMapLatest and observe change in printed output
        .subscribe(onNext: { print($0) })
        .disposed(by: disposeBag)
    
    👦🏻.score.onNext(85)
    
    player.onNext(👧🏼)
    
    👦🏻.score.onNext(95) // Will be printed when using flatMap, but will not be printed when using flatMapLatest
    
    👧🏼.score.onNext(100)
    
}

/*:
 ----
 ## `scan`
 从一个初始值开始，然后为每一个`Observable` sequence提供一个累计器闭包，返回每一个中间结果组成一个单元素的 `Observable` sequence. [More info](http://reactivex.io/documentation/operators/scan.html)
 ![](scan.png)
 */
example("scan") {
    
    Observable.of(10, 100, 1000)
        .scan(1) { aggregateValue, newValue in
            aggregateValue + newValue
        }
        .subscribe(onNext: { print($0) })
        .disposed(by: disposeBag)
}

//: [Next](@next)
