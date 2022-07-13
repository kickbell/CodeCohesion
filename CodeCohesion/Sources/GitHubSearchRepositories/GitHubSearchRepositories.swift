//
//  GitHubSearchRepositories.swift
//  CodeCohesion
//
//  Created by jc.kim on 7/13/22.
//

import RxSwift
import RxCocoa

enum GitHubCommand {
    case changeSearch(text: String)
    case loadMoreItems
    case gitHubResponseReceived(SearchRepositoriesResponse)
}

struct GitHubSearchRepositoriesState {
    var searchText: String
    var shouldLoadNextPage: Bool
    var repositories: Version<[Repository]> // Version is an optimization. When something unrelated changes, we don't want to reload table view.
    var nextURL: URL?
    var failure: GitHubServiceError?
    
    init(searchText: String) {
        self.searchText = searchText
        shouldLoadNextPage = true
        repositories = Version.init([])
        nextURL = URL(string: "https://api.github.com/search/repositories?q=\(searchText.URLEscaped)")
        failure = nil
    }
}

extension GitHubSearchRepositoriesState {
    static let inital = GitHubSearchRepositoriesState(searchText: "")
    
    static func reduce(state: GitHubSearchRepositoriesState, command: GitHubCommand) -> GitHubSearchRepositoriesState {
        switch command {
        case .changeSearch(let text):
            return GitHubSearchRepositoriesState(searchText: text).mutateOne { $0.failure = state.failure
            }
        case .loadMoreItems:
            return state.mutate {
                if $0.failure == nil {
                    $0.shouldLoadNextPage = true
                }
            }
        case .gitHubResponseReceived(let result):
            switch result {
            case let .success((repositories, nextURL)):
                return state.mutate {
                    $0.repositories = Version($0.repositories.value + repositories)
                    $0.shouldLoadNextPage = false
                    $0.nextURL = nextURL
                    $0.failure = nil
                }
            case let .failure(error):
                return state.mutateOne { $0.failure = error }
            }
        }
    }
}


struct GitHubQuery: Equatable {
    let searchText: String
    let shouldLoadNextPage: Bool
    let nextURL: URL?
}


/**
 This method contains the gist of paginated GitHub search.
 
 */
func gitHubSearchRepositories(
    searchText: Signal<String>,
    loadNextPageTrigger: @escaping (Driver<GitHubSearchRepositoriesState>) -> Signal<()>,
    performSearch: @escaping (URL) -> Observable<SearchRepositoriesResponse>
) -> Driver<GitHubSearchRepositoriesState> {
    let searchPerformerFeedback: (Driver<GitHubSearchRepositoriesState>) -> Signal<GitHubCommand> = react(
        query: { state in
            GitHubQuery.init(searchText: state.searchText, shouldLoadNextPage: state.shouldLoadNextPage, nextURL: state.nextURL)
        },
        effects: { query in
            if !query.shouldLoadNextPage {
                return Signal.empty()
            }
            
            if query.searchText.isEmpty {
                return Signal.just(GitHubCommand.gitHubResponseReceived(.success((repositories: [], nextURL: nil))))
            }
            
            guard let nextURL = query.nextURL else {
                return Signal.empty()
            }
            
            return performSearch(nextURL)
                .asSignal(onErrorJustReturn: .failure(GitHubServiceError.networkError))
                .map(GitHubCommand.gitHubResponseReceived)
        }
    )
    
    let inputFeedbackLoop: (Driver<GitHubSearchRepositoriesState>) -> Signal<GitHubCommand> = { state in
        let loadNextPage = loadNextPageTrigger(state).map { _ in GitHubCommand.loadMoreItems }
        let searchText = searchText.map(GitHubCommand.changeSearch)
        
        return Signal.merge(loadNextPage, searchText)
    }
    
    return Driver.system(
        initialState: GitHubSearchRepositoriesState.inital,
        reduce: GitHubSearchRepositoriesState.reduce,
        feedback: searchPerformerFeedback, inputFeedbackLoop)
}


extension GitHubSearchRepositoriesState {
    var isOffline: Bool {
        guard let failure = self.failure else {
            return false
        }
        
        if case .offline = failure {
            return true
        } else {
            return false
        }
    }
    
    var isLimitExceeded: Bool {
        guard let failure = self.failure else {
            return false
        }
        
        if case .gitHubLimitReached = failure {
            return true
        } else {
            return false
        }
    }
}




extension GitHubSearchRepositoriesState: Mutable {
    
}
