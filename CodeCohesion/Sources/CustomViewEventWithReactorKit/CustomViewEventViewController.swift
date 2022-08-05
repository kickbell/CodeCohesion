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

class CustomViewEventViewController: UIViewController, View {
    
    typealias Reactor = CustomViewEventReactor
    
    private let messageInputBar = MessageInputBar()
    
    private let tableView = UITableView().then {
        $0.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    private func configure() {
        self.reactor = CustomViewEventReactor()
        self.view.addSubview(tableView)
        self.view.addSubview(self.messageInputBar)
        
        self.tableView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
        }
        
        self.messageInputBar.snp.makeConstraints { make in
            make.top.equalTo(tableView.snp.bottom)
            make.left.right.equalToSuperview()
            make.height.equalTo(50)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom)
        }
    }
    
    func bind(reactor: CustomViewEventReactor) {
        self.messageInputBar.rx.sendButtonTap
            .map(Reactor.Action.send)
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        reactor.state.map(\.chats)
            .bind(to: tableView.rx.items(cellIdentifier: "cell", cellType: UITableViewCell.self)) { _, element, cell in
                cell.textLabel?.textAlignment = element.count % 2 == 0 ? .left : .right
                cell.textLabel?.text = element
            }
            .disposed(by: disposeBag)
    }
    
}
