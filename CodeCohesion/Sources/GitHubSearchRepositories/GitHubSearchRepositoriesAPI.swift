//
//  GitHubSearchRepositoriesAPI.swift
//  CodeCohesion
//
//  Created by jc.kim on 7/13/22.
//

import Foundation

struct Repository: CustomDebugStringConvertible {
    var name: String
    var url: URL
}

extension Repository {
    var debugDescription: String {
        "\(name) | \(url)"
    }
}

enum GitHubServiceError: Error {
    case offline
    case gitHubLimitReached
    case networkError
}

typealias SearchRepositoriesResponse = Result<(repositories: [Repository], nextURL: URL?), GitHubServiceError>




class GitHubSearchRepositoriesAPI {
    
    
}
