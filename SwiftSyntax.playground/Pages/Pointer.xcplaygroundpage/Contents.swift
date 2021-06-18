//: [Previous](@previous)

import Foundation


struct User {
    var ID: Int
    var age: Int
    
    func printAddress() {
        let userPointer = withUnsafePointer(to: self) { $0 }
        print(userPointer)
    }
}

class Student {
    var name: String
    var age: Int
    
    init(name: String, age: Int) {
        self.name = name
        self.age = age
    }
    
    func printAddress() {
        let studentPointer = withUnsafePointer(to: self) { $0 }
        print(studentPointer)
    }
}

var user = User(ID: 1, age: 3)
let userPointer = withUnsafePointer(to: &user) { $0 }
print(userPointer.pointee)
print("===========user")
print(userPointer)
user.printAddress()

var student = Student(name: "jack", age: 10)
let studentPointer = withUnsafePointer(to: &student) { $0 }
print("===========student")
print(studentPointer)
student.printAddress()


//: [Next](@next)
