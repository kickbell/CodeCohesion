//
//  SettingsViewSection.swift
//  CodeCohesion
//
//  Created by ios on 2022/08/01.
//

import RxDataSources

enum SettingsViewSection {
  case about([SettingsViewSectionItem])
  case logout([SettingsViewSectionItem])
}

extension SettingsViewSection: SectionModelType {
  
  var items: [SettingsViewSectionItem] {
    switch self {
    case .about(let items): return items
    case .logout(let items): return items
    }
  }
  
  init(original: Self, items: [SettingsViewSectionItem]) {
    switch original {
    case .about: self = .about(items)
    case .logout: self = .logout(items)
    }
  }
  
}


enum SettingsViewSectionItem {
  case version(SettingItemCellReactor)
  case github(SettingItemCellReactor)
  case icons(SettingItemCellReactor)
  case openSource(SettingItemCellReactor)
  case logout(SettingItemCellReactor)
}
