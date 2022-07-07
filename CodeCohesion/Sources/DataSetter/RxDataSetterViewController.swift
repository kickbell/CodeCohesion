//
//  RxDataSetterViewController.swift
//  CodeCohesion
//
//  Created by ios on 2022/07/06.
//

import RxSwift
import RxCocoa
import NSObject_Rx
import RxViewController

private func intToText(_ num: Int) -> String {
    return "\(num)"
}

class RxDataSetterViewController: UIViewController {
    
    @IBOutlet weak var textLabel01: UILabel!
    @IBOutlet weak var textLabel02: UILabel!
    
    let count = BehaviorRelay<Int>.init(value: 0)
    
    @IBAction func addOne(_ sender: Any) {
        count.accept(count.value + 1)
    }
    
    @IBAction func subOne(_ sender: Any) {
        count.accept(count.value - 1)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
    }
    
    private func bind() {
        
        count
            .map(intToText)
            .bind(to: textLabel01.rx.text)
            .disposed(by: rx.disposeBag)
        
        count
            .map { $0 * 10 }
            .map(intToText)
            .bind(to: textLabel02.rx.text)
            .disposed(by: rx.disposeBag)
    }
    
}
