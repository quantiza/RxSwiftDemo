//: [Previous](@previous)
import Foundation

struct Person: Codable {
    var id: Int
    var name: String
    var age: Int
    var isMale: Bool
}

struct Team: Codable {
    var master: Person
    var memebers: [Person]
}

/*:
 ---
 ## JSONEncoder
 调用 JSONEncoder 的 `encode(_:)` 方法就能将 Codable 类型转换为 JSON 数据
 */
let jack = Person(id: 1, name: "Jack", age: 12, isMale: true)
if let jackData = try? JSONEncoder().encode(jack) {
    print(String(data: jackData, encoding: .utf8) ?? "")
}

/*:
 ---
 ## JSONDecoder
 调用 JSONDecoder 实例的 `decode(_:from:)` 方法就能将 JSON 对象转换得到指定类型的实例
 */
let jsonString = """
{
    "id": 2,
    "name": "lucy",
    "age": 12,
    "isMale": false
}
"""

if let json = jsonString.data(using: .utf8) {
    do {
        let lucy = try JSONDecoder().decode(Person.self, from: json)
        print(lucy)
    } catch let error {
        print(error)
    }
}

/*:
 > 如果缺少字段，decode会抛出异常
 */

/*:
 ---
 ## CodingKey
 只编码指定的Key，并且可以给Key重命名
 */

struct DescPerson: Codable {
    var id: Int
    var name: String
    var age: Int
    var isMale: Bool
    var description: String = "person"
    
    enum Keys: String, CodingKey {
        case id = "身份证号"
        case name
        case age
        case isMale
    }
}

let tim = DescPerson(id: 3, name: "tim", age: 10, isMale: true, description: "")
if let timData = try? JSONEncoder().encode(tim) {
    print(String(data: timData, encoding: .utf8)!)
}

//: [Next](@next)
