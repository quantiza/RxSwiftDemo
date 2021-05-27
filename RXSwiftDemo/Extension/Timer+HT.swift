//
//  Timer+HT.swift
//  RXSwiftDemo
//
//  Created by Yang Long on 2021/5/26.
//

import Foundation

struct Extra<Base> {
    let base: Base

}

protocol ExtraCompatible {
    associatedtype ExtraBase
    static var ht: Extra<ExtraBase>.Type { get set }
    var ht: Extra<ExtraBase> { get set }
}

extension ExtraCompatible {
    
    static var ht: Extra<Self>.Type {
        get {
            return Extra<Self>.self
        }
        set {
            
        }
    }
    
    var ht: Extra<Self> {
        get {
            return Extra(base: self)
        }
        set {
            
        }
    }
}

extension NSObject: ExtraCompatible { }

extension Extra where Base: Timer {
    static func scheduledTimer(withTimeInterval interval: TimeInterval, block: @escaping (Timer) -> Void, repeats: Bool) -> Timer {
        print("scheduledTimer===")
        return Timer.scheduledTimer(timeInterval: interval, target: TimerAction.self, selector: #selector(TimerAction.execBlock(_:)), userInfo: block, repeats: repeats)
    }
    
    class TimerAction {
        @objc class func execBlock(_ timer: Timer) {
            guard let timerClosure = timer.userInfo as? ((Timer) -> Void) else { return }
            timerClosure(timer)
        }
    }
}



