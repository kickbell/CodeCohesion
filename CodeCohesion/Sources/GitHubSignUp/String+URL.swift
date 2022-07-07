//
//  String+URL.swift
//  CodeCohesion
//
//  Created by jc.kim on 7/8/22.
//

extension String {
    var URLEscaped: String {
       return self.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? ""
    }
}
