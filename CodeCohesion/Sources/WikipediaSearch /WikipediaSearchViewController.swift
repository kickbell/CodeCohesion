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

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
}
