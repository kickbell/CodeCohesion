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
    
    let results = BehaviorRelay<[String]>.init(value: ["a","b","c","d","e"])
//    let results = BehaviorRelay<[String]>.init(value: [])

    override func viewDidLoad() {
        super.viewDidLoad()

        resultsTableView.register(UINib(nibName: "WikipediaSearchCell", bundle: nil), forCellReuseIdentifier: "WikipediaSearchCell")
        
        resultsTableView.rowHeight = 194
        resultsTableView.hideEmptyCells()
        
        
        results
            .asDriver(onErrorJustReturn: [])
            .drive(resultsTableView.rx.items(cellIdentifier: "WikipediaSearchCell", cellType: WikipediaSearchCell.self)) { (_, viewModel, cell) in
                cell.titleOutlet.text = viewModel
                cell.URLOutlet.text = viewModel
            }
            .disposed(by: rx.disposeBag)
        
        results
            .asDriver(onErrorJustReturn: [])
            .map { $0.count != 0 }
            .drive(self.emptyView.rx.isHidden)
            .disposed(by: rx.disposeBag)
            
    }
    
}



extension UITableView {
    func hideEmptyCells() {
        self.tableFooterView = UIView(frame: .zero)
    }
}
