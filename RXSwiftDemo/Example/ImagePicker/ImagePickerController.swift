//
//  ImagePickerController.swift
//  RXSwiftDemo
//
//  Created by Yang Long on 2021/5/27.
//

import UIKit
import RxSwift
import RxCocoa

/// 需要先注册 RxImagePickerDelegateProxy.register

class ImagePickerController: UIViewController {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var cameraButton: UIButton!
    @IBOutlet weak var galleryButton: UIButton!
    @IBOutlet weak var cropButton: UIButton!
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        galleryButton.rx.tap
            .flatMapLatest { [weak self] _ in
                return UIImagePickerController.rx.createWithParent(self) { picker in
                    picker.sourceType = .photoLibrary
                    picker.allowsEditing = false
                }
                .flatMap {
                    $0.rx.didFinishPickingMediaWithInfo
                }
                .take(1)
            }
            .map { info in
                return info[UIImagePickerController.InfoKey.originalImage.rawValue] as? UIImage
            }
            .bind(to: imageView.rx.image)
            .disposed(by: disposeBag)

//        let imagePicker = UIImagePickerController()
//
//
//        galleryButton.rx
//            .tap
//            .subscribe(onNext: { [weak self] _ in
//                print("tap next")
//                self?.present(imagePicker, animated: true, completion: nil)
//            })
//            .disposed(by: disposeBag)
//
//
//        imagePicker.rx
//            .didFinishPickingMediaWithInfo
//            .take(1)
//            .map { info in
//                return info[UIImagePickerController.InfoKey.originalImage.rawValue] as? UIImage
//            }
//            .bind(to: imageView.rx.image)
//            .disposed(by: disposeBag)
        
//        galleryButton.rx.tap
//            .flatMapLatest { [weak self] in
//                return UIImagePickerController.rx.createWithParent(self) { picker in
//                    picker.sourceType = .photoLibrary
//                    picker.allowsEditing = false
//                }
//                .flatMap { $0.rx.didFinishPickingMediaWithInfo }
//                .take(1)
//            }
//            .map { info in
//                print("map....")
//                return info[UIImagePickerController.InfoKey.originalImage.rawValue] as! UIImage
//            }
//
//            .bind(to: imageView.rx.image)
//            .disposed(by: disposeBag)
    }
}
