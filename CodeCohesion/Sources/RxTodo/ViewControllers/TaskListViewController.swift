//
//  TaskListViewController.swift
//  CodeCohesion
//
//  Created by ios on 2022/07/14.
//

import UIKit
import ReactorKit
import Then

class TaskListViewController: BaseViewController, View {
    
    // MARK: - Properties
    
    lazy var tableView = UITableView().then {
        $0.allowsSelectionDuringEditing = true //Edit 모드에 있는 동안 사용자가 셀을 선택할 수 있는지 여부를 결정하는 Bool 값
        $0.register(TaskCell.self, forCellReuseIdentifier: String(describing: TaskCell.self))
        $0.frame = view.frame
    }
    let addButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: nil, action: nil)
    
    // MARK: - Initializing
    
    init(reactor: TaskListViewReactor) {
        super.init()
        self.navigationItem.leftBarButtonItem = self.editButtonItem
        self.navigationItem.rightBarButtonItem = self.addButtonItem
        self.reactor = reactor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.view.addSubview(self.tableView)
    }
    
    
    func bind(reactor: TaskListViewReactor) {
        
    }


}
