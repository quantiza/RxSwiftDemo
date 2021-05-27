import Foundation
import RxSwift

public let disposeBag = DisposeBag()

public func example(_ desciption: String, action: () -> Void) {
    printExampleHeader(desciption)
    action()
}

public func printExampleHeader(_ description: String) {
    print("\n--- \(description) example ---")
}

public func delay(_ delay: Double, closure: @escaping () -> Void) {
    DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
        closure()
    }
}

public enum TestError: Swift.Error {
    case test
}
