//
//  RxImagePickerProxy.swift
//  CodeCohesion
//
//  Created by ios on 2022/07/06.
//

import UIKit
import RxSwift
import RxCocoa

public typealias ImagePickerDelegate = UIImagePickerControllerDelegate & UINavigationControllerDelegate

extension UIImagePickerController: HasDelegate {
    public typealias Delegate = ImagePickerDelegate
}

class RxImagePickerProxy: DelegateProxy<UIImagePickerController, ImagePickerDelegate>, DelegateProxyType, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // MARK: - Require Method
    
    public init(imagePicker: UIImagePickerController) {
        super.init(parentObject: imagePicker, delegateProxy: RxImagePickerProxy.self)
    }
    
    static func registerKnownImplementations() {
        self.register { RxImagePickerProxy(imagePicker: $0) }
    }
    
    static func currentDelegate(for object: UIImagePickerController) -> ImagePickerDelegate? {
        return object.delegate
    }
    
    static func setCurrentDelegate(_ delegate: ImagePickerDelegate?, to object: UIImagePickerController) {
        object.delegate = delegate
    }
    
    // MARK: - UIImagePickerControllerDelegate
    
    lazy var didFinishPickingMediaWithInfoSubject = PublishSubject<[UIImagePickerController.InfoKey : Any]>()
    lazy var didCancelSubject = PublishSubject<Void>()
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        didFinishPickingMediaWithInfoSubject.onNext(info)
        didFinishPickingMediaWithInfoSubject.onCompleted()
        didCancelSubject.onCompleted()
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        didCancelSubject.onNext(())
        didCancelSubject.onCompleted()
        didFinishPickingMediaWithInfoSubject.onCompleted()
    }
    
    deinit {
        self.didFinishPickingMediaWithInfoSubject.onCompleted()
        self.didCancelSubject.onCompleted()
    }
    
}


