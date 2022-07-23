//
//  BaseViewController.swift
//  CodeCohesion
//
//  Created by ios on 2022/07/14.
//

import UIKit
import RxSwift

class BaseViewController: UIViewController {
    
    // MARK: Initializing
    
    /*
     UIViewController 는 이니셜라이저를 2개 가지고 있다.
     init(nibName: nil, bundle: nil) 과 init?(coder: NSCoder).
     그런데, BaseViewController는 UIViewController를 상속했다.
     
     그리고 커스텀 이니셜라이저를 구현했다.
     bv는 uivc를 상속하고 있고, 클래스이므로 꼭 이니셜라이저 위임 super.init(nibname:, bundle:) 을 해야한다.
     그래야 super class의 속성이나 그런것들을 다 갖고올 수 있으니까.
     
     그리고 커스텀 지정이니셜라이저를 구현하면 스토리보드로 작업하는게 되버리나?.. 왜 리콰이어 이닛이 필요해질까.
     */
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        self.init()
    }
    
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
