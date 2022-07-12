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
            return section.items.count > 0 ? "Repositories (\(section.items.count)" : "No repositories found"
        }
    )
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    
    
}
