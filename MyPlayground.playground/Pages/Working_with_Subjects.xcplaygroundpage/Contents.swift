//: [Previous](@previous)

import RxSwift

/*:
 # Working with Subjects
 Subject既是observer又是`Observable`，所以它能订阅一个或多个`Observable`s, 也可以传递和发出事件
 */


/*:
 ---
 ## PublishSubject
 在观察者的订阅期，向所有的观察者广播事件
 
 ![PublishSubject](S.PublishSubject.png)
 */

example("PublishSubject") {
    let subject = PublishSubject<String>()
    
    subject.subscribe { print("Subscription:", 1, "Event:", $0) }.disposed(by: disposeBag)
    subject.onNext("🐶")
    subject.onNext("🐱")
    
    subject.subscribe { print("Subscription:", 2, "Event:", $0) }.disposed(by: disposeBag)
    subject.onNext("🅰️")
    subject.onNext("🅱️")
}
/*:
> `onNext(_:)` 方法等价于 `on(.next(_:)`
 */
/*:
 ---
 ## ReplaySubject
 向所有的观察者广播事件，为之前的事件指定`bufferSize`通知给新的观察者
 
 ![ReplaySubject](S.ReplaySubject.png)
 */

example("ReplaySubject") {
    let subject = ReplaySubject<String>.create(bufferSize: 1)
    
    subject.subscribe { print("Subscription:", 1, "Event:", $0) }.disposed(by: disposeBag)
    subject.onNext("🐶")
    subject.onNext("🐱")
    
    subject.subscribe { print("Subscription:", 2, "Event:", $0) }.disposed(by: disposeBag)
    subject.onNext("🅰️")
    subject.onNext("🅱️")
}

/*:
 ----
## BehaviorSubject
 向所有的观察者广播事件, 向新的观察者发送最近一次事件(或初始事件)
 
![BehaviorSubject](S.BehaviorSubject.png)
*/

example("BehaviorSubject") {
    let subject = BehaviorSubject(value: "🔴")
    
    subject.subscribe { print("Subscription:", 1, "Event:", $0) }.disposed(by: disposeBag)
    subject.onNext("🐶")
    subject.onNext("🐱")
    
    subject.subscribe { print("Subscription:", 2, "Event:", $0) }.disposed(by: disposeBag)
    subject.onNext("🅰️")
    subject.onNext("🅱️")
    
    subject.subscribe { print("Subscription:", 3, "Event:", $0) }.disposed(by: disposeBag)
    subject.onNext("🍐")
    subject.onNext("🍊")
}

/*:
 > `PublishSubject`, `ReplaySubject` 和 `BehaviorSubject`在即将释放时不会自动发出 Completed 事件
*/

//: [Next](@next)
