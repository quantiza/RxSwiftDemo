//: [Previous](@previous)

import Foundation

// https://developer.apple.com/swift/blog/?id=6
// https://onevcat.com/2015/01/swift-pointer/ (**)
// https://juejin.cn/post/6844903872905871367
// https://www.jianshu.com/p/c869891e13a8 (*****)
// https://www.vadimbulavin.com/swift-pointers-overview-unsafe-buffer-raw-and-managed-pointers/ (*****)
// https://zhuanlan.zhihu.com/p/380637263 (*****)

/*:
 ---
 # 说明
 
 可以使用 `UnsafePointer` 类型实例去访问内存中特定类型的数据, 通过pointer的 `Pointee` 访问数据。`UnsafePointer` 不会提供ARC也不保证内存对齐, 你要自己处理pointer相关内存的生命周期。
 
 你手动管理的内存可能是 *untyped* 或者是 *bound* to 一个特定的type.
 */
/*:
 ---
 # Understanding a Pointer's Memory State (指针内存状态)
 
 `UnsafePointer` 实例指向的内存可以是多种状态之一, 我们简称为指针状态(pointer state, 实际是指针指向的内存的状态). 许多pointer操作只能作用于特定状态的pointer---你必须记录指针状态并理解不同操作对指针状态的影响. pointer state可以有以下几种
 
 * untyped
 * uninitialized
 * bound to a type and uninitialized
 * bound to a type and initialized to a value
 
 最终, 申请的内存应该被释放掉
 ### Uninitialized Memory
 
 有两种情况内存是未初始化的
 * 仅仅通过指针分配的内存,还没有初始化的
 * 一个初始化的指针进行deinitialized操作之后
 未初始化的内存在访问之前必须要初始化
 ### Initialized Memory
 
 初始化的内存有一个值可以通过指针的 `pointee` 属性或下标方式访问.
 
 */
var value = 23
let ptr00: UnsafePointer<Int> = withUnsafePointer(to: &value) { $0 }
// ptr00.pointee == 23
// ptr00[0] == 23

/*:
 ---
 # Accessing a Pointer's Memory as a Different Type (内存访问)
 
 当你通过 `UnsafePointer` 来访问内存时, `Pointee` 类型必须要和内存绑定的类型一致. 如果你访问的内存绑定了不同的类型, Swift指针
 提供了临时的或永久的改变内存绑定类型的方式, 或者直接从原始内存(raw memory)里获取类型实例(typed instances).
 
 ### 临时绑定 `withMemoryRebound(to:capacity:)`
 如果你仅需要临时获取一个指针指向的内存并绑定不同的类型, 可以使用 `withMemoryRebound(to:capacity:)` 方法. 例如有一个API需要的指针类型与你的指针 `Pointee` 类型不同, 你可以使用这个方法. 一块内存区域一次仅可以绑定一种类型, 所以用首次绑定内存不相关的类型来访问内存是非法的
 去调用这个API. 下面的代码
 */

func strlen(_ __s: UnsafePointer<Int8>!) -> UInt {
    return 0
}

// UnsafePointer
var uint8Value: UInt8 = 12
let uint8Pointer: UnsafePointer<UInt8> = withUnsafePointer(to: &uint8Value) { $0 }

let length = uint8Pointer.withMemoryRebound(to: Int8.self, capacity: 8) {
    return strlen($0)
}

// UnsafeMutablePointer
var bytes: [UInt8] = [39, 77, 111, 111, 102, 33, 39, 0]
let uint8Pointer2 = UnsafeMutablePointer<UInt8>.allocate(capacity: 8)
uint8Pointer2.initialize(from: bytes, count: 8)
print(uint8Pointer2.pointee)

var value2 = 11
uint8Pointer2.initialize(to: UInt8(value2))
print(uint8Pointer2.pointee)

/*:
 ### 永久绑定 `bindMemory(to:capacity:)`
 当你需要永久性地把内存绑定另外一个类型时, 首先要获得指向内存的raw指针, 然后用raw指针调用 `bindMemory(to:capacity:)`方法. 例子如下
 */

let uint64Pointer = UnsafeRawPointer(uint8Pointer).bindMemory(to: UInt64.self, capacity: 1)

/*:
 `uint8Pointer` 指向的内存绑定了 `UInt64` 类型之后, 再用 `uint8Pointer` 访问的内存就是undefined.
 */

var fullInteger = uint64Pointer.pointee    // OK
var firstByte = uint8Pointer.pointee       // undefined

/*:
 或者你可以不用rebind, 也能以某个类型方式来访问untyped内存区域, 只要绑定类型和目标类型是普通类型(trivial types). 把指针转换为`UnsafeRawPointer`实例, 然后通过 `load(fromByteOffset:as:)` 方法来获取值.
 */
let rawPointer = UnsafeRawPointer(uint64Pointer)
let fullInteger2 = rawPointer.load(as: UInt64.self)  // OK
let firstByte2 = rawPointer.load(as: UInt8.self)     // OK

/*:
 ---
 # Performing Typed Pointer Arithmetic (指针算术)
 
 类型指针(typed pointer)算术会以`Pointee` 类型为步长(stride)进行计数. 用一个 `UnsafePointer` 进行加减操作获得的结果是一个相同类型的新指针, 这个新指针相对原来的指针偏移了一定数量的 `Pointee` 类型长度. 或者可以通过下标的方式来访问某个偏移的内存值. 指针偏移方式有以下几种
 - pointer arithmetic
 - subsript
 - advanced
 - successor
 */

var intArray: [Int] = [10, 20, 30, 40]

let intPointer: UnsafePointer<Int> = UnsafePointer<Int>(intArray)//withUnsafePointer(to: &intArray[0]) { $0 }
let x = intPointer.pointee
let offsetPointer = intPointer + 2
let y = offsetPointer.pointee

let z = intPointer[3]
let o = intPointer.advanced(by: 2).pointee
let p = intPointer.successor().pointee


/*:
 ---
 # Implicit Casting and Bridging
 
 - *implicit casting* : 一个函数的参数是 `UnsafePointer` , 调用这个函数时可以传入 `UnsafePointer`, 也可以传入 `UnsafeMutablePointer`
 - *implicit bridging* : 一个函数的参数是 `UnsafePointer`, 调用这个函数时可以使用inout语法(&符号), 或者直接传入数组变量(这与C指针用法相似), 当传入数组变量或使用&符号时, 会隐式创建一个相应的不可变指针.
 */

func printInt(atAddress p: UnsafePointer<Int>) {
     print(p.pointee)
 }

// implicit bridging
printInt(atAddress: intPointer)

let mutableIntPointer = UnsafeMutablePointer(mutating: intPointer)
printInt(atAddress: mutableIntPointer)  // Implicit Casting

let mutableIntPointer2 = withUnsafeMutablePointer(to: &value) { $0 }
printInt(atAddress: mutableIntPointer2)

// implicit bridging
printInt(atAddress: &value)
let numbers = [5, 10, 15, 20]
printInt(atAddress: numbers)

var mutableNumbers = numbers
printInt(atAddress: mutableNumbers)


/*:
 不论用何种方式调用 `printInt(atAddress:)`, Swift的类型安全都会保证你只能传递函数所需类型的指针.
 
 > 隐式创建的数组指针只在函数调用时有效, 除此之外不会进行 *implicit bridging*
 */

var number = 5
let numberPointer = UnsafePointer<Int>(&number) // Accessing 'numberPointer' is undefined behavior.
print(numberPointer.pointee)




func incrementor(ptr: UnsafeMutablePointer<Int>) {
    ptr.pointee += 1
}

var a = 10
incrementor(ptr: &a)
print(a)

func incrementor1(num: inout Int) {
    num += 1
}

var b = 10
incrementor1(num: &b)
print(b)

var intPtr = UnsafeMutablePointer<Int>.allocate(capacity: 1)
intPtr.initialize(to: 10)
print(intPtr, intPtr.pointee)

intPtr.deinitialize(count: 64)
print(intPtr, intPtr.pointee)

intPtr.deallocate()
print(intPtr, intPtr.pointee)

// 为何这些方法都没用, 把Int换成Class类型看看


// MemoryLayout
print("------------MemoryLayout------------")
print(MemoryLayout<Int8>.size)
print(MemoryLayout<Int16>.size)
print(MemoryLayout<Int32>.size)
print(MemoryLayout<Int>.size)


// WithUnsafePointer
print("------------WithUnsafePointer------------")
var c = 0
withUnsafePointer(to: &c) { ptr in
    print(ptr)
}

//c = withUnsafePointer(to: &c, { ptr in
//    ptr.pointee + 2
//})

withUnsafeMutablePointer(to: &c) { ptr in
    ptr.pointee = 2
}

print(c)
withUnsafePointer(to: &c) { ptr in
    print(ptr)
}

struct User {
    var name: Int = 5

    init(name: Int = 5) {
        self.name = name
    }
}
var user = User()

let pointer = withUnsafeMutablePointer(to: &user) { $0 }
pointer.pointee.name = 10

print(user)


// Unmanaged




// 访问结构体实例对象

print("------------访问结构体实例对象------------")
struct Teacher {
    var age = 10
    var height = 1.85
}
var t = Teacher()
let ptr = UnsafeMutablePointer<Teacher>.allocate(capacity: 2)
ptr.initialize(to: Teacher())
ptr.successor().initialize(to: Teacher(age: 11, height: 1.75))
ptr.advanced(by: 2).initialize(to: Teacher(age: 12, height: 1.80))
(ptr+3).initialize(to: Teacher(age: 13, height: 1.80))

print(ptr.pointee)
print(ptr.successor().pointee)
print(ptr.advanced(by: 2).pointee) // 如果是raw pointer, by 后面就是字节
print(ptr[3])

ptr.deinitialize(count: 2)
ptr.deallocate()

// 实例对象绑定到struct内存
print("------------实例对象绑定到struct内存------------")
struct HeapObject {
    var kind: Int
    var strongRef: UInt32
    var unownedRef: UInt32
}

class CTeacher{
    var age = 18
}

var ct = CTeacher()

let ptr2 = Unmanaged.passUnretained(ct).toOpaque()
let heapObject = ptr2.bindMemory(to: HeapObject.self, capacity: 1)   // bind memory 到底是干嘛用的

print("heapObject.pointee.kind: \(heapObject.pointee.kind)")
print("heapObject.pointee.strongRef: \(heapObject.pointee.strongRef)")
print("heapObject.pointee.unownedRef: \(heapObject.pointee.unownedRef)")


// 元组指针类型转换
print("-------------元组指针类型转换-----------")
var tul = (10, 20)
func testPointer(_ p: UnsafePointer<Int>) {
    print(p)
}

withUnsafePointer(to: &tul) {
    testPointer(UnsafeRawPointer($0).assumingMemoryBound(to: Int.self))
}

// 如何获取结构体的属性的指针

struct HeapObject2 {
    var strongRef: UInt32 = 10
    var unownedRef: UInt32 = 20
}

//实例化
var  t2 = HeapObject2()
//获取结构体属性的指针传入函数
withUnsafePointer(to: &t2) { (ptr: UnsafePointer<HeapObject2>) in
    //获取变量
    let strongRef = UnsafeRawPointer(ptr) + MemoryLayout<HeapObject>.offset(of: \HeapObject.strongRef)!
    //传递strongRef属性的值
    testPointer(strongRef.assumingMemoryBound(to: Int.self))
}


// 通过 withMemoryRebound 临时绑定内存类型

var age = 10

let ptr3 = withUnsafePointer(to: &age) {$0}
ptr3.withMemoryRebound(to: Int.self, capacity: 1) { (ptr: UnsafePointer<Int>)  in
    testPointer(ptr)
}



//struct User {
//    var ID: Int
//    var age: Int
//
//    func printAddress() {
//        let userPointer = withUnsafePointer(to: self) { $0 }
//        print(userPointer)
//    }
//}
//
//class Student {
//    var name: String
//    var age: Int
//
//    init(name: String, age: Int) {
//        self.name = name
//        self.age = age
//    }
//
//    func printAddress() {
//        let studentPointer = withUnsafePointer(to: self) { $0 }
//        print(studentPointer)
//    }
//}
//
//var user = User(ID: 1, age: 3)
//let userPointer = withUnsafePointer(to: &user) { $0 }
//print(userPointer.pointee)
//print("===========user")
//print(userPointer)
//user.printAddress()
//
//var student = Student(name: "jack", age: 10)
//let studentPointer = withUnsafePointer(to: &student) { $0 }
//print("===========student")
//print(studentPointer)
//student.printAddress()


//: [Next](@next)
