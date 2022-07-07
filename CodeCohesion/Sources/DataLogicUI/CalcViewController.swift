//
//  ViewController.swift
//  CodeCohesion
//
//  Created by ios on 2022/07/06.
//

import UIKit

class CalcViewController: UIViewController {
    
    // MARK: - DATA
    
    struct CalcData {
        let num1: Int
        let num2: Int
    }

    // MARK: - LOGIC
    
    private func textToInt(_ text: String?) -> Int {
        guard let text = text else { return 0 }
        return Int(text) ?? 0
    }
    
    private func intToText(_ num: Int) -> String {
        return "\(num)"
    }
    
    private func calcPlus(_ data: CalcData) -> Int {
        return data.num1 + data.num2
    }
    
    // MARK: - UI
    
    @IBOutlet weak var number1: UILabel!
    @IBOutlet weak var number2: UILabel!
    @IBOutlet weak var result: UILabel!

    @IBAction func calcResult(_ sender: Any) {
        let n1 = textToInt(number1.text)
        let n2 = textToInt(number2.text)
        let data = CalcData(num1: n1, num2: n2)
        let res = calcPlus(data)
        result.text = intToText(res)
    }

}

