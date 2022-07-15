//
//  Task.swift
//  CodeCohesion
//
//  Created by ios on 2022/07/15.
//

import Foundation


struct Task: Identifiable {
    var id: String = UUID().uuidString
    var title: String
    var memo: String?
    var isDone: Bool = false
    
    init(title: String, memo: String? = nil) {
        self.title = title
        self.memo = memo
    }
    
    //실패가능한 이니셜라이저
    init?(dictionary: [String: Any]) {
        guard let id = dictionary["id"] as? String,
              let title = dictionary["title"] as? String else {
            return nil
        }
        self.id = id
        self.title = title
        self.memo = dictionary["memo"] as? String
        self.isDone = dictionary["isDone"] as? Bool ?? false
    }
    
    func asDictionary() -> [String: Any] {
        var dictionary: [String: Any] = [
            "id": self.id,
            "title": self.title,
            "isDone": self.isDone
        ]
        if let memo = memo {
            dictionary["memo"] = memo
        }
        return dictionary
    }
    
    
}
