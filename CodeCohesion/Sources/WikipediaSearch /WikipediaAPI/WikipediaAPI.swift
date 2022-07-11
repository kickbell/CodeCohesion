//
//  WikipediaAPI.swift
//  CodeCohesion
//
//  Created by jc.kim on 7/11/22.
//

import RxSwift
import RxCocoa

func apiError(_ error: String) -> NSError {
    return NSError(domain: "WikipediaAPI", code: -1, userInfo: [NSLocalizedDescriptionKey: error])
}

public let WikipediaParseError = apiError("Error during parsing")

protocol WikipediaAPI {
    func searchResults(_ query: String) -> Observable<[WikipediaSearchResult]>
    func articleContent(_ searchResult: WikipediaSearchResult) -> Observable<WikipediaPage>
}

class DefaultWikipediaAPI: WikipediaAPI {
    
    static let sharedAPI = DefaultWikipediaAPI()
    
    private init() {}
    
    let `$`: Dependencies = Dependencies.sharedDependencies
    
    let loadingWikipediaData = ActivityIndicator()
    
    private func JSON(_ url:URL) -> Observable<Any> {
        `$`.URLSession
            .rx.json(url: url)
            .trackActivity(loadingWikipediaData)
    }
    
    func searchResults(_ query: String) -> Observable<[WikipediaSearchResult]> {
        let escapedQuery = query.URLEscaped
        let urlContent = "http://en.wikipedia.org/w/api.php?action=opensearch&search=\(escapedQuery)"
        let url = URL(string: urlContent)!
        
        return JSON(url)
            .observe(on: `$`.backgroundWorkScheduler)
            .map { json in
                guard let json = json as? [AnyObject] else {
                    throw exampleError("Parsing error")
                }
                
                return try WikipediaSearchResult.parseJSON(json)
            }
            .observe(on: `$`.mainScheduler)
    }
    
    func articleContent(_ searchResult: WikipediaSearchResult) -> Observable<WikipediaPage> {
        let escapedPage = searchResult.title.URLEscaped
        guard let url = URL(string: "http://en.wikipedia.org/w/api.php?action=parse&page=\(escapedPage)&format=json") else {
            return Observable.error(apiError("Can't create url"))
        }
        
        return JSON(url)
            .map { jsonResult in
                guard let json = jsonResult as? NSDictionary else {
                    throw exampleError("Parsing error")
                }
                
                return try WikipediaPage.parseJSON(json)
            }
            .observe(on: `$`.mainScheduler)        
    }
    
    
}



func exampleError(_ error: String, location: String = "\(#file):\(#line)") -> NSError {
    return NSError(domain: "ExampleError", code: -1, userInfo: [NSLocalizedDescriptionKey: "\(location): \(error)"])
}
