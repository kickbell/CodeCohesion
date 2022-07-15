//
//  TaskListViewController.swift
//  CodeCohesion
//
//  Created by ios on 2022/07/14.
//

import UIKit
import ReactorKit
import Then
import RxDataSources

class TaskListViewController: BaseViewController, View {
    
    // MARK: - Properties
    
    lazy var tableView = UITableView().then {
        $0.allowsSelectionDuringEditing = true //Edit 모드에 있는 동안 사용자가 셀을 선택할 수 있는지 여부를 결정하는 Bool 값
        $0.register(TaskCell.self, forCellReuseIdentifier: TaskCell.reuseIdentifier)
        $0.frame = view.frame
    }
    
    /*
     섹션이 1개고 헤더타이틀이 필요없으니 앞에는 Void 고 뒤에는 TaskCellReactor가 들어간다.
     보통 뒤에는 row에 들어갈 값 Double, Repository 같은 것들이 들어갔지만, 여기서는 Reactor가 들어간다는 것이 특이점이다.
     
     코드가 복잡해보일 수 있어서 아래처럼 TaskCellReactor에 구현해놓고 바꿀 수도 있다.
     let dataSource = RxTableViewSectionedReloadDataSource<TaskListSection>
     
     typealias TaskListSection = SectionModel<Void, TaskCellReactor>
     RxTableViewSectionedReloadDataSource<TaskListSection>
     
     extension, ReusableKit 활용하면 아래처럼 더 축약할 수도 있다.
     let cell = tableView.dequeue(Reusable.taskCell, for: indexPath)
     
     TaskCell.reuseIdentifier 처럼 축약을 또 할 수도 있다.
     */
    let dataSource = RxTableViewSectionedReloadDataSource<TaskListSection>(configureCell: { dataSource, tableView, indexPath, reactor in
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TaskCell.reuseIdentifier) as? TaskCell else {
            return UITableViewCell()
        }
        cell.reactor = reactor
        return cell
    })
    
    let addButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: nil, action: nil)
    
    // MARK: - View LifeCycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    // MARK: - Method
    
    private func setup() {
        self.reactor = TaskListViewReactor()
        self.title = "RxTodo"
        self.navigationItem.leftBarButtonItem = self.editButtonItem
        self.navigationItem.rightBarButtonItem = self.addButtonItem
        self.view.backgroundColor = .white
        self.view.addSubview(self.tableView)
    }
    
    // MARK: - Binding
    
    func bind(reactor: TaskListViewReactor) {
        reactor.state.map(\.sections)
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
    }

    
    

}


