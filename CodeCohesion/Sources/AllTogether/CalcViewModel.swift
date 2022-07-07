//
//  CalcViewModel.swift
//  CodeCohesion
//
//  Created by ios on 2022/07/07.
//

import RxSwift
import RxCocoa

let intToString = { (i: Int?) in "\(i ?? 0)" }
let stringToInt = { (s: String?) in Int(s ?? "0") }

class CalcViewModel {
    
    let model = BehaviorRelay<CalcData>(value: CalcData.empty())
    
    func doCalc(_ data: CalcData) -> CalcData {
        guard let n1 = data.n1 else { return data }
        guard let n2 = data.n2 else { return data }
        
        let result = n1 + n2
        return CalcData(n1: n1, n2: n2, result: result)
    }
    
}
