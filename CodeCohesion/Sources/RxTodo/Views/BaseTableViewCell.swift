//
//  BaseTableViewCell.swift
//  CodeCohesion
//
//  Created by ios on 2022/07/14.
//

import UIKit

import RxSwift

class BaseTableViewCell: UITableViewCell {
    
    // MARK: Properties

    var disposeBag: DisposeBag = DisposeBag()


    // MARK: Initializing

      override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
      super.init(style: style, reuseIdentifier: reuseIdentifier)
      self.initialize()
    }

    required init?(coder aDecoder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
    }

    func initialize() {
      // Override point
    }

}
