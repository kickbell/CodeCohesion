//
//  GitHubSearchViewController.swift
//  CodeCohesion
//
//  Created by ios on 2022/07/13.
//

import UIKit
import RxSwift
import RxCocoa
import ReactorKit

class GitHubSearchViewController: UIViewController, StoryboardView {
    @IBOutlet weak var tableView: UITableView!
    let searchController = UISearchController(searchResultsController: nil)
    var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        deprecated
//        tableView.scrollIndicatorInsets.top = tableView.contentInset.top
//        searchController.dimsBackgroundDuringPresentation = false
        navigationItem.searchController = searchController
        title = "GitHub Search"
    }
    
    // MARK: - 아 이게 있으면, 시작하자마자 first responsor 처럼 바로 검색바가 선택되면서 애니메이션이 실행됨
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIView.setAnimationsEnabled(false)
        searchController.isActive = true
        searchController.isActive = false
        UIView.setAnimationsEnabled(true)
    }
    
    func bind(reactor: GitHubSearchViewReactor) {
        searchController.searchBar.rx.text
            .throttle(.milliseconds(300), scheduler: MainScheduler.instance)
            .map { Reactor.Action.updateQuery($0)}
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        tableView.rx.contentOffset
            .filter { [weak self] offset in
                guard let `self` = self else { return false }
                guard self.tableView.frame.height > 0 else { return false }
                return offset.y + self.tableView.frame.height >= self.tableView.contentSize.height - 100
            }
            .map { _ in Reactor.Action.loadNextPage }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
    }
    
    

}
