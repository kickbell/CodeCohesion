//
//  CustomPickerViewAdapterExampleViewController.swift
//  CodeCohesion
//
//  Created by ios on 2022/07/08.
//

import UIKit
import RxSwift
import RxCocoa
import NSObject_Rx

class CustomPickerViewAdapterExampleViewController: UIViewController {
    
    @IBOutlet weak var pickerView: UIPickerView!

    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
    }
    
    private func bind() {
        Observable.just([[1, 2, 3],[5, 8, 13],[21, 34]])
            .bind(to: pickerView.rx.items(adapter: PickerViewViewAdapter()))
            .disposed(by: rx.disposeBag)
        
        pickerView.rx.modelSelected(Int.self)
            .subscribe(onNext: { models in
                print(models)
            })
            .disposed(by: rx.disposeBag)
    }

}
