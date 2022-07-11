//
//  WikipediaSearchResult.swift
//  CodeCohesion
//
//  Created by jc.kim on 7/11/22.
//

import RxSwift
import Foundation

struct WikipediaSearchResult: CustomDebugStringConvertible {
    let title: String
    let description: String
    let URL: Foundation.URL
    
    static func parseJSON(_ json: [AnyObject]) throws -> [WikipediaSearchResult] {
        let rootArrayTyped = json.compactMap { $0 as? [AnyObject] }
        
        guard rootArrayTyped.count == 3 else {
            throw WikipediaParseError
        }
        
        let (titles, descriptions, urls) = (rootArrayTyped[0], rootArrayTyped[1], rootArrayTyped[2])
        
        let titleDescriptionAndUrl: [((AnyObject, AnyObject), AnyObject)] = Array(zip(zip(titles, descriptions), urls))
        
        return try titleDescriptionAndUrl.map { result in
            let ((title, description), url) = result
            
            guard let titleString = title as? String,
                  let descriptionString = description as? String,
                  let urlString = url as? String,
                  let URL = Foundation.URL(string: urlString) else {
                throw WikipediaParseError
            }
            
            return WikipediaSearchResult(title: titleString, description: descriptionString, URL: URL)
        }
    }
}

extension WikipediaSearchResult {
    var debugDescription: String {
        "[\(title)](\(URL))"
    }
}

