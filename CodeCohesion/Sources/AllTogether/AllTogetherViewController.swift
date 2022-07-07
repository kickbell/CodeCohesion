//
//  AllTogetherViewController.swift
//  CodeCohesion
//
//  Created by ios on 2022/07/07.
//

import UIKit
import RxSwift
import RxCocoa

class AllTogetherViewController: UIViewController {
    
    @IBOutlet weak var firstNumberField: UITextField!
    @IBOutlet weak var secondNumberField: UITextField!
    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var calcButton: UIButton!
    
    let viewModel = CalcViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        bindUI()
        bindEvent()
    }
    
    private func bindUI() {
        
        //Input
        firstNumberField.rx.text
            .map(stringToInt)
            .withLatestFrom(viewModel.model) { firstNumber, model in
                CalcData(n1: firstNumber, n2: model.n2, result: model.result)
            }
            .bind(to: viewModel.model)
            .disposed(by: rx.disposeBag)
        
        secondNumberField.rx.text
            .map(stringToInt)
            .withLatestFrom(viewModel.model) { secondNumber, model in
                CalcData(n1: model.n1, n2: secondNumber, result: model.result)
            }
            .bind(to: viewModel.model)
            .disposed(by: rx.disposeBag)
        
        //Output
        viewModel.model.map { $0.result }
            .map(intToString)
            .bind(to: resultLabel.rx.text)
            .disposed(by: rx.disposeBag)
            
    }
    
    private func bindEvent() {
        //Event
        calcButton.rx.tap
            .withLatestFrom(viewModel.model)
            .map(viewModel.doCalc)
            .bind(to: viewModel.model)
            .disposed(by: rx.disposeBag)
    }
    
}
