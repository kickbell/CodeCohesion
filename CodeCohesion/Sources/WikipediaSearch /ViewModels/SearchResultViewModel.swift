//
//  SearchResultViewModel.swift
//  CodeCohesion
//
//  Created by jc.kim on 7/11/22.
//

import RxSwift
import RxCocoa

class SearchResultViewModel {
    let searchResult: WikipediaSearchResult
    
    var title: Driver<String>
    var imageURLs: Driver<[URL]>
    
    let API = DefaultWikipediaAPI.sharedAPI
    let `$` = Dependencies.sharedDependencies
    
    init(searchResult: WikipediaSearchResult) {
        self.searchResult = searchResult
        
        //아마도 초기화값이 먼저 필요하니까 never로 해주고
        self.title = Driver.never()
        self.imageURLs = Driver.never()
        
        //API를 타서 값이 할당되면 다시 해주나보다?...
        let URLs = configureImageURLs()
        
        self.imageURLs = URLs.asDriver(onErrorJustReturn: [])
        self.title = configureTitle(URLs).asDriver(onErrorJustReturn: "Error during fetching")
    }
    
    private func configureTitle(_ imageURLs: Observable<[URL]>) -> Observable<String> {
        let searchResult = self.searchResult
        
        let loadingValue: [URL]? = nil
        
        return imageURLs
            .map(Optional.init)
            .startWith(loadingValue)
            .map { URLs in
                if let URLs = URLs {
                    return "\(searchResult.title) (\(URLs.count) pictures)"
                } else {
                    return "\(searchResult.title) (loading...)"
                }
            }
    }

    private func configureImageURLs() -> Observable<[URL]> {
        let searchResult = self.searchResult
        return API.articleContent(searchResult)
            .observe(on: `$`.backgroundWorkScheduler)
            .map { page in
                do {
                    return try parseImageURLsfromHTMLSuitableForDisplay(page.text as NSString)
                } catch {
                    return []
                }
            }
            .share(replay: 1)
    }
}
