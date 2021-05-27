
/*:
 ## Associated Types
 
 定义一个protocol时会声明一个或多个关联类型作为protocol定义的一部分。associated type作为protocol里的类型占位，直到protocol被使用时才确定associated type的具体类型。这个特性属于Generic的一部分
 
> 1. [Apple Doc.](https://docs.swift.org/swift-book/LanguageGuide/Generics.html)

 */

protocol Container {
    associatedtype Item
    mutating func append(_ item: Item)
    var count: Int { get }
    subscript(i: Int) -> Item { get }
}

struct Stack<Element>: Container {
    // original Stack<Element> implementation
    var items = [Element]()
    mutating func push(_ item: Element) {
        items.append(item)
    }
    mutating func pop() -> Element {
        return items.removeLast()
    }
    // conformance to the Container protocol
    mutating func append(_ item: Element) {
        self.push(item)
    }
    var count: Int {
        return items.count
    }
    subscript(i: Int) -> Element {
        return items[i]
    }
}


/*:
 ---
 ## Self self Type
 Type表示metaType, Protocol里的Self代表类型本身
> 1. [理解 Swift 中的元类型：.Type 与 .self](https://juejin.cn/post/6844903725199261710)
> 2. [What's .self, .Type and .Protocol? Understanding Swift Metatypes](https://swiftrocks.com/whats-type-and-self-swift-metatypes.html)
 */
// example 1
let a: Int = 5
let b: Int.Type = Int.self  // .Type 是类型名称，.self是类型的值

// example 2
protocol ContentCell { }

struct IntCell: ContentCell {
    var value: Int
}

struct StringCell: ContentCell {
    var value: String
}

func createCell(type: ContentCell.Type) -> ContentCell? {
    if let intCell = type as? IntCell.Type {
        return intCell.init(value: 4)
    } else if let stringCell = type as? StringCell.Type {
        return stringCell.init(value: "xx")
    }
    return nil
}

// example 3

struct SwiftRocks {
    static let author = "Bruno Rocha"
    func postArticle(name: String) {}
}

let blog: SwiftRocks = SwiftRocks()
let something = type(of: blog)  //SwiftRocks.Type

// example 4

protocol Copyable {
    func copy() -> Self  // Self会被替换具体的协议实现类型
}

class MMyClass: Copyable {
    var num = 1
    func copy() -> Self {
        let result = type(of: self).init()
        result.num  = num
        return result
    }

    //必须实现
    //如果不实现：Constructing an object of class type 'Self' with a metatype value must use a 'required' initializer。错误
    required init() {
    }
}
