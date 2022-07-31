//
//  CustomView.swift
//  CodeCohesion
//
//  Created by jc.kim on 8/1/22.
//

import Foundation
import UIKit
import SnapKit
import RxSwift
import RxCocoa

// MARK: - Reactive

extension Reactive where Base: MessageInputBar {
    
    var sendButtonTap: ControlEvent<String> {
        let source: Observable<String> = self.base.sendButton.rx.tap
            .withLatestFrom(self.base.textView.rx.text.orEmpty)
            .flatMap { text -> Observable<String> in
                return .just(text)
            }
            .do(onNext: { [weak base = self.base] _ in
                base?.textView.text = nil
            })
        return ControlEvent(events: source)
    }
    
}


final class MessageInputBar: UIView {
    
    // MARK: Constants
    
    private enum Metric {
        static let barHeight:CGFloat = 48.0
        static let barPaddingTopBottom:CGFloat = 7.0
        static let barPaddingLeftRight:CGFloat = 10.0
        static let sendButtonLeft:CGFloat = 7.0
    }
    
    // MARK: UI
    
    fileprivate let toolbar = UIToolbar()
    fileprivate let textView = UITextView().then {
        $0.font = UIFont.systemFont(ofSize: 15)
        $0.isEditable = true
        $0.showsVerticalScrollIndicator = false
        $0.textContainerInset.left = 8
        $0.textContainerInset.right = 8
        $0.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.6).cgColor
        $0.layer.borderWidth = 1 / UIScreen.main.scale
        $0.layer.cornerRadius = Metric.barHeight / 2 - Metric.barPaddingTopBottom
    }
    fileprivate let sendButton = UIButton(type: .system).then {
        $0.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        $0.setTitle(" 보내기 ", for: .normal)
    }
    
    
    // MARK: Initializing
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.toolbar)
        self.addSubview(self.textView)
        self.addSubview(self.sendButton)
        
        self.toolbar.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.bottom.equalToSuperview().offset(44) // enlarge background for iPhone X
        }
        
        self.textView.snp.makeConstraints { make in
            make.top.equalTo(Metric.barPaddingTopBottom)
            make.bottom.equalTo(-Metric.barPaddingTopBottom)
            make.left.equalTo(Metric.barPaddingLeftRight)
            make.right.equalTo(self.sendButton.snp.left).offset(-Metric.sendButtonLeft)
        }
        
        self.sendButton.snp.makeConstraints { make in
            make.top.equalTo(Metric.barPaddingLeftRight)
            make.bottom.equalTo(-Metric.barPaddingLeftRight)
            make.right.equalTo(-Metric.barPaddingLeftRight)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


