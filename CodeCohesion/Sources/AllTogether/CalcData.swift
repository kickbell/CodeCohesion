//
//  Model.swift
//  CodeCohesion
//
//  Created by ios on 2022/07/07.
//

struct CalcData {
    let n1: Int?
    let n2: Int?
    let result: Int?
}

extension CalcData {
    static func empty() -> CalcData {
        return CalcData(n1: nil, n2: nil, result: nil)
    }
}
