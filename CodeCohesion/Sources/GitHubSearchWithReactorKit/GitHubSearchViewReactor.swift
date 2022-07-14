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
                // MARK: - 이전요청 취소, take(until:) 최적화 아주 중요. 자세한 설명은 아래로.
                self.search(query: query, page: 1)
                    .take(until: self.action.filter(Action.isUpdateQueryAction))
                    .map { Mutation.setRepos($0, nextPage: $1) }
            ])
        case .loadNextPage:
            guard !self.currentState.isLoadingNextPage else { return Observable.empty() }
            guard let page = self.currentState.nextPage else { return Observable.empty() }
            return Observable.concat([
                Observable.just(Mutation.setLoadingNextPage(true)),
                Observable.just(Mutation.appendRepos(Array(5...10).map { "\($0)" }, nextPage: page)),
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


// MARK: - API

extension GitHubSearchViewReactor {
    private func url(for query: String?, page: Int) -> URL? {
        guard let query = query, !query.isEmpty else { return nil }
        return URL(string: "https://api.github.com/search/repositories?q=\(query)&page=\(page)")
    }
    
    private func search(query: String?, page: Int) -> Observable<(repos: [String], nextPage: Int?)> {
        let emptyResult: ([String], Int?) = ([], nil)
        guard let url = self.url(for: query, page: page) else { return .just(emptyResult) }
        return URLSession.shared.rx.json(url: url)
            .map { json in
                guard let dict = json as? [String: Any] else { return emptyResult }
                guard let items = dict["items"] as? [[String: Any]] else { return emptyResult }
                let repos = items.compactMap { $0["full_name"] as? String }
                print(repos.isEmpty, "isempty??")
                let nextPage = repos.isEmpty ? nil : page + 1
                return (repos, nextPage)
            }
            .do(onError: { error in
                if case let .some(.httpRequestFailed(response, _)) = error as? RxCocoaURLError, response.statusCode == 403 { //굳.
                    print("⚠️ GitHub API rate limit exceeded. Wait for 60 seconds and try again.")
                }
            })
            .catchAndReturn(emptyResult)
    }
}


/*
  스트림을 방출할 것인데, 
  cancel previous request when the new `.updateQuery` action is fired
  take(until:)을 이용해서 새로운 요청이 들어오면 이전 요청을 취소할거야. 즉 종료시켜버리는거지.
  https://reactivex.io/documentation/operators/takeuntil.html
  그래서 until에 두번째 옵저버블을 넣을건데 action도 ActionSubejct, 즉 옵저버블이란 소리지. 그리고 filter가 있어.
  그 말은 여기에 정의된 특정 액션에 따라서 필터링을 해줄 수 있다는 말과 같아.
 
  1. 이렇게 말이야. 근데 이건 축약 전이야.
  self.search(query: query, page: 1)
      .take(until: self.action.filter { action in
          guard case .updateQuery = action else { return false }
          return true
      })
      .map { Mutation.setRepos($0, nextPage: $1) },
 
 
  2. 아래 메소드처럼 정의하면 이렇게 훨씬 더 줄일 수 있어.
  self.search(query: query, page: 1)
      .take(until: self.action.filter(Action.isUpdateQueryAction))
      .map { Mutation.setRepos($0, nextPage: $1) }
 */

extension GitHubSearchViewReactor.Action {
  static func isUpdateQueryAction(_ action: GitHubSearchViewReactor.Action) -> Bool {
    if case .updateQuery = action {
      return true
    } else {
      return false
    }
  }
}
