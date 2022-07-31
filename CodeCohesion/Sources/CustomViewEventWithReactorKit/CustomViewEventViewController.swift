//
//  CustomViewEvent.swift
//  CodeCohesion
//
//  Created by jc.kim on 8/1/22.
//

import UIKit
import ReactorKit
import RxSwift
import RxCocoa
import SnapKit

class CustomViewEventViewController: UIViewController {
    
    fileprivate let messageInputBar = MessageInputBar()
    
    var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        bind()
    }
    
    private func configure() {
        self.view.addSubview(self.messageInputBar)
        self.messageInputBar.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.height.equalTo(50)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom)
        }
    }
    
    private func bind() {
        self.messageInputBar.rx.sendButtonTap
            .debug()
            .subscribe()
            .disposed(by: disposeBag)
    }
}
