//
//  KeyboardEventWrapper.swift
//  CodeCohesion
//
//  Created by ios on 2022/07/06.
//

import UIKit

class KeyboardEventWrapper {
    
    var onKeyboardWillShowCallback: (Notification) -> () = { _ in }
    var onKeyboardWillHideCallback: (Notification) -> () = { _ in }
    
    init() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(onKeyboardWillShow(notification:)),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(onKeyboardWillHide(notification:)),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }
    
    @objc func onKeyboardWillShow(notification: Notification) {
        onKeyboardWillShowCallback(notification)
    }
    
    @objc func onKeyboardWillHide(notification: Notification) {
        onKeyboardWillHideCallback(notification)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
}
