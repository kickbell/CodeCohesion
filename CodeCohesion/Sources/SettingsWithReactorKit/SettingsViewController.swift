//
//  SettingsViewController.swift
//  CodeCohesion
//
//  Created by ios on 2022/08/01.
//
import SafariServices
import UIKit

import ReactorKit
import RxDataSources
import SnapKit
import RxSwift
import RxCocoa

class SettingsViewController: UIViewController, View {
    
    typealias Reactor = SettingsViewReactor
    let dataSource: RxTableViewSectionedReloadDataSource<SettingsViewSection> = .init(configureCell: { dataSource, tableView, indexPath, sectionItem in
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SettingItemCell", for: indexPath) as? SettingItemCell else {
            return UITableViewCell()
        }
        switch sectionItem {
        case .version(let reactor):
            cell.reactor = reactor
            
        case .github(let reactor):
            cell.reactor = reactor
            
        case .icons(let reactor):
            cell.reactor = reactor
            
        case .openSource(let reactor):
            cell.reactor = reactor
            
        case .logout(let reactor):
            cell.reactor = reactor
        }
        return cell
    })
    
    let tableView = UITableView().then {
        $0.register(SettingItemCell.self, forCellReuseIdentifier: "SettingItemCell")
    }
    
    var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        self.reactor = SettingsViewReactor()
    }
    
    func configure() {
        self.view.addSubview(self.tableView)
        self.tableView.snp.makeConstraints { make in
          make.edges.equalToSuperview()
        }
    }
    
    func bind(reactor: Reactor) {
        reactor.state.map(\.sections)
          .bind(to: self.tableView.rx.items(dataSource: self.dataSource))
          .disposed(by: self.disposeBag)
        
        self.tableView.rx.itemSelected(dataSource: self.dataSource)
          .subscribe(onNext: { [weak self] sectionItem in
            guard let `self` = self, let reactor = self.reactor else { return }
            switch sectionItem {
            case .version:
                print("version...")
//              let viewController = self.versionViewControllerFactory()
//              self.navigationController?.pushViewController(viewController, animated: true)

            case .github:
              let url = URL(string: "https://github.com/devxoul/Drrrible")!
              let viewController = SFSafariViewController(url: url)
              self.present(viewController, animated: true, completion: nil)

            case .icons:
              let url = URL(string: "https://icons8.com")!
              let viewController = SFSafariViewController(url: url)
              self.present(viewController, animated: true, completion: nil)

            case .openSource:
                print("opensource..")
//              let viewController = CarteViewController()
//              self.navigationController?.pushViewController(viewController, animated: true)

            case .logout:
              let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
              let logoutAction = UIAlertAction(title: "logout", style: .destructive) { _ in
//                  reactor.action.onNext(.)
              }
              let cancelAction = UIAlertAction(title: "cancel", style: .cancel, handler: nil)
              [logoutAction, cancelAction].forEach(actionSheet.addAction)
              self.present(actionSheet, animated: true, completion: nil)
            }
          })
          .disposed(by: self.disposeBag)

        self.tableView.rx.itemSelected
          .subscribe(onNext: { [weak tableView] indexPath in
            tableView?.deselectRow(at: indexPath, animated: false)
          })
          .disposed(by: self.disposeBag)
    }
    
    
    
    
}


extension Reactive where Base: UITableView {
  func itemSelected<S>(dataSource: TableViewSectionedDataSource<S>) -> ControlEvent<S.Item> {
    let source = self.itemSelected.map { indexPath in
      dataSource[indexPath]
    }
    return ControlEvent(events: source)
  }
}
