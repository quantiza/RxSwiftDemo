//: [Previous](@previous)

import RxSwift

/*:
# Connectable Operators
 Connectable `Observable` sequences 与 `Observable` sequences 不同之处是它被订阅时不会发出事件，只有调用`connect()`时才发出事件. 因此可以自己选择事件发生时机.
 
---
 先看一个不使用connectable操作的例子:
*/
func sampleWithoutConnectableOperators() {
    printExampleHeader(#function)
    
    let interval = Observable<Int>.interval(.seconds(1), scheduler: MainScheduler.instance)
    
    _ = interval
        .subscribe(onNext: { print("Subscription: 1, Event: \($0)") })
    
    delay(5) {
        _ = interval
            .subscribe(onNext: { print("Subscription: 2, Event: \($0)") })
    }
}

//sampleWithoutConnectableOperators()

/*:
 ----
 ## `publish`
 把一个普通的`Observable`转换成一个connectable `Observable`. [More info](http://reactivex.io/documentation/operators/publish.html)
 
 ![](publishConnect.c.png)
 */
func sampleWithPublish() {
    printExampleHeader(#function)
    
    let intSequence = Observable<Int>.interval(.seconds(1), scheduler: MainScheduler.instance).publish()
    
    _ = intSequence
        .subscribe(onNext: { print("Subscription 1:, Event: \($0)") })
    
    delay(2) {
        _ = intSequence.connect()
    }
    
    delay(4) {
        _ = intSequence
            .subscribe(onNext: { print("Subscription 2:, Event: \($0)") })
    }
    
    delay(6) {
        _ = intSequence
            .subscribe(onNext: { print("Subscription 3:, Event: \($0)") })
    }
}

//sampleWithPublish()

/*:
 ----
 ## `replay`
 会发送 `bufferSize` 数量之前的事件给新的观察者. [More info](http://reactivex.io/documentation/operators/replay.html)
 ![](replay.c.png)
 */
func sampleWithReplayBuffer() {
    printExampleHeader(#function)
    
    let intSequence = Observable<Int>.interval(.seconds(1), scheduler: MainScheduler.instance)
        .replay(5)
    
    _ = intSequence
        .subscribe(onNext: { print("Subscription 1:, Event: \($0)") })
    
    delay(2) { _ = intSequence.connect() }
    
    delay(4) {
        _ = intSequence
            .subscribe(onNext: { print("Subscription 2:, Event: \($0)") })
    }
    
    delay(8) {
        _ = intSequence
            .subscribe(onNext: { print("Subscription 3:, Event: \($0)") })
    }
}

//sampleWithReplayBuffer()

/*:
 ----
 ## `multicast`
 Converts the source `Observable` sequence into a connectable sequence, and broadcasts its emissions via the specified `subject`.
 */

func sampleWithMulticast() {
    printExampleHeader(#function)
    
    let subject = PublishSubject<Int>()
    
    _ = subject
        .subscribe(onNext: { print("Subject: \($0)") })
    
    let intSequence = Observable<Int>.interval(.seconds(1), scheduler: MainScheduler.instance)
        .multicast(subject)
    
    _ = intSequence
        .subscribe(onNext: { print("\tSubscription 1:, Event: \($0)") })
    
    delay(2) { _ = intSequence.connect() }
    
    delay(4) {
        _ = intSequence
            .subscribe(onNext: { print("\tSubscription 2:, Event: \($0)") })
    }
    
    delay(6) {
        _ = intSequence
            .subscribe(onNext: { print("\tSubscription 3:, Event: \($0)") })
    }
}
sampleWithMulticast()

//: [Next](@next)
