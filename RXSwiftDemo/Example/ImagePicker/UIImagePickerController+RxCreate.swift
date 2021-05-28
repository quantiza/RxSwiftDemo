//
//  UIImagePickerController+RxCreate.swift
//  RXSwiftDemo
//
//  Created by Yang Long on 2021/5/27.
//

import UIKit
import RxSwift
import RxCocoa

func dismissViewController(_ viewController: UIViewController, animated: Bool) {
    if viewController.isBeingDismissed || viewController.isBeingPresented {
        DispatchQueue.main.async {
            dismissViewController(viewController, animated: animated)
        }
        return
    }
    
    if viewController.presentingViewController != nil {
        viewController.dismiss(animated: animated, completion: nil)
    }
}


extension Reactive where Base: UIImagePickerController {
    static func createWithParent(_ parent: UIViewController?, animated: Bool = true, configureImagePicker: @escaping (UIImagePickerController) throws -> Void = { x in }) -> Observable<UIImagePickerController> {
        return Observable.create { [weak parent] observer in
            let imagePicker = UIImagePickerController()
            let dismissDisposable = imagePicker.rx
                .didCancel
                .subscribe(onNext: { [weak imagePicker] _ in
                    guard let imagePicker = imagePicker else {
                        return
                    }
                    dismissViewController(imagePicker, animated: animated)
                })
            
            do {
                try configureImagePicker(imagePicker)
            }
            catch let error {
                observer.on(.error(error))
                return Disposables.create()
            }

            guard let parent = parent else {
                observer.on(.completed)
                return Disposables.create()
            }

            parent.present(imagePicker, animated: animated, completion: nil)
            observer.on(.next(imagePicker))
            
            return Disposables.create(dismissDisposable, Disposables.create {
                    dismissViewController(imagePicker, animated: animated)
                })
        }
    }
}

//extension Reactive where Base: UIImagePickerController {
//    static func createWithParent(_ parent: UIViewController?, animated: Bool = true, configureImagePicker: @escaping (UIImagePickerController) throws -> Void = {x in }) -> Observable<UIImagePickerController> {
//        return Observable.create { [weak parent] observer in
//            let imagePicker = UIImagePickerController()
//            let dismissDisposable = imagePicker.rx
//                .didCancel
//                .subscribe(onNext: { [weak imagePicker] in
//                    guard let imagePicker = imagePicker else { return }
//                    dismissViewController(imagePicker, animated: animated)
//                })
//
//            do {
//                try configureImagePicker(imagePicker)
//            }
//            catch let error {
//                observer.onError(error)
//                return Disposables.create()
//            }
//
//            guard let parent = parent else {
//                observer.onCompleted()
//                return Disposables.create()
//            }
//
//            parent.present(imagePicker, animated: animated, completion: nil)
//            observer.onNext(imagePicker)
//
//            return Disposables.create(dismissDisposable, Disposables.create {
//                dismissViewController(imagePicker, animated: animated)
//            })
//        }
//    }
//}
