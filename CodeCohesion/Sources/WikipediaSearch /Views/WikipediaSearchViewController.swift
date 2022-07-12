//
//  WikipediaSearchViewController.swift
//  CodeCohesion
//
//  Created by jc.kim on 7/11/22.
//

import UIKit
import RxSwift
import RxCocoa
import NSObject_Rx

class WikipediaSearchViewController: UIViewController {
    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var resultsTableView: UITableView!
    @IBOutlet var emptyView: UIView!
    
//    let results = BehaviorRelay<[String]>.init(value: ["a","b","c","d","e"])
//    let results = BehaviorRelay<[String]>.init(value: [])

    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableDataSource()
        configureKeyboardDismissesOnScroll()
        configureNavigateOnRowClick()
        configureActivityIndicatorsShow()
    }
    
    private func configureTableDataSource() {
        resultsTableView.register(UINib(nibName: "WikipediaSearchCell", bundle: nil), forCellReuseIdentifier: "WikipediaSearchCell")
        
        resultsTableView.rowHeight = 194
        resultsTableView.hideEmptyCells()
        
        let API = DefaultWikipediaAPI.sharedAPI
        
        let results = searchBar.rx.text.orEmpty
            .asDriver()
            .throttle(.milliseconds(300))
            .distinctUntilChanged()
            .flatMapLatest { query in
                API.searchResults(query)
                    .retry(3)
                    .startWith([])
                    .asDriver(onErrorJustReturn: [])
            }
            .map { results in
                results.map(SearchResultViewModel.init)
            }
        
        results
            .drive(resultsTableView.rx.items(cellIdentifier: "WikipediaSearchCell", cellType: WikipediaSearchCell.self)) { (_, viewModel, cell) in
//                cell.
            }
            .disposed(by: rx.disposeBag)
        
        results
            .map { $0.count != 0 }
            .drive(self.emptyView.rx.isHidden)
            .disposed(by: rx.disposeBag)
    }
    
    private func configureKeyboardDismissesOnScroll() {
        let searchBar = self.searchBar
        
        resultsTableView.rx.contentOffset
            .asDriver()
            .drive(onNext: { _ in
                if searchBar?.isFirstResponder ?? false {
                    _ = searchBar?.resignFirstResponder()
                }
            })
            .disposed(by: rx.disposeBag)
    }
    
    private func configureNavigateOnRowClick() {
        let wireframe = DefaultWireframe.shared
        
        resultsTableView.rx.modelSelected(SearchResultViewModel.self)
            .asDriver()
            .drive(onNext: { searchResult in
                wireframe.open(url: searchResult.searchResult.URL)
            })
            .disposed(by: rx.disposeBag)
    }
    
    private func configureActivityIndicatorsShow() {
        Driver.combineLatest(DefaultWikipediaAPI.sharedAPI.loadingWikipediaData,
                             DefaultWikipediaAPI.sharedAPI.loadingWikipediaData) { $0 || $1 }
            .distinctUntilChanged()
            .drive(UIApplication.shared.rx.isNetworkActivityIndicatorVisible)
            .disposed(by: rx.disposeBag)
    }
    
}



extension UITableView {
    func hideEmptyCells() {
        self.tableFooterView = UIView(frame: .zero)
    }
}
