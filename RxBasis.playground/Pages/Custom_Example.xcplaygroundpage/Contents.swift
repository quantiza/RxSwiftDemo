//: [Previous](@previous)

import RxSwift

/*:
 ---
 ## share replay
 share 会共享操作结果，省略中间的操作过程，一个Observerbal被多次订阅时尽量使用share，例子中share和share replay的效果是一样的。replay会向Observer重播订阅之前的事件
 */


/*:
    
 */
example("no share") {
    
    let subject = PublishSubject<Int>()

    let signal = subject
        .map { item -> Int in
            print("map operation!")
            return item * item
        }
    
    signal
        .subscribe(onNext: { print("subscribe 01: ", $0) })
        .disposed(by: disposeBag)
    
    signal
        .subscribe(onNext: { print("subscribe 02: ", $0) })
        .disposed(by: disposeBag)
    
    subject.onNext(1)
    subject.onNext(2)
    subject.onNext(3)
}

example("share") {
    
    let subject = PublishSubject<Int>()

    let signal = subject
        .map { item -> Int in
            print("map operation!")
            return item * item
        }
        .share()
    
    signal
        .subscribe(onNext: { print("subscribe 01: ", $0) })
        .disposed(by: disposeBag)
    
    signal
        .subscribe(onNext: { print("subscribe 02: ", $0) })
        .disposed(by: disposeBag)
    
    subject.onNext(1)
    subject.onNext(2)
    subject.onNext(3)
}

example("share replay") {
    
    let subject = PublishSubject<Int>()

    let signal = subject
        .map { item -> Int in
            print("map operation!")
            return item * item
        }
        .share(replay: 1)
    
    signal
        .subscribe(onNext: { print("subscribe 01: ", $0) })
        .disposed(by: disposeBag)
    
    signal
        .subscribe(onNext: { print("subscribe 02: ", $0) })
        .disposed(by: disposeBag)
    
    subject.onNext(1)
    subject.onNext(2)
    subject.onNext(3)
}


//: [Next](@next)
