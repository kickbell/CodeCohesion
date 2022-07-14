//
//  BaseViewController.swift
//  CodeCohesion
//
//  Created by ios on 2022/07/14.
//

import UIKit
import RxSwift

class BaseViewController: UIViewController {
    
    var disposeBag = DisposeBag()

    // MARK: Layout Constraints

    private(set) var didSetupConstraints = false

    override func viewDidLoad() {
      self.view.setNeedsUpdateConstraints()
    }

    override func updateViewConstraints() {
      if !self.didSetupConstraints {
        self.setupConstraints()
        self.didSetupConstraints = true
      }
      super.updateViewConstraints()
    }

    func setupConstraints() {
      // Override point
    }

}
