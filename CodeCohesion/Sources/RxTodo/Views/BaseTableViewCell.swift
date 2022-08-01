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
  }
  
  //convenience 가 있어야 self.init(...)이 호출이 된다. 음 중요할 수 있는 부분..이니셜라이져 위임.. 
  required convenience init?(coder aDecoder: NSCoder) {
    self.init(style: .default, reuseIdentifier: nil)
  }
  
}
