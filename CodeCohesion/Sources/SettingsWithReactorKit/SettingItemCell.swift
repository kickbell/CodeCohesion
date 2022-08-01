//
//  SettingItemCell.swift
//  CodeCohesion
//
//  Created by ios on 2022/08/01.
//

import UIKit

import ReactorKit

final class SettingItemCell: BaseTableViewCell, View {

  // MARK: Initializing

  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: .value1, reuseIdentifier: reuseIdentifier)
    self.accessoryType = .disclosureIndicator
  }


  // MARK: Configuring

  func bind(reactor: SettingItemCellReactor) {
    reactor.state
      .subscribe(onNext: { [weak self] state in
        self?.textLabel?.text = state.text
        self?.detailTextLabel?.text = state.detailText
      })
      .disposed(by: self.disposeBag)
  }

}


