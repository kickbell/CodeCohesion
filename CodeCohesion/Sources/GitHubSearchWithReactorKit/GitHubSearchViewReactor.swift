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
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .updateQuery(let query):
            return Observable.concat([
                Observable.just(Mutation.setQuery(query)),
                Observable.just(Mutation.setRepos(["123","456","890"], nextPage: 1))
            ])
        case .loadNextPage:
            guard !self.currentState.isLoadingNextPage else { return Observable.empty() }
            guard let page = self.currentState.nextPage else { return Observable.empty() }
            return Observable.concat([
                Observable.just(Mutation.setLoadingNextPage(true)),
                Observable.just(Mutation.appendRepos(["vv","dd"], nextPage: 2)),
                Observable.just(Mutation.setLoadingNextPage(false))
            ])
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        switch mutation {
        case .setQuery(let query):
            var newState = state
            newState.query = query
            return newState
            
        case .setRepos(let repos, let nextPage):
            var newState = state
            newState.repos = repos
            newState.nextPage = nextPage
            return newState
            
        case .appendRepos(let repos, let nextPage):
            var newState = state
            newState.repos.append(contentsOf: repos)
            newState.nextPage = nextPage
            return newState
            
        case .setLoadingNextPage(let isLoadingNextPage):
            var newState = state
            newState.isLoadingNextPage = isLoadingNextPage
            return newState
        }
    }
    
}
