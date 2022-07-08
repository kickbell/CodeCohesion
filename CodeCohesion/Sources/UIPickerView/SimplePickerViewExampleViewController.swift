//
//  SimplePickerViewExampleViewController.swift
//  CodeCohesion
//
//  Created by ios on 2022/07/08.
//

import UIKit
import RxSwift
import RxCocoa
import NSObject_Rx

class SimplePickerViewExampleViewController: UIViewController {
    
    @IBOutlet weak var pickerView1: UIPickerView!
    @IBOutlet weak var pickerView2: UIPickerView!
    @IBOutlet weak var pickerView3: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
    }
    
    private func bind() {
        Observable.just(["WaterMelon", "Melon", "Banana"])
            .bind(to: pickerView1.rx.itemTitles) { (row, element) in
                return "row: \(row) element: \(element)"
            }
            .disposed(by: rx.disposeBag)
        
        pickerView1.rx.modelSelected(String.self)
            .subscribe(onNext: { models in
                print("models selected: \(models)") //["Melon"], ["Banana"]...
            })
            .disposed(by: rx.disposeBag)
        
        Observable.just(["WaterMelon", "Melon", "Banana"])
            .bind(to: pickerView2.rx.itemAttributedTitles) { (row, element) in
                return NSAttributedString(string: element,
                                          attributes: [
                                            NSAttributedString.Key.foregroundColor : UIColor.orange,
                                            NSAttributedString.Key.underlineStyle : NSUnderlineStyle.double.rawValue,
                                          ])
            }
            .disposed(by: rx.disposeBag)
        
        pickerView2.rx.modelSelected(String.self)
            .subscribe(onNext: { models in
                print("models selected: \(models)")
            })
            .disposed(by: rx.disposeBag)
        
        // MARK: - 커스텀 뷰를 올리는 것도 가능한가본데 ?
        Observable.just([UIColor.red, UIColor.green, UIColor.blue])
            .bind(to: pickerView3.rx.items) { _, item, _ in
                let view = UIView()
                view.backgroundColor = item
                return view
            }
            .disposed(by: rx.disposeBag)
        
        if #available(iOS 14.0, *) { //accessibilityName is ios 14.0 release
            pickerView3.rx.modelSelected(UIColor.self)
                .subscribe(onNext: { models in
                    print("models selected: \(models.map { $0.accessibilityName })")
                })
                .disposed(by: rx.disposeBag)
        }
    }
    
    
    
}
