import Foundation
import RxSwift

public let disposeBag = DisposeBag()

public func example(_ desciption: String, action: () -> Void) {
    printExampleHeader(desciption)
    action()
}

func printExampleHeader(_ description: String) {
    print("\n--- \(description) example ---")
}
