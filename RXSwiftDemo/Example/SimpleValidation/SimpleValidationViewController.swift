//
//  SimpleValidationViewController.swift
//  RXSwiftDemo
//
//  Created by Yang Long on 2021/5/25.
//

import UIKit
import RxSwift
import RxCocoa

private let minimalUsernameLength = 5
private let minimalPasswordLength = 5

class SimpleValidationViewController: UIViewController {

    @IBOutlet weak var usernameTF: UITextField!
    @IBOutlet weak var usernameValidLabel: UILabel!
    
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var passwordValidLabel: UILabel!
    
    @IBOutlet weak var doBtn: UIButton!
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        usernameValidLabel.text = "Username has to be at least \(minimalUsernameLength) characters"
        passwordValidLabel.text = "Password has to be at least \(minimalPasswordLength) characters"
        
        let usernameValid = usernameTF.rx.text.orEmpty
            .map { $0.count >= minimalUsernameLength }
            .share()
        
        let passwordValid = passwordTF.rx.text.orEmpty
            .map { $0.count >= minimalPasswordLength }
            .share()
        
        let everythingValid = Observable.combineLatest(usernameValid, passwordValid) { $0 && $1 }
            .share()
        
        // Example 0
//        usernameValid.subscribe(onNext: {[weak self] in
//            self?.passwordTF.isEnabled  = $0
//        })
//        .disposed(by: disposeBag)
        
        // Example 1, subscribe
        usernameValid
            .subscribe(passwordTF.rx.isEnabled)
            .disposed(by: disposeBag)
        
        usernameValid
            .subscribe(usernameValidLabel.rx.isHidden)
            .disposed(by: disposeBag)
        
        passwordValid
            .subscribe(passwordValidLabel.rx.isHidden)
            .disposed(by: disposeBag)
        
        everythingValid
            .subscribe(doBtn.rx.isEnabled)
            .disposed(by: disposeBag)
        
        
        
        // Example 2, bind
//        usernameValid
//            .bind(to: passwordTF.rx.isEnabled)
//            .disposed(by: disposeBag)
        
//        usernameValid
//            .bind(to: usernameValidLabel.rx.isHidden)
//            .disposed(by: disposeBag)
        
//        passwordValid
//            .bind(to: passwordValidLabel.rx.isHidden)
//            .disposed(by: disposeBag)
        
//        everythingValid
//            .bind(to: doBtn.rx.isEnabled)
//            .disposed(by: disposeBag)
        
        doBtn.rx.tap
            .subscribe(onNext: { print("RxExample is wonderful!!") })
            .disposed(by: disposeBag)
    }
}
