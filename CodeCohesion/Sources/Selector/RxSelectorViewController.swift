//
//  RxSelectorViewController.swift
//  CodeCohesion
//
//  Created by ios on 2022/07/06.
//

import UIKit
import RxSwift
import RxCocoa
import NSObject_Rx

class RxSelectorViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupKeyboardEvent()
    }
    
    private func setupKeyboardEvent() {
        NotificationCenter.default.rx.notification(UIResponder.keyboardWillShowNotification)
            .subscribe(onNext: { notification in
                
            })
            .disposed(by: rx.disposeBag)
        
        NotificationCenter.default.rx.notification(UIResponder.keyboardWillHideNotification)
            .subscribe(onNext: { notification in 
                
            })
            .disposed(by: rx.disposeBag)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
