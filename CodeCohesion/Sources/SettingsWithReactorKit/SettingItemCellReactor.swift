//
//  SettingItemCellReactor.swift
//  CodeCohesion
//
//  Created by ios on 2022/08/01.
//

import ReactorKit
import RxCocoa
import RxSwift

final class SettingItemCellReactor: Reactor {
  typealias Action = NoAction
  
  struct State {
    var text: String?
    var detailText: String?
  }
  
  let initialState: State
  
  init(text: String?, detailText: String?) {
    self.initialState = State(text: text, detailText: detailText)
    _ = self.state
  }
}
