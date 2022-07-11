//
//  WikipediaPage.swift
//  CodeCohesion
//
//  Created by jc.kim on 7/11/22.
//

import RxSwift

import Foundation

struct WikipediaPage {
    let title: String
    let text: String
    
    // tedious parsing part
    static func parseJSON(_ json: NSDictionary) throws -> WikipediaPage {
        guard
            let parse = json.value(forKey: "parse"),
            let title = (parse as AnyObject).value(forKey: "title") as? String,
            let t = (parse as AnyObject).value(forKey: "text"),
            let text = (t as AnyObject).value(forKey: "*") as? String else {
            throw apiError("Error parsing page content")
        }
        
        return WikipediaPage(title: title, text: text)
    }
}
