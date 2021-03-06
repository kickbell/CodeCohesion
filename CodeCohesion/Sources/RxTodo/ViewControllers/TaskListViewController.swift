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
    
    // MARK: - Editing Mode
    /*
     생각보다 간단하다. 하지만 아래 2가지는 필수 조건이다.
     1. 내부적으로 제공되는 editButtonItem 아이템을 바버튼 아이템으로 넣는다.
     2. tableView.setEditing(editing, animated: true)를 꼭 실행시킨다. (setEditing 메소드를 오버라이드 해도 되고 상태값을 가져와서 해줘도 된다.)
     */
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        tableView.setEditing(editing, animated: true)
    }
    
    // MARK: - Method
    
    private func setup() {
        self.reactor = TaskListViewReactor(provider: ServiceProvider())
        self.title = "RxTodo"
        self.navigationItem.rightBarButtonItems = [addButtonItem, editButtonItem]
        self.view.backgroundColor = .white
        self.view.addSubview(tableView)
    }
    
    // MARK: - Binding
    
    func bind(reactor: TaskListViewReactor) {
        /*
         이 코드 여기말고 viewDidLoad 같은 곳에 적으면 에러가 발생한다.
         RxDataSources/TableViewSectionedDataSource.swift:76: Assertion failed: Data source is already bound. Please write this line before binding call (`bindTo`, `drive`). Data source must first be completely configured, and then bound after that, otherwise there could be runtime bugs, glitches, or partial malfunctions.
         */
        self.dataSource.canEditRowAtIndexPath = { _, _  in true }
        self.dataSource.canMoveRowAtIndexPath = { _, _  in true }
        
        self.rx.viewWillAppear
            .map { _ in Reactor.Action.refresh }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        reactor.state.map(\.sections)
            .debug("sections...")
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        /*
         RxCocoa에 이미 구현되어 있다.(itemDeleted, itemMoved...)
         방식은 똑같다. RxCocoa에 있는 DelegateProxy 를 사용한다.
         
         public var itemDeleted: ControlEvent<IndexPath> {
         let source = self.dataSource.methodInvoked(#selector(UITableViewDataSource.tableView(_:commit:forRowAt:)))
         .filter { a in
         return UITableViewCell.EditingStyle(rawValue: (try castOrThrow(NSNumber.self, a[1])).intValue) == .delete
         }
         .map { a in
         return try castOrThrow(IndexPath.self, a[2])
         }
         
         return ControlEvent(events: source)
         }
         */
        tableView.rx.itemDeleted
            .map(Reactor.Action.deleteTask)
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        tableView.rx.itemMoved
            .map(Reactor.Action.moveTask)
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        addButtonItem.rx.tap
            .map(reactor.reactorForCreatingTask)
            .subscribe(onNext: { [weak self] taskEditViewReactor in
                guard let `self` = self else { return }
                let viewController = TaskEditViewController(reactor: taskEditViewReactor)
                let navigationController = UINavigationController(rootViewController: viewController) //네비 아이템들을 넣었으므로 꼭 필요
                self.present(navigationController, animated: true, completion: nil)
            })
            .disposed(by: disposeBag)
        
        tableView.rx.modelSelected(type(of: self.dataSource).Item.self)
            .map(reactor.reactorForEditingTask)
            .subscribe(onNext: { [weak self] taskEditViewReactor in
                guard let `self` = self else { return }
                let viewController = TaskEditViewController(reactor: taskEditViewReactor)
                let navigationController = UINavigationController(rootViewController: viewController) //네비 아이템들을 넣었으므로 꼭 필요
                self.present(navigationController, animated: true, completion: nil)
            })
            .disposed(by: disposeBag)
    }
    
    
    
    
}
