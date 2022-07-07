//
//  BaseViewController.swift
//  CodeCohesion
//
//  Created by ios on 2022/07/06.
//

import UIKit

class BaseViewController: UIViewController {
    
    var viewWillAppearActions: [(Bool) -> ()] = []
    var viewWillDisappearActions: [(Bool) -> ()] = []
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewWillAppearActions.forEach { $0(animated) }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        viewWillDisappearActions.forEach { $0(animated) }
    }
    
}

class ChildViewController: BaseViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
    }
    
    func setupNavigationBar() {
        self.navigationController?.title = "App Title"
        
        viewWillAppearActions.append { [weak self] animated in
            guard let `self` = self else { return }
            self.navigationController?.setNavigationBarHidden(false, animated: animated)
        }
        
        viewWillDisappearActions.append { [weak self] animated in
            guard let `self` = self else { return }
            self.navigationController?.setNavigationBarHidden(true, animated: animated)
        }
    }
    
}
