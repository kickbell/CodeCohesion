//
//  SelectorViewController.swift
//  CodeCohesion
//
//  Created by ios on 2022/07/06.
//

import UIKit

class SelectorViewController: UIViewController {
    
    private let keyboardEventWrapper = KeyboardEventWrapper()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupKeyboardEvent()
    }
    
    func setupKeyboardEvent() {
        
        keyboardEventWrapper.onKeyboardWillShowCallback = { notification in
            
        }
        
        keyboardEventWrapper.onKeyboardWillHideCallback = { notification in
            
        }
    }
    
}
