//
//  GitHubSearchRepositoriesViewController.swift
//  CodeCohesion
//
//  Created by jc.kim on 7/13/22.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources
import NSObject_Rx

extension UIScrollView {
    func isNearBottomEdge(edgeOffset: CGFloat = 20.0) -> Bool {
        self.contentOffset.y + self.frame.size.height + edgeOffset > self.contentSize.height
    }
}

class GitHubSearchRepositoriesViewController: UIViewController {
    static let startLoadingOffset: CGFloat = 20.0
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    
    let dataSource = RxTableViewSectionedReloadDataSource<SectionModel<String, Repository>>( //앞 헤더값, 뒤 셀데이터값
        configureCell: { _, tableView, indexPath, repository in
            if let cell = tableView.dequeueReusableCell(withIdentifier: "cell") {
                cell.textLabel?.text = repository.name
                cell.detailTextLabel?.text = repository.url.absoluteString
                return cell
            }
            return UITableViewCell()
        }, titleForHeaderInSection: { dataSource, sectionIndex in
            let section = dataSource[sectionIndex]
            return section.items.count > 0 ? "Repositories (\(section.items.count))" : "No repositories found"
        }
    )
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
    }
    
    private func bind() {
        
        let tableView: UITableView = self.tableView
        let loadNextPageTrigger: (Driver<GitHubSearchRepositoriesState>) -> Signal<()> = { state in
            tableView.rx.contentOffset.asDriver()
                .withLatestFrom(state)
                .flatMap { state in
                    return tableView.isNearBottomEdge(edgeOffset: 20.0) && !state.shouldLoadNextPage ? Signal.just(()) : Signal.empty()
                }
        }
        let activityIndicator = ActivityIndicator()
        let searchBar: UISearchBar = self.searchBar
        
        let state = gitHubSearchRepositories(
            searchText: searchBar.rx.text.orEmpty.changed.asSignal().throttle(.milliseconds(300)),
            loadNextPageTrigger: loadNextPageTrigger,
            performSearch: { URL in
                //api
                return Observable.just(SearchRepositoriesResponse.success((repositories: [
                    Repository(name: "hh", url: URL),
                    Repository(name: "hh22", url: URL),
                    Repository(name: "hh33", url: URL),
                    Repository(name: "hh55", url: URL),
                ], nextURL: nil)))
            }
        )
        
        state
            .map { $0.repositories }
            .distinctUntilChanged()
            .map { [SectionModel(model: "Repositories", items: $0.value)] }
            .drive(tableView.rx.items(dataSource: dataSource)) //이게 왜 되나 했는데, .mutationOne 같은 쪽에 inout 처리가 되어있어서 그러지 싶다.
            .disposed(by: rx.disposeBag)
        
        state
            .map { $0.isOffline }
            .drive(navigationController!.rx.isOffline)
            .disposed(by: rx.disposeBag)
        
        state
            .map { $0.isLimitExceeded }
            .distinctUntilChanged()
            .filter { $0 }
            .drive(onNext: { [weak self] n in
                guard let self = self else { return }
                
                let message = "Exceeded limit of 10 non authenticated requests per minute for GitHub API. Please wait a minute. :(\nhttps://developer.github.com/v3/#rate-limiting"
                
                self.present(UIAlertController(title: "RxExample", message: message, preferredStyle: .alert), animated: true)
            })
            .disposed(by: rx.disposeBag)
        
        tableView.rx.modelSelected(Repository.self)
            .subscribe(onNext: { repository in
                UIApplication.shared.open(repository.url)
            })
            .disposed(by: rx.disposeBag)
        
        //keyboard disappear in scrolling
        tableView.rx.contentOffset
            .subscribe { _ in
                if searchBar.isFirstResponder {
                    _ = searchBar.resignFirstResponder()
                }
            }
            .disposed(by: rx.disposeBag)
        
        tableView.rx.setDelegate(self)
            .disposed(by: rx.disposeBag)
        
        activityIndicator
            .drive(UIApplication.shared.rx.isNetworkActivityIndicatorVisible)
            .disposed(by: rx.disposeBag)
    }
    
    deinit {
        self.navigationController?.navigationBar.backgroundColor = nil
    }
}


extension GitHubSearchRepositoriesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
}
