//
//  GitHubSearchViewReactor.swift
//  CodeCohesion
//
//  Created by ios on 2022/07/13.
//

import ReactorKit
import RxSwift  
import RxCocoa

final class GitHubSearchViewReactor: Reactor {
    
    enum Action {
        case updateQuery(String?)
        case loadNextPage
    }
    
    enum Mutation {
        case setQuery(String?)
        case setRepos([String], nextPage: Int?)
        case appendRepos([String], nextPage: Int?)
        case setLoadingNextPage(Bool)
    }
    
    struct State {
        var query: String?
        var repos: [String] = []
        var nextPage: Int?
        var isLoadingNextPage: Bool = false
    }
    
    let initialState: State = State()
    
}
