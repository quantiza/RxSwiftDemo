//: [Previous](@previous)

import Foundation

// timer
print("=========")
let _ = Timer.ht.scheduledTimer(withTimeInterval: 1.0, block: { _ in
    print("..........")
}, repeats: true)


// flatmap optional

let optionals : [String?] = ["a", "b", nil, "d"]
let nonOptionals = optionals.compactMap{ $0 }
print(nonOptionals)


print(Int("") ?? "aaa")

//: [Next](@next)
