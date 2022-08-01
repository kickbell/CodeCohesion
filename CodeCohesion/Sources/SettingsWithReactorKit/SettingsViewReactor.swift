//
//  SettingsViewReactor.swift
//  CodeCohesion
//
//  Created by ios on 2022/08/01.
//

import ReactorKit
import RxCocoa
import RxSwift

final class SettingsViewReactor: Reactor {
    enum Action {
        
    }
    
    struct State {
        var sections: [SettingsViewSection] = []
        
        init(sections: [SettingsViewSection]) {
          self.sections = sections
        }
    }
    
    let initialState: State
    
    init() {
        let aboutSection = SettingsViewSection.about([
            .version(SettingItemCellReactor(
                text: "version",
                detailText: "detail..."
            )),
            .github(SettingItemCellReactor(text: "view_on_github", detailText: "devxoul/Drrrible")),
            .icons(SettingItemCellReactor(text: "icons_from", detailText: "icons8.com")),
            .openSource(SettingItemCellReactor(text: "open_source_license", detailText: nil)),
        ])
        
        let logoutSection = SettingsViewSection.logout([
            .logout(SettingItemCellReactor(text: "logout", detailText: nil))
        ])
        
        let sections = [aboutSection] + [logoutSection]
        self.initialState = State(sections: sections)
        _ = self.state
    }
}
