//
//  RxChildViewController.swift
//  CodeCohesion
//
//  Created by ios on 2022/07/06.
//

import UIKit
import NSObject_Rx
import RxSwift
import RxCocoa
import RxViewController

class RxChildViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
    }
    
    private func setupNavigationBar() {
        self.navigationController?.title = "App Title"
        
        self.rx.viewWillAppear
            .subscribe(onNext: { [weak self] animated in
                self?.navigationController?.setNavigationBarHidden(false, animated: animated)
            })
            .disposed(by: rx.disposeBag)
        
        self.rx.viewWillDisappear
            .subscribe(onNext: { [weak self] animated in
                self?.navigationController?.setNavigationBarHidden(true, animated: animated)
            })
            .disposed(by: rx.disposeBag)
    }
    
}
